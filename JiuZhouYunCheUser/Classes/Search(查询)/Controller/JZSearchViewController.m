//
//  JZSearchViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  查询

#import "JZSearchViewController.h"
#import "JZSettingViewController.h"

@interface JZSearchViewController ()

@end

@implementation JZSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicSetting];
}

-(void)basicSetting
{
    self.navigationItem.title = @"运价查询";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"choose_n" highImage:@"choose_n" target:self action:@selector(pushToSettingVC)];
    self.view.backgroundColor = CGrayColor(235);
}

-(void)pushToSettingVC
{
    JZSettingViewController *settingVC = [[JZSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)setupTopTitle
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
