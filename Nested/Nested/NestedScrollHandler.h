//
//  NestedScrollHandler.h
//  Nested
//
//  Created by duanwenpu on 2021/7/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class NestedScrollViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface NestedScrollHandler : NSObject<UIScrollViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) NestedScrollViewDelegate *containerScrollViewDelegate;

@property (nonatomic, strong) NSMutableArray <NestedScrollViewDelegate *> *subScrollViewDelegate;

@end

NS_ASSUME_NONNULL_END
