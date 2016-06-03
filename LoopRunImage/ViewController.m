//
//  ViewController.m
//  LoopRunImage
//
//  Created by 马少洋 on 16/6/2.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import "ViewController.h"
#import "MMBackScrollView.h"

@interface ViewController ()<MMBackScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MMBackScrollView * scrollView = [[MMBackScrollView alloc]initWithFrame:self.view.bounds AndSuperView:self.view Delegate:self];
    NSArray * arr = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"]];
    [scrollView upDataScrollViewImageArray:arr PlaceholderImage:[UIImage imageNamed:@"msy"]];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)scrollViewImageViewDidCliked:(NSInteger)imageIndex{
    NSLog(@"%ld被点击了",imageIndex);
}
-(CGFloat)scrollToNextImageTimeInterval{
    return 1.f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
