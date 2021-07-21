//
//  UIScrollView+ScrollRecognize.h
//  Nested
//
//  Created by duanwenpu on 2021/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ScrollRecognize)

#pragma mark --- 下面是子scrollview的方法设置
- (void)setContainerPullDown:(BOOL)pullDown;

- (BOOL)containerPullDown;
#pragma mark -- 上面是子scrollview的方法设置

#pragma mark -- 下面是父scrollview的方法设置

/// 悬停位置设置，目前只支持竖直方向Y
/// @param hoverPositionY 悬停位置
- (void)setHoverPositionY:(CGFloat)hoverPositionY;

/// 悬停位置获取
- (CGFloat)hoverPositionY;

/// 是否要嵌套子视图
/// @param nested YES嵌套会有相关的代理桥接，NO不会做任何操作
- (void)setNested:(BOOL)nested;

/// 需要将嵌套的子视图，单独调用此方法
/// @param subScrollView 有
- (void)addSubScrollView:(UIScrollView *)subScrollView;
#pragma mark -- 上面是父scrollview的方法设置

@end

NS_ASSUME_NONNULL_END
