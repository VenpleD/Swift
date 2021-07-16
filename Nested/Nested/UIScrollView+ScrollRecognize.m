//
//  UIScrollView+ScrollRecognize.m
//  Nested
//
//  Created by duanwenpu on 2021/7/14.
//

#import "UIScrollView+ScrollRecognize.h"
#import <objc/runtime.h>
#import "NestedScrollViewDelegate.h"
#import "NestedScrollHandler.h"

@interface NSObject (ScrollRecognize)



@end

@implementation NSObject (ScrollRecognize)




@end


static NSString *normalDelegate = nil;

static NSString *_nestedKey = nil;

static NSString *_containerPullDown = nil;

@implementation UIScrollView (ScrollRecognize)

- (void)setContainerPullDown:(BOOL)pullDown {
    objc_setAssociatedObject(self, &_containerPullDown, @(pullDown), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)containerPullDown {
    return [objc_getAssociatedObject(self, &_containerPullDown) boolValue];
}

- (void)setNestedScrollDelegate:(NestedScrollHandler *)nestedScrollDelegate {
    objc_setAssociatedObject(self, &normalDelegate, nestedScrollDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (NestedScrollHandler *)nestedScrollDelegate {
    return objc_getAssociatedObject(self, &normalDelegate);
}


- (void)setNested:(BOOL)nested {
    if (nested == YES) {
        NestedScrollHandler *handler = [NestedScrollHandler new];
        [self setNestedScrollDelegate:handler];
        NestedScrollViewDelegate *nestedDelegate = [NestedScrollViewDelegate new];
        if (self.delegate) {
            nestedDelegate.originalScrollDelegate = self.delegate;
        }
        nestedDelegate.scrollView = self;
        handler.containerScrollViewDelegate = nestedDelegate;
        self.delegate = handler;
    }
    objc_setAssociatedObject(self, &_nestedKey, @(nested), OBJC_ASSOCIATION_RETAIN);
}

- (void)addSubScrollView:(UIScrollView *)subScrollView {
    NestedScrollViewDelegate *subScrollDelegate = [NestedScrollViewDelegate new];
    if (subScrollView.delegate) {
        subScrollDelegate.originalScrollDelegate = subScrollView.delegate;
    }
    subScrollView.delegate = self.delegate;
    subScrollDelegate.scrollView = subScrollView;
    if ([self.delegate isKindOfClass:[NestedScrollHandler class]]) {
        NestedScrollHandler *nestedDelegate = (NestedScrollHandler *)self.delegate;
        [nestedDelegate.subScrollViewDelegate addObject:subScrollDelegate];
    }
}

- (BOOL)nested {
    return objc_getAssociatedObject(self, &_nestedKey);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [self nested];
}

@end
