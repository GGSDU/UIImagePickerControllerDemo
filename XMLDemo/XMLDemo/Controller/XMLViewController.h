//
//  XMLViewController.h
//  XMLDemo
//
//  Created by Story5 on 7/19/16.
//  Copyright © 2016 Story5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XMLOperationNone,
    XMLParserOperation,
    XMLGenerateOperation,
} XMLOperationType;

@interface XMLViewController : UIViewController

@property (nonatomic, assign) XMLOperationType xmlOperateType;
@property (nonatomic, strong) NSString *xmlLibrary;

@end
