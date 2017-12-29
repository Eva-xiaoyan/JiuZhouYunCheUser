//
//  ProtocolViewController.m
//  hehexiao
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 chris. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController  ()
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopView];
    [self addWebView];
}

-(void)addTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.c_width, 64)];
    topView.backgroundColor = CColor(253, 140, 37);
    [self.view addSubview:topView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((self.view.c_width - 90) / 2, 30, 90, 23)];
    title.text = @"用户协议";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:18];
    [topView addSubview:title];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 30, 40, 30)];
//    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 10, 18)];
    imageView.image = [UIImage imageNamed:@"return"];
    [backBtn addSubview:imageView];
    [topView addSubview:backBtn];
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.c_width, self.view.c_height-64)];
    self.webView = webView;
    [self.view addSubview:webView];
    
    [self addProtocolContent];
}

-(void)addProtocolContent
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSURL *url = [[NSURL alloc] initWithString:filePath];
        [self.webView loadHTMLString:htmlString baseURL:url];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
