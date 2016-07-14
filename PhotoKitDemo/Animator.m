//
//  Animator.m
//  PhotoKitDemo
//
//  Created by 解梁 on 16/7/14.
//  Copyright © 2016年 5i5j. All rights reserved.
//

#import "Animator.h"

@implementation Animator 

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        fromView = fromController.view;
        toView = toController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromController];
    toView.frame = [transitionContext finalFrameForViewController:toController];
    toView.alpha = 0.0f;
    [containerView addSubview:toView];
    
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:_rect];
    maskView.image = self.image;
    maskView.contentMode = UIViewContentModeScaleAspectFit;
    [containerView addSubview:maskView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        maskView.frame = CGRectMake(0, 0, kWidth, kHeight);
    } completion:^(BOOL finished) {
        toView.alpha = 1.0f;
        [maskView removeFromSuperview];
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}

@end
