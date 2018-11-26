//
//  ProductModel.h
//  XMLDemo
//
//  Created by Story5 on 7/19/16.
//  Copyright © 2016 Story5. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ProductItemModel
@interface ProductItemModel : NSObject

@property (nonatomic,strong) NSString *itemName;
@property (nonatomic,strong) NSString *imagePath;

@end

#pragma mark - ProductInfoModel
@interface ProductInfoModel : NSObject

@property (nonatomic,strong) NSString *infoId;
@property (nonatomic,strong) NSString *infoLabel;

@property (nonatomic,strong) NSMutableArray *productItemArray;

@end

#pragma mark - ProductModel
@interface ProductModel : NSObject

@property (nonatomic,strong) NSString *productId;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,assign) double price;

@property (nonatomic,strong) NSMutableArray *productInfoArray;

@end
