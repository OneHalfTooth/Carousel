//
//  ViewController.m
//  LoopRunImage
//
//  Created by 马少洋 on 16/6/2.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import "ViewController.h"

#import "PushViewContr0llerViewController.h"

@interface ViewController ()

@end

@implementation ViewController
//-(void)viewWillAppear:(BOOL)animated
//-(void)viewDidDisappear:(BOOL)animated
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    PushViewContr0llerViewController * push = [[PushViewContr0llerViewController alloc]init];
    [self.navigationController pushViewController:push animated:YES];
}
@end
