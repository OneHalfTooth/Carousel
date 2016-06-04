//
//  ViewController.m
//  LoopRunImage
//
//  Created by 马少洋 on 16/6/2.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import "ViewController.h"
#import "MMBackScrollView.h"
#import "PushViewContr0llerViewController.h"

@interface ViewController ()<MMBackScrollViewDelegate>

@end

@implementation ViewController
//-(void)viewWillAppear:(BOOL)animated
//-(void)viewDidDisappear:(BOOL)animated
- (void)viewDidLoad {
    [super viewDidLoad];
    MMBackScrollView * scrollView = [[MMBackScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) AndSuperView:self.view Delegate:self];
    NSArray * arr = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]];
    [scrollView upDataScrollViewImageArray:arr PlaceholderImage:[UIImage imageNamed:@"msy"]];
    
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PushViewContr0llerViewController * push = [[PushViewContr0llerViewController alloc]init];
    [self.navigationController pushViewController:push animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
