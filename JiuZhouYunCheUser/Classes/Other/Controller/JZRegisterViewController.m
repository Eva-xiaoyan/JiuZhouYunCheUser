//
//  JZRegisterViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  手机号验证码登录页

#import "JZRegisterViewController.h"
#import "JZTabBarController.h"
#import "AppDelegate.h"
#import "JZUserBasicInfo.h"
#import "JZLoginViewController.h"
#import "UtilityHelper.h"
#define KEYHEIGHT (iPhone5 ? 50.f : 0.0f)

@interface JZRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIView *otherLoginView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineLayoutConstraint;

@property(nonatomic,strong)NSDictionary *dic;
@property (nonatomic, assign) int countFlag;           // 验证码倒计时相关
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CHTTPSessionManager *manager;

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
    self.navigationController.navigationBar.hidden = YES;
    [self setNotificationShow];
    [self setTheThirdLoginHiddenAndOtherSetting];
}

#pragma mark - 第三方登录
-(void)setTheThirdLoginHiddenAndOtherSetting
{
    if(![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        _wechatBtn.hidden = YES;
    }
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        _qqButton.hidden = YES;
    }
    if(![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]
       || ![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
        _qqButton.hidden = YES;
    }
    if(_wechatBtn.isHidden && _qqButton.isHidden) {
        _otherLoginView.hidden = YES;
    }
    if (_phoneTextField.text.length == 0) {
        _getCodeBtn.enabled = NO;
    }
    if (_phoneTextField.text.length == 0 && _codeTextField.text.length == 0) {
        _codeLoginBtn.enabled = NO;
    }
    if (iPhoneX) {
        self.bottomLineLayoutConstraint.constant = 55;
    }
}

#pragma mark - 通知
-(void)setNotificationShow
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (IBAction)qqLoginButtonClicked:(UIButton *)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
        if(!error) {
            [SVProgressHUD showSuccess:@"登录中..."];
            UMSocialUserInfoResponse *respone = result;
            NSString *string = [NSString stringWithFormat:@"%@/login/login_ios_qq/",TESTSERVER];
            //请求参数
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"type"] = @"qq";
            parameters[@"openId"] = respone.openid;
            parameters[@"nickname"] = respone.name;
            parameters[@"avatar"] = respone.iconurl;
            parameters[@"unionid"] = respone.openid;
            
            [_manager POST:string parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 self.dic = dic;
                 NSInteger code = 0;
                 if ([dic[@"code"] isSafeObj]) {
                     code = [self.dic[@"code"] integerValue];
                 }
                 if(code == 1 ) {
                     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     appDelegate.window.rootViewController = [[JZTabBarController alloc]init];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     [[NSUserDefaults standardUserDefaults] setObject:@"qq" forKey:@"type"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.name forKey:@"nickname"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.openid forKey:@"openId"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.iconurl forKey:@"avatar"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.openid forKey:@"unionid"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else{
                     [SVProgressHUD showError:self.dic[@"msg"]];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [SVProgressHUD showError:@"请求失败"];
             }];
        }
    }];
}

- (IBAction)wechatLoginButtonClicked:(UIButton *)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        if(!error) {
            [SVProgressHUD showSuccess:@"登录中..."];
            UMSocialUserInfoResponse *respone = result;
            NSString *string = [NSString stringWithFormat:@"%@/login/login_ios_wx/",TESTSERVER];
            //请求参数
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"type"] = @"wechat";
            parameters[@"openId"] = respone.openid;
            parameters[@"nickname"] = respone.name;
            parameters[@"avatar"] = respone.iconurl;
            parameters[@"unionid"] = respone.uid;
            
            [_manager POST:string parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 self.dic = dic;
                 NSInteger code = 0;
                 if ([dic[@"code"] isSafeObj]) {
                     code = [self.dic[@"code"] integerValue];
                 }
                 if(code == 1 ) {
                     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     appDelegate.window.rootViewController = [[JZTabBarController alloc]init];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     [[NSUserDefaults standardUserDefaults] setObject:@"wechat" forKey:@"type"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.name forKey:@"nickname"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.openid forKey:@"openId"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.iconurl forKey:@"avatar"];
                     [[NSUserDefaults standardUserDefaults] setObject:respone.uid forKey:@"unionid"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else{
                     [SVProgressHUD showError:self.dic[@"msg"]];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [SVProgressHUD showError:@"请求失败"];
             }];
        }
    }];
}

#pragma mark - 键盘高度
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
//改变按钮的点击状态
-(void)textFieldDidChange
{
    self.getCodeBtn.enabled = (self.phoneTextField.text.length != 0);
    self.codeLoginBtn.enabled = (self.phoneTextField.text.length != 0 && self.codeTextField.text.length != 0);
}


//获取验证码
- (IBAction)getCodeButtonClicked {
    if ([UtilityHelper isValidatePhone:self.phoneTextField.text]) {
        NSString *str = [NSString stringWithFormat:@"%@/login/send_message_app/",TESTSERVER];
        //请求参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"telephone"] = self.phoneTextField.text;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [manager POST:str parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.dic = dic;
            NSInteger code = 0;
            if ([dic[@"code"] isSafeObj]) {
                code = [self.dic[@"code"] integerValue];
            }
            if(code == 1) {
                [SVProgressHUD showSuccess:[self.dic[@"msg"] safeString]];
                self.countFlag = 60;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeShow) userInfo:nil repeats:YES];
                });
            }
            else{
                [SVProgressHUD showError:self.dic[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showError:@"获取验证码失败"];
        }];
    }else{
        if ([UtilityHelper isValidatePhone:_phoneTextField.text] == NO){
            [SVProgressHUD showError:@"手机号输入错误"];
        }
    }
}

//60秒倒计时
- (void)changeTimeShow
{
    if (self.countFlag>1) {
        self.countFlag--;
        self.getCodeBtn.userInteractionEnabled = NO;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",self.countFlag] forState:UIControlStateNormal];
    }else{
        [self.timer invalidate];
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    }
}

//验证码登录
- (IBAction)codeLoginButtonClicked {
    if ([self verificationBeforeRequest]) {
        [self getNetWorkRequest];
    }
}

-(void)getNetWorkRequest
{
    NSString *string = [NSString stringWithFormat:@"%@/login/login_msg_ios/",TESTSERVER];
    //请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"telephone"] = self.phoneTextField.text;
    parameters[@"mcode"] = self.codeTextField.text;
    // 设置请求体和多值参数
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:string parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.dic = dic;
         NSInteger code = 0;
         if ([dic[@"code"] isSafeObj]) {
             code = [self.dic[@"code"] integerValue];
         }
         if(code == 1 ) {
             if ([self.dic[@"data"] integerValue] == 1) {
                 AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 appDelegate.window.rootViewController = [[JZTabBarController alloc]init];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [[NSUserDefaults standardUserDefaults] setObject:_phoneTextField.text forKey:@"telephone"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }else{
                 [SVProgressHUD showSuccess:[self.dic[@"msg"] safeString]];
             }
         }else{
             [SVProgressHUD showError:self.dic[@"msg"]];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD showError:@"请求失败"];
     }];
}


- (BOOL)verificationBeforeRequest {
    if ([UtilityHelper isValidatePhone:_phoneTextField.text] == NO){
        [SVProgressHUD showError:@"手机号输入错误"];
        return NO;
    }
    if(_codeTextField.text.length != 4) {
        [SVProgressHUD showError:@"输入的验证码不正确"];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//下载客户端
- (IBAction)gotoAppStore {
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/%E4%B9%9D%E5%B7%9E%E8%BF%90%E8%BD%A6%E7%89%A9%E6%B5%81%E7%89%88/id1318609107?mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

//密码登录
- (IBAction)pwdLoginClick {
    JZLoginViewController *loginVC = [[JZLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}


//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
