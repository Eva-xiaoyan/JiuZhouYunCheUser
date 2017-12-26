//
//  JZDepartViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  发车

#import "JZDepartViewController.h"

@interface JZDepartViewController ()

@end

@implementation JZDepartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicSetting];
}

-(void)basicSetting
{
    self.navigationItem.title = @"我要发车";
    self.view.backgroundColor = CColor(203, 203, 203);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
