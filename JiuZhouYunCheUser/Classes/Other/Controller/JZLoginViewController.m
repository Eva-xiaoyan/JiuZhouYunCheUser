//
//  JZLoginViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  登录页

#import "JZLoginViewController.h"
#import "JZTabBarController.h"
#import "AppDelegate.h"
#import "JZUserBasicInfo.h"
#import "JZForgetPwdViewController.h"
#import "JZRegisterViewController.h"

#define KEYHEIGHT (iPhone5 ? 120.f : 90.f)

@interface JZLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdLoginView;
@property (nonatomic, strong) CHTTPSessionManager *manager;

@property(nonatomic,strong)NSDictionary *dic;

@end

@implementation JZLoginViewController
#pragma mark - 懒加载
- (CHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [CHTTPSessionManager manager];
    }
    return _manager;
}
//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self keyboardNotification];
    [self setupThirdLoginHiddenOrNo];
}

#pragma mark - 键盘显示通知
-(void)keyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//键盘将要出现
- (void)handleKeyboardWillShow:(NSNotification *)paramNotification
{
    self.view.transform = CGAffineTransformMakeTranslation(0, -KEYHEIGHT);
}

//键盘将要隐藏
- (void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    self.view.transform = CGAffineTransformIdentity;
}


#pragma mark - 按钮点击
//登录按钮点击
- (IBAction)loginClick {
    [self getLoginNetworkRequest];
}

-(void)getLoginNetworkRequest
{
    NSString *str = @"http://m.jiuzhouyunche.com/iosuser/login/login_ ios/";
    //请求参数
    NSDictionary *parameters = @{@"nickname" : _userNameTextField.text,
                                 @"pwd" : _pwdTextField.text};
    [_manager POST:str parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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


//忘记密码点击
- (IBAction)forgetPwdClick {
    JZForgetPwdViewController *forgetPwdVC = [[JZForgetPwdViewController alloc]init];
    [self presentViewController:forgetPwdVC animated:YES completion:nil];
}

//立即注册点击
- (IBAction)registerClick {
    JZRegisterViewController *registerVC = [[JZRegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}

#pragma mark - 第三方登录
-(void)setupThirdLoginHiddenOrNo
{
    if(![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        _wechatBtn.hidden = YES;
    }
    
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        _QQBtn.hidden = YES;
    }
    
    if(![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]
       || ![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
        _QQBtn.hidden = YES;
    }
    
    if(_wechatBtn.isHidden && _QQBtn.isHidden) {
        _thirdLoginView.hidden = YES;
    }
}

//微信登录点击
- (IBAction)wechatClick {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error)
    {
        if(!error) {
            UMSocialUserInfoResponse *response = result;

            NSString *urlString = @"http://m.jiuzhouyunche.com/iosuser/login/login_ios_wx/";
            NSDictionary *parameters = @{
                                         @"type" : @"wechat",
                                         @"openId" : response.openid,
                                         @"nickname" : response.name,
                                         @"avatar" : response.iconurl,
                                         @"unionid" : response.unionId
                                         };
            [_manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.window.rootViewController = [[JZTabBarController alloc]init];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showError:@"登录失败，请稍后再试"];
            }];
        }
    }];
}

//QQ登录点击
- (IBAction)qqClick {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if(!error) {
            UMSocialUserInfoResponse *response = result;
            
            NSString *urlString = @"http://m.jiuzhouyunche.com/iosuser/login/login_ios_wx/";
            NSDictionary *parameters = @{
                                         @"type" : @"qq",
                                         @"openId" : response.openid,
                                         @"nickname" : response.name,
                                         @"avatar" : response.iconurl,
                                         @"unionid" : response.openid
                                         };
            [_manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.window.rootViewController = [[JZTabBarController alloc]init];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showError:@"登录失败，请稍后再试"];
            }];
        }
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
