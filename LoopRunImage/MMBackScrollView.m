//
//  MMBackScrollView.m
//  LoopRunImage
//
//  Created by 马少洋 on 16/6/2.
//  Copyright © 2016年 马少洋. All rights reserved.
//


#import "MMBackScrollView.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIImageView+WebCache.h"



@interface MMBackScrollView ()<UIScrollViewDelegate>

/** 代理 */
@property (nonatomic,weak)id<MMBackScrollViewDelegate> customDelegate;
/** 页码 */
@property (nonatomic,strong)UIPageControl * pageControl;
@property (nonatomic,strong)dispatch_source_t timer;
@property (nonatomic,assign)CGFloat lastScroll;
@property (nonatomic,assign)Class name;
@property (nonatomic,assign)Class otherName;
/** 是否挂起 */
@property (nonatomic,assign)BOOL flag;

/** 返回page的frame */
- (CGRect)mmPageFrame;
/** 设置选中的页码颜色 */
- (UIColor *)mmCurrentPageIndicatorTintColor;
/** 设置未选中的页码颜色 */
- (UIColor *)mmPageIndicatorTintColor;
/** 设置默认页数 */
- (NSInteger)mmSetCurrentPageNumber;
/** 用户拖拽事件 到计时器开始自动滚动的时间间隔 */
- (CGFloat)mmSetDranggingStartScrollTimeInterval;
/** 页码按钮是不是可以被点击 */
- (BOOL)mmSetPageEnabled;
/** 滚动动画的时间 */
- (NSTimeInterval)mmSetAnimationTimeinterval;

@end
@implementation MMBackScrollView

-(instancetype)initWithFrame:(CGRect)frame AndSuperView:(UIView *)superView Delegate:(UIViewController<MMBackScrollViewDelegate> *)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.customDelegate = delegate;
        self.name = [self.customDelegate class];
        [superView addSubview:self];
        [self mmCreatePageSuperView:superView];
        [self setUpScrollView];
        if(self.customDelegate && [self.customDelegate isKindOfClass:[UIViewController class]]){
            [self change:delegate];
        }
    }
    return self;
}
/** 传过来图片数组 NSArray(UIImage *) * array */
- (void)upDataScrollViewImageArray:(NSArray *)imageArray PlaceholderImage:(UIImage *)placeholderImage{
    if(imageArray.count == 0){
        NSLog(@"图片数组为空");
        return;
    }
    self.pageControl.numberOfPages = imageArray.count;
    self.pageControl.currentPage = self.mmSetCurrentPageNumber;
    [self createImageViewByImageArray:imageArray PlaceholderImage:placeholderImage];
    /** 计时器开始 */
    [self mmSetTimer];
    
}
#pragma mark -- 创建页码
/** 创建页码 */
- (void)mmCreatePageSuperView:(UIView *)superView{
    self.pageControl = [[UIPageControl alloc]initWithFrame:self.mmPageFrame];
    self.pageControl.currentPageIndicatorTintColor = self.mmCurrentPageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = self.mmPageIndicatorTintColor;
    self.pageControl.enabled = self.mmSetPageEnabled;
    self.pageControl.hidesForSinglePage = YES;
    [superView addSubview:self.pageControl];
    if (self.pageControl.enabled) {
        [self.pageControl addTarget:self action:@selector(pageControlEnable:) forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark -- 创建图片数组ImageView
/** 创建图片数组ImageView */
- (void)createImageViewByImageArray:(NSArray *)imageArray PlaceholderImage:(UIImage *)placeholderImage{
    NSMutableArray * dataSource = [[NSMutableArray alloc]initWithArray:imageArray];
    [dataSource insertObject:[imageArray lastObject] atIndex:0];
    [dataSource addObject:[imageArray firstObject]];
    self.contentSize = CGSizeMake(dataSource.count * self.frame.size.width, self.frame.size.height);
    for (NSInteger i = 0; i < dataSource.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        [self MMImageViewAddGesture:imageView];
        [self addImageToImageViewByArgument:dataSource[i] AndImageView:imageView PlaceholderImage:placeholderImage];
        [self addSubview:imageView];
        if (i == 0) {
            imageView.tag = imageArray.count - 1 + TAG;
        }else if (i == dataSource.count - 1){
            imageView.tag = 0 + TAG;
        }else{
            imageView.tag = i - 1 + TAG;
        }
    }
}
/** 添加图片到imageView上 */
- (void)addImageToImageViewByArgument:(id)argument AndImageView:(UIImageView *)imageView PlaceholderImage:(UIImage *)placeholderImage{
    if ([argument isKindOfClass:[UIImage class]]) {
        imageView.image = (UIImage *)argument;
        return;
    }
    if ([argument isKindOfClass:[NSString class]]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)argument] placeholderImage:placeholderImage];
        return;
    }
}
/** 设置scrollView */
- (void)setUpScrollView{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.bounces = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customAppear:) name:@"MmDealloc" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customAppear:) name:@"MmAppear" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(customDisAppear:) name:@"MmDisAppear" object:nil];
}
- (void)customDealloc{
    if (!self.flag) {
        dispatch_resume(self.timer);
        dispatch_source_cancel(self.timer);
    }
    dispatch_source_cancel(self.timer);
    NSLog(@"%@",self.timer);
    object_setClass(self.customDelegate, self.name);
    objc_msgSend(self.customDelegate, NSSelectorFromString(@"dealloc"));
}
- (void)customAppear:(NSNotification *)noti{
    if (!self.flag) {
        self.flag = YES;
        dispatch_resume(self.timer);
    }
    object_setClass(self.customDelegate, self.name);
    objc_msgSend(self.customDelegate, @selector(viewWillAppear:),[noti.object boolValue]);
    object_setClass(self.customDelegate, self.otherName);
}
- (void)customDisAppear:(NSNotification *)noti{
    if (self.flag) {
        self.flag = NO;
//        dispatch_suspend(self.timer);
    }
    object_setClass(self.customDelegate, self.name);
    objc_msgSend(self.customDelegate, @selector(viewDidDisappear:),[noti.object boolValue]);
    object_setClass(self.customDelegate, self.otherName);
}
#pragma mark -- 添加手势
/** 添加手势 */
- (void)MMImageViewAddGesture:(UIView *)argumentView {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mmTapGestureDidCliked:)];
    [argumentView addGestureRecognizer:tapGesture];
}
#pragma mark -- 手势出现
/** 手势出现 */
- (void)mmTapGestureDidCliked:(UITapGestureRecognizer *)tapGesture {
    if([self.customDelegate respondsToSelector:@selector(setMMBackScrollView:ImageViewDidCliked:)]){
        [self.customDelegate  setMMBackScrollView:self ImageViewDidCliked:tapGesture.view.tag - TAG];
    }
}
#pragma mark -- 页码被点击
/** 页码被点击 */
- (void)pageControlEnable:(UIPageControl *)pageControl {
    dispatch_suspend(self.timer);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_resume(self.timer);
    });
    [self setContentOffset:CGPointMake(pageControl.currentPage * self.frame.size.width, 0) animated:YES];
}
#pragma mark -- 设置及时器
/** 设置计时器 */
- (void)mmSetTimer {
    __weak typeof(self)weakself = self;
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, [self scrollNextTimer] * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [weakself useScrollViewContentOffsetScroll];
        if (false) {
            dispatch_source_cancel(self.timer);/** 停止永远不会执行 */
        }
    });
    dispatch_source_set_cancel_handler(self.timer, ^{

    });
    if (!self.customDelegate || ![self.customDelegate isKindOfClass:[UIViewController class]]) {
        dispatch_resume(self.timer);
    }
//    dispatch_resume(timer);
}
#pragma mark -- 使用定时器让scrollView滚动
/** 使用定时器让scrollView滚动 */
- (void)useScrollViewContentOffsetScroll{
    NSInteger num = self.contentOffset.x / self.frame.size.width;
    [UIView animateWithDuration:self.mmSetAnimationTimeinterval delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.contentOffset = CGPointMake((num + 1) * self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        if (num == self.pageControl.numberOfPages) {
            self.contentOffset = CGPointMake(self.frame.size.width, 0);
        }
        self.pageControl.currentPage = self.contentOffset.x / self.frame.size.width - 1;
    }];
}

#pragma mark -- 获取用户指定的信息
/** 设置page的frame */
- (CGRect)mmPageFrame{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewPageFrame:)]) {
        return [self.customDelegate setMMBackScrollViewPageFrame:self];
    }
    return CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 15);
}
/** 设置选中的页码颜色 */
- (UIColor *)mmCurrentPageIndicatorTintColor{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewCurrentPageIndicatorTintColor:)]) {
        return [self.customDelegate setMMBackScrollViewCurrentPageIndicatorTintColor:self];
    }
    return [UIColor blackColor];
}
/** 设置未选中的页码颜色 */
- (UIColor *)mmPageIndicatorTintColor{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewPageIndicatorTintColor:)]) {
        return [self.customDelegate setMMBackScrollViewPageIndicatorTintColor:self];
    }
    return [UIColor whiteColor];
}
/** 设置默认页数 */
- (NSInteger)mmSetCurrentPageNumber{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewCurrentPageNumber:)]) {
        return [self.customDelegate setMMBackScrollViewCurrentPageNumber:self];
    }
    return 0;
}
/** 用户拖拽事件 到计时器开始自动滚动的时间间隔 */
- (CGFloat)mmSetDranggingStartScrollTimeInterval {
    if([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewDranggingStartScrollTimeInterval:)]){
        return [self.customDelegate setMMBackScrollViewDranggingStartScrollTimeInterval:self];
    }
    return 2.0f;
}
/** 页码按钮是不是可以被点击 */
- (BOOL)mmSetPageEnabled{
       return NO;
}
/** 滚动动画的时间 */
- (NSTimeInterval)mmSetAnimationTimeinterval{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewAnimationTimeIntervalBackScrollView:)]) {
        [self.customDelegate setMMBackScrollViewAnimationTimeIntervalBackScrollView:self];
    }
    return 0.35f;
}
/**滚动到下一屏的时间*/
- (NSTimeInterval)scrollNextTimer{
    if (self.customDelegate && [self.customDelegate isKindOfClass:[UIViewController class]]) {
        return  [self.customDelegate scrollToNextImageTimeInterval:self];
    }
    return 0.5f;
}
#pragma mark -- scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_FOREVER, [self scrollNextTimer] * NSEC_PER_SEC, 0);

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_source_set_timer(self.timer, dispatch_walltime(DISPATCH_TIME_NOW, self.mmSetDranggingStartScrollTimeInterval * NSEC_PER_SEC), [self scrollNextTimer] * NSEC_PER_SEC, 0);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger num = self.contentOffset.x / self.frame.size.width;
    if (num == 0) {
        self.contentOffset = CGPointMake(self.contentSize.width - (2 * self.frame.size.width), 0);
        self.pageControl.currentPage = self.contentOffset.x / self.frame.size.width - 1;
        return;
    }
    if (num == self.pageControl.numberOfPages + 1) {
        self.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.pageControl.currentPage = self.contentOffset.x / self.frame.size.width - 1;
        return;
    }
    self.pageControl.currentPage = self.contentOffset.x / self.frame.size.width - 1;
}
- (void)change:(UIViewController *)viewController{
    Class className = objc_allocateClassPair([viewController class], "msyCreateSubClass", 0);
    self.otherName = className;
    class_addMethod(className, NSSelectorFromString(@"viewWillAppear:"), (IMP)customViewWillAppear, "v@:B");
    class_addMethod(className, NSSelectorFromString(@"viewDidDisappear:"), (IMP)customViewDidDisappear,"v@:B");
    class_addMethod([viewController class], NSSelectorFromString(@"dealloc"), (IMP)customDealloc, "v@:");
    object_setClass(viewController, className);
}
void customDealloc(id obj,SEL method){
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MmDealloc" object:nil];
}
void customViewWillAppear(id obj ,SEL method,bool animation){
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MmAppear" object:@(animation)];
}
void customViewDidDisappear(id obj ,SEL method,bool animation){
      [[NSNotificationCenter defaultCenter]postNotificationName:@"MmDisAppear" object:@(animation)];
}
@end
