//
//  JZOrderViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  订单

#import "JZOrderViewController.h"

@interface JZOrderViewController ()

@end

@implementation JZOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicSetting];
}

-(void)basicSetting
{
    self.navigationItem.title = @"我的订单";    
    self.view.backgroundColor = CColor(203, 203, 203);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
