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

@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UIButton *codeLoginButton;
@property(nonatomic,strong)UIButton *toWuliu;
@property(nonatomic,strong)UIButton *pushToPwdLogin;

//第三方登录
@property(nonatomic,strong)UIButton *wechatBtn;
@property(nonatomic,strong)UIButton *qqButton;
@property(nonatomic,strong)UIView *otherLoginView;

@property(nonatomic,strong)NSDictionary *dic;
@property (nonatomic, assign) int countFlag;  // 验证码倒计时相关
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNotificationShow];
    [self createViewFrame];
    [self setTheThirdLoginHiddenAndOtherSetting];
    [self textFieldDidChange];
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
    [_wechatBtn addTarget:self action:@selector(wechatLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_qqButton addTarget:self action:@selector(qqLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 通知
-(void)setNotificationShow
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)qqLoginButtonClicked:(UIButton *)sender {
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

- (void)wechatLoginButtonClicked:(UIButton *)sender {
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

#pragma mark - 创建frame
-(void)createViewFrame
{
    //图标
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoIcon"]];
    CGFloat iconX = (SCREEN_WIDTH - SCREEN_SCALE(88)) / 2;
    CGFloat iconY = SCREEN_SCALE(88);
    CGFloat iconW = SCREEN_SCALE(88);
    CGFloat iconH = iconW;
    iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    [self.view addSubview:iconView];
    //手机号View
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_SCALE(36), CGRectGetMaxY(iconView.frame)+SCREEN_SCALE(18), SCREEN_WIDTH - SCREEN_SCALE(36)*2, SCREEN_SCALE(128))];
    [self.view addSubview:backgroundView];
    
    //输入手机号
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backgroundView.c_width, backgroundView.c_height / 2)];
    [backgroundView addSubview:phoneView];
    UITextField *phoneTextField = [CFastAddsubView addTextField:CGRectMake(0, phoneView.c_height - 36, phoneView.c_width, 30) font:15 placeholder:@"请输入手机号" placeholderColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft superView:phoneView];
    self.phoneTextField = phoneTextField;
    [CFastAddsubView addLineViewRect:1 lineColor:[UtilityHelper colorWithHexString:@"#E3E3E3"] SuperView:phoneView];
    
    //输入验证码
    UIView *codeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame), backgroundView.c_width, backgroundView.c_height / 2)];
    [backgroundView addSubview:codeView];
    UITextField *codeTextField = [CFastAddsubView addTextField:CGRectMake(0, phoneView.c_height - 36, phoneView.c_width - 110, 30) font:15 placeholder:@"请输入验证码" placeholderColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft superView:codeView];
    self.codeTextField = codeTextField;
    UIButton *codeButton = [CFastAddsubView addbuttonWithRect:CGRectMake(codeView.c_width - 100, codeView.c_height - 36, 100, 30) LabelText:@"获取验证码" TextFont:15 NormalTextColor:CColor(255, 147, 51) highLightTextColor:nil  disabledColor:CGrayColor(153) SuperView:codeView buttonTarget:self Action:@selector(getCodeButtonClicked)];
    self.codeButton = codeButton;
    [CFastAddsubView addLineViewRect:1 lineColor:[UtilityHelper colorWithHexString:@"#E3E3E3"] SuperView:codeView];
    
    
    
    
    
    
    
    
    
    //第三方登录
    CGFloat thridViewY = self.view.c_height - SCREEN_SCALE(46) - SCREEN_SCALE(75);
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, thridViewY, self.view.c_width, SCREEN_SCALE(75))];
    [self.view addSubview:thirdView];
    
    CGSize labelSize = [CFastAddsubView getWordRealSizeWithFont:[UIFont systemFontOfSize:12] WithConstrainedRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithStr:@"其他方式登录"];
    UILabel *thirdLabel = [CFastAddsubView addLabelWithFrame:CGRectMake((thirdView.c_width - labelSize.width) / 2, 0, labelSize.width, labelSize.height) text:@"其他方式登录" textColor:@"#BEBEBE" textAlignment:NSTextAlignmentCenter fontSize:12 superView:thirdView];
    [CFastAddsubView addLineWithRect:CGRectMake(SCREEN_SCALE(74), labelSize.height / 2, (SCREEN_WIDTH - labelSize.width)/2 - SCREEN_SCALE(88), 1) lineColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] SuperView:thirdView];
    [CFastAddsubView addLineWithRect:CGRectMake( CGRectGetMaxX(thirdLabel.frame) + SCREEN_SCALE(14), labelSize.height / 2, 70, 1) lineColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] SuperView:thirdView];
    
//    UIButton *
    
    
    
    
    
    
    
}

//改变按钮的点击状态
-(void)textFieldDidChange
{
    self.codeButton.enabled = (self.phoneTextField.text.length != 0);
    self.codeLoginButton.enabled = (self.phoneTextField.text.length != 0 && self.codeTextField.text.length != 0);
}

//获取验证码
- (void)getCodeButtonClicked {
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
        self.codeButton.userInteractionEnabled = NO;
        [self.codeButton setTitle:[NSString stringWithFormat:@"重新发送(%d)",self.countFlag] forState:UIControlStateNormal];
    }else{
        [self.timer invalidate];
        self.codeButton.userInteractionEnabled = YES;
        [self.codeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
    }
}

//验证码登录
- (void)codeLoginButtonClicked {
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
- (void)gotoAppStore {
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/%E4%B9%9D%E5%B7%9E%E8%BF%90%E8%BD%A6%E7%89%A9%E6%B5%81%E7%89%88/id1318609107?mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}

//密码登录
- (void)pwdLoginClick {
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
