//
//  PushViewContr0llerViewController.m
//  LoopRunImage
//
//  Created by 马少洋 on 16/6/4.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import "PushViewContr0llerViewController.h"
#import "MMBackScrollView.h"
@interface PushViewContr0llerViewController ()<MMBackScrollViewDelegate>

@end

@implementation PushViewContr0llerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    MMBackScrollView * scrollView = [[MMBackScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) AndSuperView:self.view Delegate:self];
    NSArray * arr = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]];
    [scrollView upDataScrollViewImageArray:arr PlaceholderImage:[UIImage imageNamed:@"msy"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"出现了");
    NSLog(@"%d",animated);
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"消失了");
    NSLog(@"%d",animated);
}

#pragma mark -- MMBackScrollViewDelegate
-(CGFloat)scrollToNextImageTimeInterval:(MMBackScrollView *)backScrollView{
    return 1.f;
}

/** 某张图片被点击的回调 */
-(void)setMMBackScrollView:(MMBackScrollView *)backScrollView ImageViewDidCliked:(NSInteger)imageIndex{
    NSLog(@"%ld被点击了",imageIndex);
}
///** 设置页码的frame */
//- (CGRect)setMMBackScrollViewPageFrame:(MMBackScrollView *)backScrollView{
//
//}
///** 设置选中的页码颜色 */
//- (UIColor *)setMMBackScrollViewCurrentPageIndicatorTintColor:(MMBackScrollView *)backScrollView{
//
//}
///** 设置未选中的页码颜色 */
//- (UIColor *)setMMBackScrollViewPageIndicatorTintColor:(MMBackScrollView *)backScrollView{
//
//}
///** 设置默认页数 */
//- (NSInteger)setMMBackScrollViewCurrentPageNumber:(MMBackScrollView *)backScrollView{
//
//}
///**用户拖拽之后滚动动画暂停，等待timeInterval 秒后继续开始滚动动画*/
//- (CGFloat)setMMBackScrollViewDranggingStartScrollTimeInterval:(MMBackScrollView *)backScrollView{
//
//}
/** 页码按钮是否可以被点击 */
- (BOOL)setPageControlEnableMMBackScrollView:(MMBackScrollView *)backScrollView{
    return YES;
}


-(void)dealloc{
    NSLog(@"销毁了");
}



@end
