//
//  NestedScrollHandler.m
//  Nested
//
//  Created by duanwenpu on 2021/7/15.
//

#import "NestedScrollHandler.h"
#import <objc/runtime.h>
#import "NestedScrollViewDelegate.h"
#import "UIScrollView+ScrollRecognize.h"

@interface NestedScrollHandler ()

@property (nonatomic, strong) UIScrollView *currentSubScrollView;

@property (nonatomic, assign) BOOL containerCannotScroll;

@property (nonatomic, assign) BOOL subCanScroll;

@end

@implementation NestedScrollHandler

- (void)dealloc {
    
}

+ (NSArray *)protocolNameArray {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Protocol *protocol = objc_getProtocol("UITableViewDelegate");
        unsigned int methodCount = 0;
        struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
        NSMutableArray *methodArray = [NSMutableArray array];
        for (NSInteger i = 0; i < methodCount; i++) {
            struct objc_method_description method = methodList[i];
            [methodArray addObject:NSStringFromSelector(method.name)];
        }
        protocol = objc_getProtocol("UIScrollViewDelegate");
        methodList = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
        for (NSInteger i = 0; i < methodCount; i++) {
            struct objc_method_description method = methodList[i];
            if ([NSStringFromSelector(method.name) isEqualToString:@"scrollViewDidScroll:"]) {
                continue;
            }
            [methodArray addObject:NSStringFromSelector(method.name)];
        }
        instance = [methodArray copy];
    });
    return instance;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.containerScrollViewDelegate.scrollView]) {
        self.currentSubScrollView = scrollView;
    }
    if ([self.containerScrollViewDelegate.scrollView isEqual:scrollView] && [self.containerScrollViewDelegate.originalScrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.containerScrollViewDelegate.originalScrollDelegate scrollViewWillBeginDragging:scrollView];
    }
    NSLog(@"scrollBeginDrag:%@", @(scrollView.tag));
    for (NestedScrollViewDelegate *subDelegate in self.subScrollViewDelegate) {
        if ([subDelegate.scrollView isEqual:scrollView] && [subDelegate.originalScrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
            [subDelegate.originalScrollDelegate scrollViewWillBeginDragging:scrollView];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;
    if ([scrollView isEqual:self.containerScrollViewDelegate.scrollView]) {
        CGFloat criticalPointOffsetY = scrollView.contentSize.height - [[UIScreen mainScreen] bounds].size.height;
        if (offsetY - criticalPointOffsetY >= FLT_EPSILON) {
            /*
             * 到达临界点：
             * 1.未吸顶状态 -> 吸顶状态
             * 2.维持吸顶状态 (subscrollView.contentOffsetY > 0)
             */
            self.containerCannotScroll = YES;
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
            self.subCanScroll = YES;
        } else {
            /*
             * 未达到临界点：
             * 1.维持吸顶状态 (subscrollView.contentOffsetY > 0)
             * 2.吸顶状态 -> 不吸顶状态
             */
            if (self.containerCannotScroll) {
                // “维持吸顶状态”
                scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
            } else {
                // 吸顶状态 -> 不吸顶状态
                [self.currentSubScrollView setContentOffset:CGPointZero];
                for (NestedScrollViewDelegate *subDelegate in self.subScrollViewDelegate) {
                    [subDelegate.scrollView setContentOffset:CGPointZero];
                }
            }
        }
    } else {
        if (self.subCanScroll) {
            if (offsetY <= 0) {
                self.subCanScroll = NO;
                scrollView.contentOffset = CGPointZero;
                self.containerCannotScroll = NO;
            }
        } else {
            self.subCanScroll = NO;
            scrollView.contentOffset = CGPointZero;
        }
    }
    if ([self.containerScrollViewDelegate.scrollView isEqual:scrollView] && [self.containerScrollViewDelegate.originalScrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.containerScrollViewDelegate.originalScrollDelegate scrollViewDidScroll:scrollView];
    }
    for (NestedScrollViewDelegate *subDelegate in self.subScrollViewDelegate) {
        if ([subDelegate.scrollView isEqual:scrollView] && [subDelegate.originalScrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
            [subDelegate.originalScrollDelegate scrollViewDidScroll:scrollView];
        }
    }
    
}

//
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([[NestedScrollHandler protocolNameArray] containsObject:NSStringFromSelector(aSelector)]) {
        if ([self.containerScrollViewDelegate.originalScrollDelegate respondsToSelector:aSelector]) {
            return YES;
        }
        for (NestedScrollViewDelegate *subDelegate in self.subScrollViewDelegate) {
            if ([subDelegate.originalScrollDelegate respondsToSelector:aSelector]) {
                return YES;
            }
        }
        
    }
    return [super respondsToSelector:aSelector];
}
//
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([[NestedScrollHandler protocolNameArray] containsObject:NSStringFromSelector(aSelector)]) {
        if ([self.containerScrollViewDelegate.originalScrollDelegate respondsToSelector:aSelector]) {
            return self.containerScrollViewDelegate.originalScrollDelegate;
        }
        for (NestedScrollViewDelegate *subDelegate in self.subScrollViewDelegate) {
            if ([subDelegate.originalScrollDelegate respondsToSelector:aSelector]) {
                return subDelegate.originalScrollDelegate;
            }
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}


- (NSMutableArray <NestedScrollViewDelegate *>*)subScrollViewDelegate {
    if (!_subScrollViewDelegate) {
        _subScrollViewDelegate = [NSMutableArray array];
    }
    return _subScrollViewDelegate;
}

@end
