//
//  UIScrollView+ScrollRecognize.h
//  Nested
//
//  Created by duanwenpu on 2021/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ScrollRecognize)

- (void)setContainerPullDown:(BOOL)pullDown;

- (BOOL)containerPullDown;

- (void)setNested:(BOOL)nested;

- (void)addSubScrollView:(UIScrollView *)subScrollView;

@end

NS_ASSUME_NONNULL_END
