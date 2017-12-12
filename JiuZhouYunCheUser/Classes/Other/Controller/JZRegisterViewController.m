//
//  JZRegisterViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  注册页

#import "JZRegisterViewController.h"
#import "JZTabBarController.h"
#import "AppDelegate.h"
#import "JZUserBasicInfo.h"

@interface JZRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic, strong) CHTTPSessionManager *manager;
@property(nonatomic,strong)NSDictionary *dic;

@end

@implementation JZRegisterViewController
#pragma mark - 懒加载
- (CHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [CHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark - 按钮点击
//注册
- (IBAction)registerClick {
    
}

-(void)getLoginNetworkRequest
{
    // 取消所有的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    NSString *str = @"http://m.jiuzhouyunche.com/iosuser/login/register_ ios/";
    //请求参数
    NSDictionary *parameters = @{@"nickname" : _userNameTextField.text,
                                 @"pwd" : _pwdTextField.text};
    [self.manager POST:str parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.dic = dic;
         
         NSInteger code = 0;
         if ([dic[@"code"] isSafeObj]) {
             code = [self.dic[@"code"] integerValue];
         }
         if(code == 1) {
             [SVProgressHUD showSuccess:self.dic[@"msg"]];
             [JZUserBasicInfo saveLoginUserName:_userNameTextField.text password:_pwdTextField.text];
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.window.rootViewController = [[JZTabBarController alloc]init];
         }else{
             [SVProgressHUD showError:self.dic[@"msg"]];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD showError:@"网络异常，请稍后再试"];
     }];
}


//返回登录点击
- (IBAction)loginClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
