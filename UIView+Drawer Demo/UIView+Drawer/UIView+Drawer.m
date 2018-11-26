//
//  UIView+Drawer.m
//  IkasaInteriorIphone
//
//  Created by Story5 on 15/11/13.
//  Copyright © 2015年 Webcity. All rights reserved.
//

#import "UIView+Drawer.h"

@implementation UIView (Drawer)

#pragma mark - delegate
- (void)showFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate
{
    float originX = self.frame.origin.x;
    if (aDrawerDirection == UIViewDrawerDirectionLeft && originX < 0) {
        
        [self setOffset:CGPointMake(-originX, 0) withAnimationDuration:1 followedAnimationView:aAnimationView withDelegate:drawerDelegate];
    }
}

- (void)hideFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate
{
    float originX = self.frame.origin.x;
    if (aDrawerDirection == UIViewDrawerDirectionLeft && originX == 0) {
        [self setOffset:CGPointMake(-self.frame.size.width, 0) withAnimationDuration:1 followedAnimationView:aAnimationView withDelegate:drawerDelegate];
    }

}

- (void)setOffset:(CGPoint)aOffSet withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate
{
    [UIView animateWithDuration:aDuration animations:^{
        
        [self setOffset:aOffSet followedView:aAnimationView];
        
    } completion:^(BOOL finished) {
        

        
    }];
}

- (void)setFrame:(CGRect)frame withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate
{
    if (frame.origin.x >= 0) {
        if (drawerDelegate && [drawerDelegate respondsToSelector:@selector(drawerViewWillShow)]) {
            [drawerDelegate performSelector:@selector(drawerViewWillShow)];
        }
    } else if (frame.origin.x < 0) {
        if (drawerDelegate && [drawerDelegate respondsToSelector:@selector(drawerViewWillHide)]) {
            [drawerDelegate performSelector:@selector(drawerViewWillHide)];
        }
    }
    
    NSLog(@"duration %f",aDuration);
    
    [UIView animateWithDuration:aDuration animations:^{
        
        [self setFrame:frame followedView:aAnimationView];
        
    } completion:^(BOOL finished) {
        
        if (frame.origin.x >= 0) {
            if (drawerDelegate && [drawerDelegate respondsToSelector:@selector(drawerViewDidShow)]) {
                [drawerDelegate performSelector:@selector(drawerViewDidShow)];
            }
        } else if (frame.origin.x < 0) {
            if (drawerDelegate && [drawerDelegate respondsToSelector:@selector(drawerViewDidHide)]) {
                [drawerDelegate performSelector:@selector(drawerViewDidHide)];
            }
        }
        
    }];
}

#pragma mark - block
- (void)showFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView completion:(void (^)(void))completion
{
    float originX = self.frame.origin.x;
    
    if (aDrawerDirection == UIViewDrawerDirectionLeft && originX < 0) {
        
        [self setOffset:CGPointMake(-originX, 0) withAnimationDuration:1 followedAnimationView:aAnimationView completion:^{
            
            completion();
            
        }];
    }
}

- (void)hideFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView completion:(void (^)(void))completion
{
    float originX = self.frame.origin.x;
    
    if (aDrawerDirection == UIViewDrawerDirectionLeft && originX == 0) {
        
        [self setOffset:CGPointMake(-self.frame.size.width, 0) withAnimationDuration:1 followedAnimationView:aAnimationView completion:^{
            
            completion();
            
        }];
    }
}


- (void)setOffset:(CGPoint)aOffSet withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView completion:(void (^)(void))completion
{
    [UIView animateWithDuration:aDuration animations:^{
        
        [self setOffset:aOffSet followedView:aAnimationView];
        
    } completion:^(BOOL finished) {
        
        completion();
        
    }];
}

- (void)setFrame:(CGRect)frame withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView completion:(void (^)(void))completion
{
    [UIView animateWithDuration:aDuration animations:^{
        
        [self setFrame:frame followedView:aAnimationView];
        
    } completion:^(BOOL finished) {
        
        completion();
        
    }];
}

#pragma mark - private methods
- (void)setOffset:(CGPoint)aOffSet followedView:(UIView *)aFollowedView
{
    CGRect frame = self.frame;
    frame.origin.x += aOffSet.x;
    frame.origin.y += aOffSet.y;
    self.frame = frame;
    
    if (aFollowedView) {
        CGRect followedViewFrame = aFollowedView.frame;
        followedViewFrame.origin.x += aOffSet.x;
        followedViewFrame.origin.y += aOffSet.y;
        aFollowedView.frame = followedViewFrame;
    }
}

- (void)setFrame:(CGRect)frame followedView:(UIView *)aFollowedView
{
    CGRect originalFrame = self.frame;
    self.frame = frame;
    
    if (aFollowedView) {
        CGPoint offset = CGPointMake(frame.origin.x - originalFrame.origin.x, frame.origin.y - originalFrame.origin.y);
        CGRect followedViewFrame = aFollowedView.frame;
        followedViewFrame.origin.x += offset.x;
        followedViewFrame.origin.y += offset.y;
        aFollowedView.frame = followedViewFrame;
    }
}

@end
