//
//  JZTabBarController.m
//  JiuZhouYunCheYongHu
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "JZTabBarController.h"
#import "JZNavigationController.h"
#import "JZSearchViewController.h"
#import "JZQuoteViewController.h"
#import "JZDepartViewController.h"
#import "JZOrderViewController.h"
#import "JZScrambleViewController.h"

@interface JZTabBarController ()

@end

@implementation JZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置所有的文字属性
    [self setupTabBarItemAttrs];
    
    //添加子控制器
    [self setupChildViewControllers];
    
    [self setupTabBar];
}

-(void)setupTabBarItemAttrs
{
    UITabBarItem *item = [UITabBarItem appearance];
    //普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    normalAttrs[NSForegroundColorAttributeName] = CColor(146, 146, 146);
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    //选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = CColor(253, 128, 40);
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}
/**
 *  添加子控制器
 */
- (void)setupChildViewControllers
{
    [self setupOneChildViewController:[[JZNavigationController alloc]initWithRootViewController:[[JZSearchViewController alloc] init]] title:@"查询" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];

    [self setupOneChildViewController:[[JZNavigationController alloc]initWithRootViewController:[[JZQuoteViewController alloc]init]] title:@"报价" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];

    [self setupOneChildViewController:[[JZNavigationController alloc]initWithRootViewController:[[JZDepartViewController alloc]init]] title:@"发车" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];

    [self setupOneChildViewController:[[JZNavigationController alloc]initWithRootViewController:[[JZOrderViewController alloc]init]] title:@"订单" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    [self setupOneChildViewController:[[JZNavigationController alloc]initWithRootViewController:[[JZScrambleViewController alloc]init]] title:@"抢位" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
}
/**
 *  初始化一个子控制器
 *
 *  @param vc            子控制器
 *  @param title         标题
 *  @param image         图标
 *  @param selectedImage 选中的图标
 */
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.tabBarItem.title = title;
    if (image.length) {
        vc.tabBarItem.image = [UIImage imageNamed:image];
        
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    [self addChildViewController:vc];
    
}

/**
 *  更换TabBar
 */
-(void)setupTabBar
{
//    [self setValue:[[CTabBar alloc]init] forKeyPath:@"tabBar"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
