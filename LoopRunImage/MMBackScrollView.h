//
//  MMBackScrollView.h
//  LoopRunImage
//
//  Created by 马少洋 on 16/6/2.
//  Copyright © 2016年 马少洋. All rights reserved.
//

#import <UIKit/UIKit.h>


/** image的tag */
#define TAG 19931219

@class MMBackScrollView;
@protocol MMBackScrollViewDelegate <NSObject>


@optional
/** 设置滚动时间间隔 */
- (CGFloat)scrollToNextImageTimeInterval:(MMBackScrollView *)backScrollView;

/** 设置图片呗点击的代理 */
- (void)setMMBackScrollView:(MMBackScrollView *)backScrollView ImageViewDidCliked:(NSInteger)imageIndex;
/** 设置页码的frame */
- (CGRect)setMMBackScrollViewPageFrame:(MMBackScrollView *)backScrollView;
/** 设置页码Label的frame */
- (CGRect)setMMBackScrollViewPageLabelFrame:(MMBackScrollView *)backScrollView;
/** 设置选中的页码颜色 */
- (UIColor *)setMMBackScrollViewCurrentPageIndicatorTintColor:(MMBackScrollView *)backScrollView;
/** 设置未选中的页码颜色 */
- (UIColor *)setMMBackScrollViewPageIndicatorTintColor:(MMBackScrollView *)backScrollView;
/** 设置默认页数 */
- (NSInteger)setMMBackScrollViewCurrentPageNumber:(MMBackScrollView *)backScrollView;
/**用户拖拽之后滚动动画暂停，等待timeInterval 秒后继续开始滚动动画*/
- (CGFloat)setMMBackScrollViewDranggingStartScrollTimeInterval:(MMBackScrollView *)backScrollView;
/** 设置轮播图，动画的时间间隔 */
- (NSTimeInterval)setMMBackScrollViewAnimationTimeIntervalBackScrollView:(MMBackScrollView *)backScrollView;
@end


@interface MMBackScrollView : UIScrollView

/** 
 *frame 轮播图的frame
 * superView 承载轮播图的视图
 *Delegate 承载轮播图的控制器同时遵守协议
 *轮播图会直接被添加到superView 所以不用执行addSubView操作
 */
-(instancetype)initWithFrame:(CGRect)frame AndSuperView:(UIView *)superView Delegate:(id<MMBackScrollViewDelegate> )delegate;
/** 传过来图片数组 
 * imageArray 可以使图片数组，也可以是图片链接数组，还可以是图片链接+图片
 *PlaceholderImage 占位图片
 */
- (void)upDataScrollViewImageArray:(NSArray *)imageArray PlaceholderImage:(UIImage *)placeholderImage;
/** 创建页码label */
- (void)createNumberLabel;
@end
