//
//  UIScrollView+ScrollRecognize.h
//  Nested
//
//  Created by duanwenpu on 2021/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ScrollRecognize)
/// 是否要嵌套子视图
/// @param nested YES嵌套会有相关的代理桥接，NO不会做任何操作
- (void)setNested:(BOOL)nested;

/// 需要将嵌套的子视图，单独调用此方法
/// @param subScrollView 有
- (void)addSubScrollView:(UIScrollView *)subScrollView;
#pragma mark -- 上面是父scrollview的方法设置

@end

NS_ASSUME_NONNULL_END
