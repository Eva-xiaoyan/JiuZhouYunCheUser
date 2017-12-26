//
//  JZScrambleViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  抢车位

#import "JZScrambleViewController.h"

@interface JZScrambleViewController ()

@end

@implementation JZScrambleViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    [self basicSetting];
}

-(void)basicSetting
{
    self.navigationItem.title = @"抢空位";    
    self.view.backgroundColor = CColor(203, 203, 203);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
