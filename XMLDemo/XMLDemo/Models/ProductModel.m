//
//  ProductModel.m
//  XMLDemo
//
//  Created by Story5 on 7/19/16.
//  Copyright © 2016 Story5. All rights reserved.
//

#import "ProductModel.h"

#pragma mark - ProductItemModel
@implementation ProductItemModel

@end


#pragma mark - ProductInfoModel
@implementation ProductInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.productItemArray = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

@end

#pragma mark - ProductModel
@implementation ProductModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.productInfoArray = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

@end
