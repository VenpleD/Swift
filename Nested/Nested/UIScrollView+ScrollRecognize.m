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


static NSString *normalDelegate = nil;

static NSString *_nestedKey = nil;

@implementation UIScrollView (ScrollRecognize)

- (void)settingOffsetY:(CGFloat)offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
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
    return [objc_getAssociatedObject(self, &_nestedKey) boolValue];; 
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [self nested];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchbegin:%@", @(self.tag));
}

@end
