//
//  JZLoginViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  手机号密码登录页

#import "JZLoginViewController.h"
#import "JZTabBarController.h"
#import "AppDelegate.h"
#import "JZUserBasicInfo.h"
#import "JZForgetPwdViewController.h"
#import "JZRegisterViewController.h"
#import "UtilityHelper.h"

#define KEYHEIGHT (iPhone5 ? 50 : 0.f)
#define BACKTOPHEIGHT (iPhoneX ? 35.f : 20.f)

@interface JZLoginViewController ()

@property (strong, nonatomic) UIButton *loginPasswordBtn;
@property (strong, nonatomic) UIButton *forgetpwdButton;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *pwdTextField;
@property (strong, nonatomic) UIButton *codeLoginBtn;

@property (nonatomic, strong) CHTTPSessionManager *manager;
@property(nonatomic,strong)NSDictionary *dic;

@end

@implementation JZLoginViewController

//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self createViewFrame];
    [self setNotification];
    if (_phoneTextField.text.length == 0 && _pwdTextField.text.length == 0) {
        _loginPasswordBtn.enabled = NO;
    }
    
}

#pragma mark - 通知
-(void)setNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 创建frame
-(void)createViewFrame
{
    //图标
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logoIcon"]];
    CGFloat iconX = (SCREEN_WIDTH - SCREEN_SCALE*88) / 2;
    CGFloat iconY = SCREEN_SCALE*88;
    CGFloat iconW = SCREEN_SCALE*88;
    CGFloat iconH = iconW;
    iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    [self.view addSubview:iconView];
    //手机号View
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_SCALE*36, CGRectGetMaxY(iconView.frame)+SCREEN_SCALE*18, SCREEN_WIDTH - SCREEN_SCALE*36*2, SCREEN_SCALE*128)];
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
    self.pwdTextField = [CFastAddsubView addTextField:CGRectMake(0, phoneView.c_height - 36, phoneView.c_width - 110, 30) font:15 placeholder:@"请输入密码" placeholderColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft superView:codeView];
    
    self.forgetpwdButton = [CFastAddsubView addbuttonWithRect:CGRectMake(codeView.c_width - 100, codeView.c_height - 36, 100, 30) LabelText:@"忘记密码" TextFont:15 NormalTextColor:CColor(255, 147, 51) highLightTextColor:nil  disabledColor:CGrayColor(153) SuperView:codeView buttonTarget:self Action:@selector(forgetPwdClicked)];
    
    [CFastAddsubView addLineViewRect:1 lineColor:[UtilityHelper colorWithHexString:@"#E3E3E3"] SuperView:codeView];
    
    //登录按钮
    self.loginPasswordBtn =  [CFastAddsubView addButtonWithRect:CGRectMake(SCREEN_SCALE*36, CGRectGetMaxY(backgroundView.frame) + SCREEN_SCALE*36, self.view.c_width - SCREEN_SCALE*36*2, SCREEN_SCALE*46) NormalBackgroundImageName:@"btnBgNormal" andDisabledBackgroundImageName:@"btnBgEnabled" superView:self.view titleText:@"密码登录" titleFont:[UIFont systemFontOfSize:18] TitleNormalColor:[UIColor whiteColor] TitleHighLightColor:[UIColor whiteColor] buttonTarget:self Action:@selector(loginButtonClicked)];
    self.loginPasswordBtn.layer.cornerRadius = iPhone5?20:23;
    self.loginPasswordBtn.layer.masksToBounds = YES;

    //返回验证码登录
    CGSize pwdSize = [CFastAddsubView getWordRealSizeWithFont:[UIFont systemFontOfSize:15] WithConstrainedRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithStr:@"验证码登录"];
    
    self.codeLoginBtn = [CFastAddsubView addbuttonWithRect:CGRectMake((self.view.c_width - pwdSize.width - 15) / 2, CGRectGetMaxY(self.loginPasswordBtn.frame) + SCREEN_SCALE*36, pwdSize.width + 17, pwdSize.height) LabelText:@"验证码登录" TextFont:15 NormalTextColor:[UtilityHelper colorWithHexString:@"#FF9333"] highLightTextColor:nil disabledColor:nil SuperView:self.view buttonTarget:self Action:@selector(codeButtonClicked)];
    self.codeLoginBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    UIImageView *pushImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"push"]];
    pushImage.frame = CGRectMake(pwdSize.width + 10, 0, 12, pwdSize.height);
    [self.codeLoginBtn addSubview:pushImage];

}



//密码登录
- (void)loginButtonClicked{
    if ([self verificationBeforeRequest]) {
        NSString *str = [NSString stringWithFormat:@"%@/login/login_telephone_ios/",TESTSERVER];
        // 请求参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"telephone"] = self.phoneTextField.text;
        parameters[@"password"] = self.pwdTextField.text;
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
                 AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 appDelegate.window.rootViewController = [[JZTabBarController alloc]init] ;
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [[NSUserDefaults standardUserDefaults] setObject:_phoneTextField.text forKey:@"telephone"];
                 [[NSUserDefaults standardUserDefaults] setObject:_pwdTextField.text forKey:@"password"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
             else{
                 [SVProgressHUD showError:self.dic[@"msg"]];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD showError:@"请求失败"];
         }];
    }
}

- (BOOL)verificationBeforeRequest {
    if ([UtilityHelper isValidatePhone:_phoneTextField.text] == NO){
        [SVProgressHUD showError:@"手机号输入错误"];
        return NO;
    }
    if([UtilityHelper checkPassword:self.pwdTextField.text] == NO) {
        [SVProgressHUD showError:@"密码格式错误，长度为6~20位，支持字母、数字及其组合"];
        return NO;
    }
    return YES;
}

//验证码登录
- (void)codeButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

//忘记密码
- (void)forgetPwdClicked{
    JZForgetPwdViewController *forgetVC = [[JZForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - 懒加载
- (CHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [CHTTPSessionManager manager];
    }
    return _manager;
}
#pragma mark - UITextFieldDelegate
//改变字符
-(void)textFieldDidChange
{
    self.loginPasswordBtn.enabled = (self.phoneTextField.text.length != 0 && self.pwdTextField.text.length != 0);
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
