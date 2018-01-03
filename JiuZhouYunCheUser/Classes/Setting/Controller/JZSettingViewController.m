//
//  JZSettingViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2018/1/3.
//  Copyright © 2018年 曹晓燕. All rights reserved.
//

#import "JZSettingViewController.h"
#import "JZSettingViewCell.h"
#import "JZSettingCell.h"

@interface JZSettingViewController ()

@end

@implementation JZSettingViewController

static NSString * const SettingViewID = @"SettingViewIDCell";
static NSString * const SettingID = @"SettingIDCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CGrayColor(235);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[JZSettingCell class] forCellReuseIdentifier:SettingID];
    [self.tableView registerClass:[JZSettingViewCell class] forCellReuseIdentifier:SettingViewID];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) return 2;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    JZSettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingViewID forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[JZSettingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingID];
//    }
//
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:SettingID];
    }
    return [tableView dequeueReusableCellWithIdentifier:SettingViewID];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
