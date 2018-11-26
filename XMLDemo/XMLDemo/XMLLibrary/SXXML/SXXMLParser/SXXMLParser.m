//
//  SXXMLParser.m
//  XMLParserDemo
//
//  Created by Story5 on 7/15/16.
//  Copyright © 2016 Story5. All rights reserved.
//

#import "SXXMLParser.h"

@interface SXXMLParser ()<NSXMLParserDelegate>

@property (nonatomic,retain) NSXMLParser *xmlParser;

@end

@implementation SXXMLParser

#pragma mark - init
// initializes the parser with the specified URL.
- (instancetype)initWithContentsOfURL:(NSURL *)url
{
    self = [super init];
    if (self) {
     
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        parser.delegate = self;
        parser.shouldProcessNamespaces = YES;
        _xmlParser = parser;
    }
    
    return self;
}

// create the parser from data
- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        parser.shouldProcessNamespaces = YES;
        _xmlParser = parser;
    }
    
    return self;
    
}

//create a parser that incrementally pulls data from the specified stream and parses it.
- (instancetype)initWithStream:(NSInputStream *)stream
{
    self = [super init];
    if (self) {
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithStream:stream];
        parser.delegate = self;
        parser.shouldProcessNamespaces = YES;
        _xmlParser = parser;
    }
    
    return self;

}

#pragma mark - parse State
// called to start the event-driven parse. Returns YES in the event of a successful parse, and NO in case of error.
- (BOOL)parse
{
    return [_xmlParser parse];
}

// called by the delegate to stop the parse. The delegate will get an error message sent to it.
- (void)abortParsing
{
    [_xmlParser abortParsing];
}

// can be called after a parse is over to determine parser state.
- (NSError *)parserError
{
    return _xmlParser.parserError;
}

#pragma mark - Category (SXXMLParserLocatorAdditions)
- (NSString *)publicID
{
    return _xmlParser.publicID;
}

- (NSString *)systemID
{
    return _xmlParser.systemID;
}

- (NSInteger)lineNumber
{
    return _xmlParser.lineNumber;
}

- (NSInteger)columnNumber
{
    return _xmlParser.columnNumber;
}

#pragma mark - NSXMLParserDelegate
// sent when the parser begins parsing of the document.
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    if (_delegate && [_delegate respondsToSelector:@selector(sxXMLParserDidStartDocument:)]) {
        [_delegate performSelector:@selector(sxXMLParserDidStartDocument:) withObject:self];
    }
}

// sent when the parser finds an element start tag.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    _currentElementName = elementName;
    _currentNamespaceURI = namespaceURI;
    _currentQName = qName;
    _currentAttributeDict = attributeDict;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sxXMLParser:didStartElement:namespaceURI:qualifiedName:attributes:)]) {
        [_delegate sxXMLParser:self didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    }
}

// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //替换回车符和空格
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(sxXmlParser:foundCharacters:element:namespaceURI:qulifiedName:)]) {
        
        [_delegate sxXmlParser:self foundCharacters:string element:_currentElementName namespaceURI:_currentNamespaceURI qulifiedName:_currentQName];
        
    }
//    else if (_delegate && [_delegate respondsToSelector:@selector(sxXMLParser:foundCharacters:)]) {
//        
//        [_delegate performSelector:@selector(sxXMLParser:foundCharacters:) withObject:self withObject:string];
//    }
}

// sent when an end tag is encountered. The various parameters are supplied as above.
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (_delegate && [_delegate respondsToSelector:@selector(parser:didEndElement:namespaceURI:qualifiedName:)]) {
        [_delegate sxXMLParser:self didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    }
    
    _currentElementName = nil;
    _currentNamespaceURI = nil;
    _currentQName = nil;
    _currentAttributeDict = nil;
}

// sent when the parser has completed parsing. If this is encountered, the parse was successful.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (_delegate && [_delegate respondsToSelector:@selector(sxXMLParserDidEndDocument:)]) {
        [_delegate performSelector:@selector(sxXMLParserDidEndDocument:) withObject:self];
    }
}

// ...and this reports a fatal error to the delegate. The parser will stop parsing.
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (_delegate && [_delegate respondsToSelector:@selector(sxXMLParser:parseErrorOccurred:)]) {
        [_delegate performSelector:@selector(sxXMLParser:parseErrorOccurred:) withObject:self withObject:parseError];
    }
}

@end
