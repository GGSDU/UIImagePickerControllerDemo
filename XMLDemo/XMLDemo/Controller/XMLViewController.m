//
//  XMLViewController.m
//  XMLDemo
//
//  Created by Story5 on 7/19/16.
//  Copyright © 2016 Story5. All rights reserved.
//

#import "XMLViewController.h"

#import "ProductModel.h"

#import "NSObject+Property.h"

#import "SXXMLParser.h"
#import "TBXML.h"
#import "GDataXMLNode.h"

@interface XMLViewController ()<SXXMLParserDelegate>

@property (nonatomic, strong) NSString *xmlPath;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) NSMutableString *modelDescription;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation XMLViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _xmlPath = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"xml"];
        _modelDescription = [NSMutableString string];
        
        //  注册KVO
        [self addObserver:self forKeyPath:@"xmlLibrary" options:NSKeyValueObservingOptionNew context:nil];
        
        NSLog(@"intt");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    float originY = 60;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - originY)];
    _textView.text = _modelDescription;
    [self.view addSubview:_textView];
    
    NSLog(@"view did load");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeObserver:self forKeyPath:@"xmlLibrary" context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"old : %@ - new : %@",change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey]);
    
    switch (self.xmlOperateType) {
        case XMLParserOperation:
        {
            if ([self.xmlLibrary isEqualToString:@"NSXMLParser"]) {
                
                //  使用SXXMLParser解析,基于NSXMLParser封装
                [self parserXMLByNSXMLParserWithXMLPath:self.xmlPath];
                
            } else if ([self.xmlLibrary isEqualToString:@"TBXML"]) {
                
                //  使用TBXML解析
                [self parserXMLByTBXMLWithPath:self.xmlPath];
                
            } else if ([self.xmlLibrary isEqualToString:@"GDataXML"]) {
                
                //  使用GDataXML解析
                [self parserXMLByGDataXMLNodeWithPath:self.xmlPath];
            }
        }
            break;
        case XMLGenerateOperation:
        {
            if ([self.xmlLibrary isEqualToString:@"GDataXML"]) {
                //  使用GDataXML生成XML
                [self generateXMLByGDataXML];
            }
        }
            break;
        default:
            break;
    }
    
    NSLog(@"xmlOperate : %@ - xmlLibrary : %@",self.xmlOperateType == XMLParserOperation ? @"parser" : @"generate",self.xmlLibrary);
}

#pragma mark - xml parser
/**
 *  SXXMLParser
 *  基于NSXMLParser封装
 */
- (void)parserXMLByNSXMLParserWithXMLPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    SXXMLParser *parser = [[SXXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    [parser parse];
}

/**
 *  TBXML
 *  基于DOM的解析模式,但不支持XPath
 */
- (void)parserXMLByTBXMLWithPath:(NSString *)path
{
    path = [path componentsSeparatedByString:@"/"].lastObject;
    
    //  1.通过xml文件创建一个TBXML对象
    TBXML *tbxml = [[TBXML alloc] initWithXMLFile:path error:nil];
    //  2.查找文档的根元素dataElement
    TBXMLElement *dataElement = tbxml.rootXMLElement;
    if (dataElement) {
        
        self.productArray = [NSMutableArray arrayWithCapacity:2];
        
        //  3.通过dataElement获取其子元素productElment
        TBXMLElement *productElement = [TBXML childElementNamed:@"product" parentElement:dataElement];
        while (productElement != nil) {
            
            ProductModel *productModel = [[ProductModel alloc] init];
            //  4.获取productElement的属性值
            productModel.productId     = [TBXML valueOfAttributeNamed:@"id" forElement:productElement];
            productModel.productName   = [TBXML valueOfAttributeNamed:@"productName" forElement:productElement];
            productModel.typeName      = [TBXML valueOfAttributeNamed:@"typeName" forElement:productElement];
            productModel.brand         = [TBXML valueOfAttributeNamed:@"brand" forElement:productElement];
            productModel.price         = [[TBXML valueOfAttributeNamed:@"price" forElement:productElement] doubleValue];
            [self.productArray addObject:productModel];
            
            TBXMLElement *infoElement = [TBXML childElementNamed:@"info" parentElement:productElement];
            while (infoElement != nil) {
                
                ProductInfoModel *productInfoModel = [[ProductInfoModel alloc] init];
                productInfoModel.infoId            = [TBXML valueOfAttributeNamed:@"id" forElement:infoElement];
                productInfoModel.infoLabel         = [TBXML valueOfAttributeNamed:@"label" forElement:infoElement];
                [productModel.productInfoArray addObject:productInfoModel];
                
                TBXMLElement *itemsElement = [TBXML childElementNamed:@"items" parentElement:infoElement];
                while (itemsElement != nil) {
                    
                    ProductItemModel *productItemModel = [[ProductItemModel alloc] init];
                    productItemModel.itemName          = [TBXML valueOfAttributeNamed:@"name" forElement:itemsElement];
                    //  5.获取itemsElement的文本内容
                    productItemModel.imagePath         = [TBXML textForElement:itemsElement];
                    [productInfoModel.productItemArray addObject:productItemModel];
                    
                    itemsElement = [TBXML nextSiblingNamed:@"items" searchFromElement:itemsElement];
                }
                
                infoElement = [TBXML nextSiblingNamed:@"info" searchFromElement:infoElement];
            }
            
            [_modelDescription appendFormat:@"\n%@",productModel.objectDictionary];
            
            //  6.获取productElement的兄弟元素,及下一个productElement元素
            productElement = [TBXML nextSiblingNamed:@"product" searchFromElement:productElement];
        }
    }
    
    _textView.text = _modelDescription;

    NSLog(@"parser xml complete");
}

- (void)parserXMLByGDataXMLNodeWithPath:(NSString *)path
{
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //  1.通过一个xmlString创建一个GDataXMLDocument对象
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    //  2.获取根元素dataElement
    GDataXMLElement *dataElement = doc.rootElement;
    
    NSDictionary *namespacesDic =[NSDictionary dictionaryWithObjectsAndKeys:@"product.xml",@"xmlns", nil];
    if (dataElement != nil) {
        self.productArray = [NSMutableArray arrayWithCapacity:2];
        
        //  3.获取子dataElement子元素productElement
        for (GDataXMLElement *productElement in dataElement.children) {
            
            ProductModel *productModel = [[ProductModel alloc] init];
            productModel.productId     = [productElement attributeForName:@"id"].stringValue;
            productModel.productName   = [productElement attributeForName:@"productName"].stringValue;
            productModel.typeName      = [productElement attributeForName:@"typeName"].stringValue;
            productModel.brand         = [productElement attributeForName:@"brand"].stringValue;
            productModel.price         = [productElement attributeForName:@"price"].stringValue.doubleValue;
            [self.productArray addObject:productModel];
            
            //  4.使用XPath方式获取元素
            NSArray *infoElementArray = [productElement nodesForXPath:@"xmlns:info" namespaces:namespacesDic error:nil];
            for (GDataXMLElement *infoElement in infoElementArray) {
                
                ProductInfoModel *productInfoModel = [[ProductInfoModel alloc] init];
                productInfoModel.infoId            = [infoElement attributeForName:@"id"].stringValue;
                productInfoModel.infoLabel         = [infoElement attributeForName:@"label"].stringValue;
                [productModel.productInfoArray addObject:productInfoModel];
                
                for (GDataXMLElement *itemsElement in infoElement.children) {
                    
                    ProductItemModel *productItemModel = [[ProductItemModel alloc] init];
                    //  5.获取itemsElement属性
                    productItemModel.itemName          = [itemsElement attributeForName:@"name"].stringValue;
                    //  6.获取itemsElement值
                    productItemModel.imagePath         = itemsElement.stringValue;
                    [productInfoModel.productItemArray addObject:productItemModel];
                }
            }
            [_modelDescription appendFormat:@"\n%@",productModel.objectDictionary];
        }
    }
    
    _textView.text = _modelDescription;
}

#pragma mark - SXXMLParserDelegate
- (void)sxXMLParserDidStartDocument:(SXXMLParser *)parser
{
    self.productArray = [NSMutableArray arrayWithCapacity:2];
}

- (void)sxXMLParser:(SXXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"product"]) {
        
        ProductModel *productModel = [[ProductModel alloc] init];
        productModel.productId     = [attributeDict objectForKey:@"id"];
        productModel.productName   = [attributeDict objectForKey:@"productName"];
        productModel.typeName      = [attributeDict objectForKey:@"typeName"];
        productModel.brand         = [attributeDict objectForKey:@"brand"];
        productModel.price         = [[attributeDict objectForKey:@"price"] doubleValue];
        
        [self.productArray addObject:productModel];
        
    } else if ([elementName isEqualToString:@"info"]) {
        
        ProductModel *productModel = self.productArray.lastObject;
        
        ProductInfoModel *productInfoModel = [[ProductInfoModel alloc] init];
        productInfoModel.infoId = [attributeDict objectForKey:@"id"];
        productInfoModel.infoLabel = [attributeDict objectForKey:@"label"];
        
        [productModel.productInfoArray addObject:productInfoModel];
        
        
    } else if ([elementName isEqualToString:@"items"]) {
        
        ProductModel *productModel = self.productArray.lastObject;
        ProductInfoModel *productInfoModel = productModel.productInfoArray.lastObject;
        
        ProductItemModel *productItemModel = [[ProductItemModel alloc] init];
        productItemModel.itemName          = [attributeDict objectForKey:@"name"];
        
        [productInfoModel.productItemArray addObject:productItemModel];
    }
}

- (void)sxXmlParser:(SXXMLParser *)parser foundCharacters:(NSString *)string element:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qulifiedName:(NSString *)qName
{
//    NSLog(@"\nelement      : %@ \nnamespaceURI : %@\nqName        : %@\nstring       : %@",elementName,namespaceURI,qName,string);
    
    ProductModel *productModel = self.productArray.lastObject;
    ProductInfoModel *productInfoModel = productModel.productInfoArray.lastObject;
    ProductItemModel *productItemModel = productInfoModel.productItemArray.lastObject;
    productItemModel.imagePath = string;
}

//- (void)sxXMLParser:(SXXMLParser *)parser foundCharacters:(NSString *)string
//{
//    NSLog(@"element : %@ - string : %@",parser.currentElementName,string);
//}

- (void)sxXMLParser:(SXXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

- (void)sxXMLParserDidEndDocument:(SXXMLParser *)parser
{
    NSLog(@"parser did end document!");
    for (ProductModel *productModel in self.productArray) {
    
        [_modelDescription appendFormat:@"\n%@",productModel.objectDictionary];
    }
    NSLog(@"%@",_modelDescription);

    _textView.text = _modelDescription;
}

- (void)sxXMLParser:(SXXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError.description);
}


#pragma mark - xml generate
/**
 *  适应GDataXML生成XML文件
 *  注意,当XML包含很多层级时,必须由内向外先填元素,先创建最低级子元素,然后添加其父元素.
 */
- (void)generateXMLByGDataXML
{
    /** 我们简单生成一个项目中和pGenerate.xml一样的xml,格式如下
     
     <?xml version="1.0" encoding="utf-8" ?>
     <data xmlns="product.xml">
        <product id="DB3" productName="圣象强化复合木地板" typeName="强化复合地板" brand="圣象" price="5">
            <info id="1" label="产品详情">
                <item name="特性1">product/imgs/DB3/trait/1.jpg</item>
            </info>
        </product>
     </data>
     
     */
    
    
    //  1.创建根元素
    GDataXMLElement *dataElement = [GDataXMLElement elementWithName:@"data"];
    GDataXMLNode *xmlnsNode = [GDataXMLNode attributeWithName:@"xmlns" stringValue:@"product.xml"];
    [dataElement addAttribute:xmlnsNode];
    
    //  2.创建product元素
    GDataXMLElement *productElement = [GDataXMLElement elementWithName:@"product"];
    //  3.设置product元素属性
    GDataXMLNode *idNode = [GDataXMLNode attributeWithName:@"id" stringValue:@"DB3"];
    [productElement addAttribute:idNode];
    GDataXMLNode *productNameNode = [GDataXMLNode attributeWithName:@"productName" stringValue:@"圣象强化复合木地板"];
    [productElement addAttribute:productNameNode];
    GDataXMLNode *typeNameNode = [GDataXMLNode attributeWithName:@"typeName" stringValue:@"强化复合地板"];
    [productElement addAttribute:typeNameNode];
    GDataXMLNode *brandNode = [GDataXMLNode attributeWithName:@"brand" stringValue:@"圣象"];
    [productElement addAttribute:brandNode];
    GDataXMLNode *priceNode = [GDataXMLNode attributeWithName:@"price" stringValue:@"5"];
    [productElement addAttribute:priceNode];

    //  4.创建info元素
    GDataXMLElement *infoElement = [GDataXMLElement elementWithName:@"info"];
    GDataXMLNode *infoIdNode = [GDataXMLNode attributeWithName:@"id" stringValue:@"1"];
    [infoElement addAttribute:infoIdNode];
    GDataXMLNode *labelNode = [GDataXMLNode attributeWithName:@"label" stringValue:@"产品详情"];
    [infoElement addAttribute:labelNode];
    
    //  5.创建item元素,并设置值
    GDataXMLElement *itemElement = [GDataXMLElement elementWithName:@"item" stringValue:@"product/imgs/DB3/trait/1.jpg"];
    GDataXMLNode *nameNode = [GDataXMLNode attributeWithName:@"name" stringValue:@"特性1"];
    [itemElement addAttribute:nameNode];
    
    
    //  6.将item添加为info的子元素
    [infoElement addChild:itemElement];
    //  7.将info添加为product的子元素
    [productElement addChild:infoElement];
    //  4.将product元素设置为data的子元素
    [dataElement addChild:productElement];
    
    //  6.添加XML声明,并设置根元素
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:dataElement];
    [_modelDescription appendString:[[NSString alloc] initWithData:doc.XMLData encoding:NSUTF8StringEncoding]];
    
    
    _textView.text = _modelDescription;
    NSLog(@"%@",_modelDescription);
}

@end
