//
//  DropDownTransitionAnimator.m
//  Craftycle
//
//  Created by Thinh Vo on 27/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

#import "DropDownTransitionAnimator.h"

@interface DropDownTransitionAnimator()
@end

@implementation DropDownTransitionAnimator

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromVC.view;
        toView = toVC.view;
    }
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    
    CGVector offset = CGVectorMake(0.f, -1.f);
    
    isPresenting = toVC.presentingViewController == fromVC;
    
    if (isPresenting) {
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width * offset.dx, toFrame.size.height * offset.dy);
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
    }
    
    if (isPresenting) {
        [containerView addSubview:toView];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (isPresenting) {
                             toView.frame = toFrame;
                         } else {
                             fromView.frame = CGRectOffset(fromFrame, containerView.frame.size.width * offset.dx, containerView.frame.size.height * offset.dy);
                         }
                         
                     } completion:^(BOOL finished) {
                         BOOL wasCancelled = [transitionContext transitionWasCancelled];
                         if (wasCancelled) {
                             if (isPresenting) {
                                 [toView removeFromSuperview];
                             } else {
                                 //[fromView removeFromSuperview];
                             }
                         }
                         [transitionContext completeTransition:!wasCancelled];
                     }];
}

@end
