//
//  ViewController.m
//  XMLDemo
//
//  Created by Story5 on 7/19/16.
//  Copyright © 2016 Story5. All rights reserved.
//

#import "ViewController.h"

#import "XMLViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = YES;
    //  设置导航标题
    self.title = @"XML Library";
    
    //  初始化数据
    _dataDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"XML解析":@[@"NSXMLParser", @"TBXML", @"GDataXML"],
                                                                 @"XML生成":@[@"GDataXML"]}];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _dataDic.allKeys[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *key = _dataDic.allKeys[indexPath.section];
    NSArray *values = [_dataDic objectForKey:key];
    cell.textLabel.text = values[indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _dataDic.allKeys[section];
    NSArray *values = [_dataDic objectForKey:key];
    return values.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _dataDic.allKeys[indexPath.section];
    NSArray *values = [_dataDic objectForKey:key];
    NSString *value = values[indexPath.row];
    
    XMLViewController *xmlVC = [[XMLViewController alloc] init];
    xmlVC.xmlOperateType = [key isEqualToString:@"XML解析"] ? XMLParserOperation : XMLGenerateOperation;
    xmlVC.xmlLibrary = value;
    [self.navigationController pushViewController:xmlVC animated:YES];
}


@end
