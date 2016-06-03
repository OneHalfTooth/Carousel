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


typedef enum{
    ImageViewCreateByUrl = 0,/** 通过图片url创建imageView */
    ImageViewCreateByImage,/** 通过图片创建ImageView */
}ImageViewCreateType;
@interface MMBackScrollView ()<UIScrollViewDelegate>

/** 代理 */
@property (nonatomic,weak)id<MMBackScrollViewDelegate> customDelegate;
/** 页码 */
@property (nonatomic,strong)UIPageControl * pageControl;
@property (nonatomic,assign)dispatch_source_t timer;
@property (nonatomic,assign)CGFloat lastScroll;


/** 返回page的frame */
- (CGRect)mmPageFrame;
/** 设置选中的页码颜色 */
- (UIColor *)mmCurrentPageIndicatorTintColor;
/** 设置未选中的页码颜色 */
- (UIColor *)mmPageIndicatorTintColor;
/** 设置默认页数 */
- (NSInteger)mmSetCurrentPageNumber;

@end
@implementation MMBackScrollView

-(instancetype)initWithFrame:(CGRect)frame AndSuperView:(UIView *)superView Delegate:(id <MMBackScrollViewDelegate>)delegate{

    self = [super initWithFrame:frame];
    if (self) {
        self.customDelegate = delegate;
        [superView addSubview:self];
        [self mmCreatePageSuperView:superView];
        [self setUpScrollView];
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
    self.pageControl.enabled = NO;
    [superView addSubview:self.pageControl];
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
#pragma mark -- 添加手势
/** 添加手势 */
- (void)MMImageViewAddGesture:(UIView *)argumentView {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mmTapGestureDidCliked:)];
    [argumentView addGestureRecognizer:tapGesture];
}
#pragma mark -- 手势出现
/** 手势出现 */
- (void)mmTapGestureDidCliked:(UITapGestureRecognizer *)tapGesture {
    [self.customDelegate scrollViewImageViewDidCliked:tapGesture.view.tag - TAG];
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
}
#pragma mark -- 设置及时器
/** 设置计时器 */
- (void)mmSetTimer {
    __weak typeof(self)weakself = self;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, [self.customDelegate scrollToNextImageTimeInterval] * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        [weakself useScrollViewContentOffsetScroll];
        if (false) {
            dispatch_source_cancel(timer);/** 停止永远不会执行 */
        }
    });
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"cancel");
    });
    
    dispatch_resume(timer);
    self.timer = timer;
}
#pragma mark -- 使用定时器让scrollView滚动
/** 使用定时器让scrollView滚动 */
- (void)useScrollViewContentOffsetScroll{

    NSLog(@"sdfad");
}

#pragma mark -- 获取用户指定的信息
/** 设置page的frame */
- (CGRect)mmPageFrame{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewPageFrame)]) {
        return [self.customDelegate setMMBackScrollViewPageFrame];
    }
    return CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 15);
}
/** 设置选中的页码颜色 */
- (UIColor *)mmCurrentPageIndicatorTintColor{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewCurrentPageIndicatorTintColor)]) {
        return [self.customDelegate setMMBackScrollViewCurrentPageIndicatorTintColor];
    }
    return [UIColor blackColor];
}
/** 设置未选中的页码颜色 */
- (UIColor *)mmPageIndicatorTintColor{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewPageIndicatorTintColor)]) {
        return [self.customDelegate setMMBackScrollViewPageIndicatorTintColor];
    }
    return [UIColor whiteColor];
}
/** 设置默认页数 */
- (NSInteger)mmSetCurrentPageNumber{
    if ([self.customDelegate respondsToSelector:@selector(setMMBackScrollViewCurrentPageNumber)]) {
        return [self.customDelegate setMMBackScrollViewCurrentPageNumber];
    }
    return 0;
}
#pragma mark -- scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_FOREVER, [self.customDelegate scrollToNextImageTimeInterval] * NSEC_PER_SEC, 0);
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, [self.customDelegate scrollToNextImageTimeInterval] * NSEC_PER_SEC, 0);

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

@end
