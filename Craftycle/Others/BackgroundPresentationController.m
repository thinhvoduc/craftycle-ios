//
//  BackgroundPresentationController.m
//  Craftycle
//
//  Created by Thinh Vo on 27/04/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

#import "BackgroundPresentationController.h"

static CGFloat widthScale = .8f;
static CGFloat heightScale = .8f;

@interface BackgroundPresentationController()
@property (nonatomic, strong) UIView* dimmingView;
@end

@implementation BackgroundPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        [self setupDimmingView];
    }
    return self;
}

- (void)setupDimmingView
{
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped: )];
    self.dimmingView = [[UIView alloc] init];
    [self.dimmingView addGestureRecognizer:tapRecognizer];
    self.dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

- (void) dimmingViewTapped:(UITapGestureRecognizer *)recognizer
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)containerViewWillLayoutSubviews
{
    UIView *presentedView = [self presentedView];
    
    if (self.containerView && presentedView) {
        self.dimmingView.frame = [self containerView].bounds;
        presentedView.frame = [self calculateFrameForPresentedView];
    }
    
}

- (CGRect)calculateFrameForPresentedView
{
    if (self.containerView) {
        CGFloat width = self.containerView.bounds.size.width * widthScale;
        CGFloat height = self.containerView.bounds.size.height * heightScale;
        CGFloat x = (self.containerView.bounds.size.width - width) / 2;
        CGFloat y = (self.containerView.bounds.size.height -height) / 2;
        
        return CGRectMake(x, y, width, height);
        
    } else {
        return CGRectZero;
    }
}

- (void)presentationTransitionWillBegin
{
    if (self.containerView) {
        self.dimmingView.alpha = 0.0;
        [self.containerView insertSubview:self.dimmingView atIndex:0];
    }
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 1.0;
    } completion: nil];
}

- (void) dismissalTransitionWillBegin
{
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.0;
    } completion:nil];
}

- (void) dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}

@end
