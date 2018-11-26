//
//  SXXMLParser.h
//  XMLParserDemo
//
//  Created by Story5 on 7/15/16.
//  Copyright © 2016 Story5. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - protocol
@class SXXMLParser;
@protocol SXXMLParserDelegate <NSObject>

@optional

- (void)sxXMLParserDidStartDocument:(SXXMLParser *)parser;
- (void)sxXMLParser:(SXXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict;
- (void)sxXmlParser:(SXXMLParser *)parser foundCharacters:(NSString *)string element:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qulifiedName:(NSString *)qName;
//- (void)sxXMLParser:(SXXMLParser *)parser foundCharacters:(NSString *)string;
- (void)sxXMLParser:(SXXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)sxXMLParserDidEndDocument:(SXXMLParser *)parser;

- (void)sxXMLParser:(SXXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

@end


#pragma mark - interface
@interface SXXMLParser : NSObject 

@property (nonatomic, assign) id <SXXMLParserDelegate> delegate;

/**
 *  SXXMLParser init
 */
- (instancetype)initWithContentsOfURL:(NSURL *)url;
- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithStream:(NSInputStream *)stream;

/**
 *  parser state
 */
- (BOOL)parse;

- (void)abortParsing;
@property (nonatomic, readonly, copy) NSError *parserError;

/**
 *  current property
 */
@property (nonatomic, readonly, strong) NSString *currentElementName;
@property (nonatomic, readonly, strong) NSString *currentNamespaceURI;
@property (nonatomic, readonly, strong) NSString *currentQName;
@property (nonatomic, readonly, strong) NSDictionary *currentAttributeDict;

@end

#pragma mark - Category (SXXMLParserLocatorAdditions)
// Once a parse has begun, the delegate may be interested in certain parser state. These methods will only return meaningful information during parsing, or after an error has occurred.
@interface SXXMLParser (SXXMLParserLocatorAdditions)

@property (readonly, copy) NSString *publicID;
@property (readonly, copy) NSString *systemID;
@property (readonly) NSInteger lineNumber;
@property (readonly) NSInteger columnNumber;

@end