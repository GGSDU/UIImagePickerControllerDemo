//
//  UIView+Drawer.h
//  IkasaInteriorIphone
//
//  Created by Story5 on 15/11/13.
//  Copyright © 2015年 Webcity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewDrawerDelegate.h"

typedef NS_OPTIONS(NSUInteger, UIViewDrawerDirection) {
    UIViewDrawerDirectionRight = 1 << 0,
    UIViewDrawerDirectionLeft  = 1 << 1,
//    UIViewDrawerDirectionDirectionUp    = 1 << 2,
//    UIViewDrawerDirectionDirectionDown  = 1 << 3
};

@interface UIView (Drawer)

#pragma mark - delegate
- (void)showFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate;

- (void)hideFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate;

- (void)setOffset:(CGPoint)aOffSet withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate;

- (void)setFrame:(CGRect)frame withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView withDelegate:(id<UIViewDrawerDelegate>)drawerDelegate;


#pragma mark - block
- (void)showFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView completion:(void(^)(void))completion;

- (void)hideFromDirection:(UIViewDrawerDirection)aDrawerDirection withAnimationDuration:(NSTimeInterval)aDuration follwedAnimationView:(UIView *)aAnimationView completion:(void (^)(void))completion;

- (void)setOffset:(CGPoint)aOffSet withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView completion:(void (^)(void))completion;

- (void)setFrame:(CGRect)frame withAnimationDuration:(NSTimeInterval)aDuration followedAnimationView:(UIView *)aAnimationView completion:(void (^)(void))completion;

@end