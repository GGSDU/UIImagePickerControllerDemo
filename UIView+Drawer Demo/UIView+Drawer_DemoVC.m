
//
//  UIView+Drawer_DemoVC.m
//  IkasaInterior
//
//  Created by Story5 on 15/7/20.
//  Copyright (c) 2015年 Webcity. All rights reserved.
//

#import "UIView+Drawer_DemoVC.h"
@interface UIView+Drawer_DemoVC () <UIViewDrawerDelegate>
{
   UIView *_houseStyleLeftView;
   CGRect _originalRectForHouseStyleLeftView;
   
   UIView *_planDetailView;
   UIButton *_drawerButton;
}


@end

@implementation UIView+Drawer_DemoVC
- (void)viewDidLoad {
   [super viewDidLoad];
   // Do any additional setup after loading the view. 1051 1351
   self.view.backgroundColor = [UIColor whiteColor];
   
   [self createUI];
}

#pragma makr - ui
/** 创建总UI */
- (void)createUI
{
    float originY = TOP_H + ScalePx(10);
    float height = self.view.bounds.size.height - BOTTOM_H - ScalePx(22) - originY;
    
    
    float widthOfHouseStyleLeftView = ScalePx(342);
    //户型选择界面
    [self createHouseStyleLeftViewWithFrame:CGRectMake(ScalePx(0) - widthOfHouseStyleLeftView, originY, widthOfHouseStyleLeftView, height)];
    
    //方案界面
    [self createPlanDetailViewWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, height) planArray:planArray];
    
    //侧滑按钮和侧滑手势
    [self createDrawerButtonAndPanGestureOnView:self.view];
}

/** 创建我的户型左侧菜单 */
- (void)createHouseStyleLeftViewWithFrame:(CGRect)frame
{
    _houseStyleLeftView = [[UIView alloc] initWithFrame:frame];
    _houseStyleLeftView.alpha = 0;
    [self.view addSubview:_houseStyleLeftView];
    [_houseStyleLeftView release];
    
    _originalRectForHouseStyleLeftView = _houseStyleLeftView.frame;
}

/** 创建我的方案界面 */
- (void)createPlanDetailViewWithFrame:(CGRect)frame
{
    _planDetailView = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:_planDetailView];
    [_planDetailView release];
}


/** 创建侧滑按钮和手势 */
- (void)createDrawerButtonAndPanGestureOnView:(UIView *)aView
{
    CGSize drawerButtonSize = CGSizeMake(ScalePx(46), ScalePx(86));
    //侧滑按钮
    _drawerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - drawerButtonSize.height) / 2,drawerButtonSize.width, drawerButtonSize.height)];
    [_drawerButton setBackgroundImage:[PublicUnit imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"drawer_icon" ofType:@"png"]] forState:UIControlStateNormal];
    [_drawerButton addTarget:self action:@selector(drawerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:_drawerButton];
    [_drawerButton release];
}

#pragma mark - touches response
- (void)drawerButtonClick:(UIButton *)sender
{
   //推出户型选择菜单
   [self showHouseStyleLeftMenuViewWithDuration:1.0f];
}

- (void)tap:(UITapGestureRecognizer *)tapGR
{
   UIView *touchView = tapGR.view;
   [self hideHouseStyleLeftMenuViewWithDuration:1.0f removeTouchView:touchView];
}

#pragma mark - drawer animation
- (void)showHouseStyleLeftMenuViewWithDuration:(NSTimeInterval)duration
{
   CGRect frame = _originalRectForHouseStyleLeftView;
   frame.origin.x = 0;
   
   [_houseStyleLeftView setFrame:frame withAnimationDuration:duration followedAnimationView:_planDetailView withDelegate:self];
}

- (void)hideHouseStyleLeftMenuViewWithDuration:(NSTimeInterval)duration removeTouchView:(UIView *)touchView
{
   [_houseStyleLeftView setFrame:_originalRectForHouseStyleLeftView withAnimationDuration:duration followedAnimationView:_planDetailView withDelegate:self];
}


#pragma mark - UIViewDrawerDelegate
- (void)drawerViewWillShow
{
   _drawerButton.alpha = 0;
   _houseStyleLeftView.alpha = 1;
}

- (void)drawerViewDidShow
{
   float width = [AppManager getInstance].appWidth;
   float height = [AppManager getInstance].appHeight;
   CGRect rect = CGRectMake(_houseStyleLeftView.frame.size.width, 0, width - _houseStyleLeftView.frame.size.width, height);
   
   UIView *touchView = [[UIView alloc] initWithFrame:rect];
   touchView.tag = TOUCHVIEW_TAG;
   [self.view addSubview:touchView];
   [touchView release];
   
   UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
   [touchView addGestureRecognizer:tapGR];
   [tapGR release];
}

- (void)drawerViewWillHide
{
   
}

- (void)drawerViewDidHide
{
   _houseStyleLeftView.alpha = 0;
   _drawerButton.alpha = 1;
   
   UIView *touchView = [self.view viewWithTag:TOUCHVIEW_TAG];
   [touchView removeFromSuperview];
}

@end
