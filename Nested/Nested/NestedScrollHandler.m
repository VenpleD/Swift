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

@property (nonatomic, assign) CGFloat beginContainerOffsetY;

@property (nonatomic, assign) CGFloat beginSubOffsetY;

@property (nonatomic, assign) BOOL beginDragContainer;

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
        self.beginSubOffsetY = scrollView.contentOffset.y;
        self.beginDragContainer = NO;
    } else {
        self.beginContainerOffsetY = scrollView.contentOffset.y;
        self.beginDragContainer = YES;
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
    if (self.beginDragContainer) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat limitY = [self.containerScrollViewDelegate.scrollView hoverPositionY];
    if ([scrollView isEqual:self.containerScrollViewDelegate.scrollView]) {
        CGFloat subOffsetY = self.currentSubScrollView.contentOffset.y;
        CGFloat subMaxOffsetY = self.currentSubScrollView.contentSize.height;
        if ((self.beginContainerOffsetY > 0 && offsetY < 0) || (self.beginContainerOffsetY < 0 && offsetY > 0)) {
            /// ???????????????offset?????????????????????????????????????????????0???????????????????????????0??????????????????offset??????????????????0
            self.beginContainerOffsetY = 0;
        }
        NSLog(@"offsetY:%@, subOffsetY:%@,begin:%@, maxOff:%@", @(offsetY), @(subOffsetY), @(self.beginContainerOffsetY), @(subMaxOffsetY));
        if (offsetY < 0) {
            /// ?????????
            if (!self.currentSubScrollView.containerPullDown) {
                /// ??????????????????
                scrollView.contentOffset = CGPointMake(0, 0);
            }
            if (subOffsetY > 0) {
                scrollView.contentOffset = CGPointMake(0, 0);
            }

        } else if (offsetY > 0) {
            /// ????????????
            if (offsetY >= limitY) {
                /// ??????????????????
                scrollView.contentOffset = CGPointMake(0, limitY);
                self.beginContainerOffsetY = limitY;/// ????????????????????????????????????????????????
            } else {
                if (subOffsetY > 0) {
                    /// ???scrollview???????????????????????????????????????????????????
                    scrollView.contentOffset = CGPointMake(0, self.beginContainerOffsetY);
                } else if (subOffsetY < 0) {
                    scrollView.contentOffset = CGPointMake(0, 0);
                }
            }

        } else {
            /// ??????
            self.beginContainerOffsetY = 0; ///  ????????????????????????????????????????????????
        }

    } else {
        CGFloat containerOffsetY = self.containerScrollViewDelegate.scrollView.contentOffset.y;
        NSLog(@"sub--offsetY:%@, containerOffsetY:%@, %@", @(offsetY), @(containerOffsetY), @(self.beginSubOffsetY));
        if ((self.beginSubOffsetY > 0 && offsetY < 0) || (self.beginSubOffsetY < 0 && offsetY > 0)) {
            /// ???????????????offset?????????????????????????????????????????????0???????????????????????????0??????????????????offset??????????????????0
            self.beginSubOffsetY = 0;
        }
        if (offsetY < 0) {
            /// ?????????
            if (scrollView.containerPullDown) {
                scrollView.contentOffset = CGPointMake(0, 0);
            } else {
                if (containerOffsetY > 0) {
                    scrollView.contentOffset = CGPointMake(0, 0);
                } else if (containerOffsetY < 0) {
                    /// ?????????????????????scrollview?????????????????????????????????0?????????
                    if (self.beginContainerOffsetY == 0) {
                        self.containerScrollViewDelegate.scrollView.contentOffset = CGPointMake(0, 0);
                    }
                }
            }

        } else if (offsetY > 0) {
            /// ?????????
            if (containerOffsetY < limitY && containerOffsetY >= 0 && self.beginSubOffsetY == 0.f) {
                scrollView.contentOffset = CGPointMake(0, 0);
            }
            /// ?????????????????????????????????????????????limit??????
            if (containerOffsetY > 0 && self.beginContainerOffsetY == limitY) {
                self.containerScrollViewDelegate.scrollView.contentOffset = CGPointMake(0, limitY);
            }
            if (scrollView.containerPullDown) {
                if (containerOffsetY < 0) {
                    scrollView.contentOffset = CGPointMake(0, 0);
                }
            }
        } else {
            /// ??????
            self.beginSubOffsetY = 0.f;
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
