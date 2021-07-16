//
//  NestedScrollViewDelegate.h
//  Nested
//
//  Created by duanwenpu on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NestedScrollViewDelegate : NSObject<UIScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, weak) id <UITableViewDelegate>originalScrollDelegate;

@property (nonatomic, weak) UIScrollView *scrollView;

@end


NS_ASSUME_NONNULL_END
