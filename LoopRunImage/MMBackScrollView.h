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

@protocol MMBackScrollViewDelegate <NSObject>

@required
/** 设置图片呗点击的代理 */
- (void)scrollViewImageViewDidCliked:(NSInteger)imageIndex;
/** 设置滚动时间 */
- (CGFloat)scrollToNextImageTimeInterval;
@optional
/** 设置页面的frame */
- (CGRect)setMMBackScrollViewPageFrame;
/** 设置选中的页码颜色 */
- (UIColor *)setMMBackScrollViewCurrentPageIndicatorTintColor;
/** 设置未选中的页码颜色 */
- (UIColor *)setMMBackScrollViewPageIndicatorTintColor;
/** 设置默认页数 */
- (NSInteger)setMMBackScrollViewCurrentPageNumber;

@end


@interface MMBackScrollView : UIScrollView

/** fram superView承载父视图的SuperView */
-(instancetype)initWithFrame:(CGRect)frame AndSuperView:(UIView *)superView Delegate:(id <MMBackScrollViewDelegate>)delegate;
/** 传过来图片数组 
 * imageArray 可以使图片数组，也可以是图片链接数组，还可以是图片链接+图片
 *PlaceholderImage 占位图片
 */
- (void)upDataScrollViewImageArray:(NSArray *)imageArray PlaceholderImage:(UIImage *)placeholderImage;

@end
