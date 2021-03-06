//
//  JZNavigationController.m
//  JiuZhouYunCheYongHu
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "JZNavigationController.h"

@interface JZNavigationController ()<UIGestureRecognizerDelegate>


@end

@implementation JZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.barTintColor = CColor(253, 128, 40);
    //设置状态栏和导航栏的颜色都为白色
    //    self.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    //导航栏设置图片
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"image01"] forBarMetrics:UIBarMetricsDefault];

}

/**
 *  重写push方法的目的 : 拦截所有push进来的子控制器
 *
 *  @param viewController 刚刚push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        {//如果viewController不是最早push进来的子控制器
            //左上角
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
            [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
            [backButton setTitle:@"返回" forState:UIControlStateNormal];
            [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [backButton sizeToFit];
            //这句代码放在sizeToFit后面
            backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
            [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
            
            //隐藏底部的工具条
//            viewController.hidesBottomBarWhenPushed = YES;
        }
        
    }
    //所有的设置搞定后，再push控制器
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>
/**
 *  手势识别器对象会调用这个代理方法来决定手势是否有效
 *
 *  @return YES : 手势有效, NO : 手势无效
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 手势何时有效 : 当导航控制器的子控制器个数 > 1就有效
    return self.childViewControllers.count > 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
