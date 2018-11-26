//
//  Property+NSObject.h
//  IkasaInteriorIphone
//
//  Created by Story5 on 15/8/25.
//  Copyright (c) 2015年 Webcity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
- (NSDictionary *)objectDictionary;

- (NSArray *)allKeys;

//将getObjectData方法返回的NSDictionary转化成JSON
- (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//直接通过NSLog输出getObjectData方法返回的NSDictionary
- (void)print:(id)obj;

@end
