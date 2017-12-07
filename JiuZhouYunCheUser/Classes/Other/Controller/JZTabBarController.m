//
//  JZTabBarController.m
//  JiuZhouYunCheYongHu
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "JZTabBarController.h"

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
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    //选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}
/**
 *  添加子控制器
 */
- (void)setupChildViewControllers
{
//    [self setupOneChildViewController:[[CNavigationController alloc]initWithRootViewController:[[CEssenceViewController alloc] init]] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
//
//    [self setupOneChildViewController:[[CNavigationController alloc]initWithRootViewController:[[CNewViewController alloc]init]] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
//
//    [self setupOneChildViewController:[[CNavigationController alloc]initWithRootViewController:[[CFriendTrendViewController alloc]init]] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
//
//    [self setupOneChildViewController:[[CNavigationController alloc]initWithRootViewController:[[CMeViewController alloc]init]] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
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
