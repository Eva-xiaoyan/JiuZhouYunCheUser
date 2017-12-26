//
//  JZGuidePageViewController.m
//  JiuZhouYunCheUser
//
//  Created by hengshi on 2017/12/25.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "JZGuidePageViewController.h"
#import "AppDelegate.h"
#import "JZRegisterViewController.h"
#import "JZNavigationController.h"

#define WIDTH (NSInteger)self.view.bounds.size.width
#define HEIGHT (NSInteger)self.view.bounds.size.height
#define SKIPHEIGHT (iPhoneX ? 30.f : 0.0f)
#define PAGECONTROLHEIGHT (iPhoneX ? 15.f : 0.0f)

@interface JZGuidePageViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property(nonatomic, assign)BOOL flag;
@end

@implementation JZGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scrollView = scrollView;
    for (int i=0; i<4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpg",i+1]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        // 在最后一页创建按钮
        if (i == 3) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((WIDTH - 144) / 2, HEIGHT - 80-PAGECONTROLHEIGHT, 144, 40);
            [button setImage:[UIImage imageNamed:@"experience"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pushToController:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        
        if (i != 3) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            skipBtn.frame = CGRectMake(WIDTH - 70, 30+SKIPHEIGHT, 50, 25);
            [skipBtn setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
            [skipBtn addTarget:self action:@selector(pushToController:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:skipBtn];
        }
        imageView.image = image;
        [scrollView addSubview:imageView];
    }
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, SCREEN_HEIGHT);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((WIDTH - 80) / 2, HEIGHT - 45 - PAGECONTROLHEIGHT, 80, 30)];
    // 设置页数
    _pageControl.numberOfPages = 4;
    // 设置页码的点的颜色
    _pageControl.pageIndicatorTintColor = CColor(220, 220, 220);
    // 设置当前页码的点颜色
    _pageControl.currentPageIndicatorTintColor = CColor(132, 132, 132);
    [self.view addSubview:_pageControl];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算当前在第几页
    _pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
}

// 点击按钮保存数据并切换根视图控制器
- (void) pushToController:(UIButton *)sender{
    _flag = YES;
    NSUserDefaults *useDefaults = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [useDefaults setBool:_flag forKey:@"notFirst"];
    [useDefaults synchronize];
    // 切换根视图控制器
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    JZNavigationController *nav = [[JZNavigationController alloc] initWithRootViewController:[[JZRegisterViewController alloc]init]];
    appDelegate.window.rootViewController = nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
