//
//  UIViewDrawerDelegate.h
//  IkasaInteriorIphone
//
//  Created by Story5 on 15/11/24.
//  Copyright © 2015年 Webcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIViewDrawerDelegate <NSObject>

- (void)drawerViewWillShow;
- (void)drawerViewDidShow;
- (void)drawerViewWillHide;
- (void)drawerViewDidHide;

@end
