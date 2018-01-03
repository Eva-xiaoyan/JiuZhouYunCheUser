//
//  JZForgetPwdViewController.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  忘记密码

#import "JZForgetPwdViewController.h"
#import "JZUserBasicInfo.h"
#import "AppDelegate.h"
#import "JZTabBarController.h"
#import "UtilityHelper.h"
#define KEYHEIGHT (iPhone5 ? 10.f : 0.f)

@interface JZForgetPwdViewController ()

@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *codeTextField;

@property (strong, nonatomic) UITextField *pwdTextField;
@property (strong, nonatomic) UIButton *codeBtn;
@property (strong, nonatomic) UIButton *finishBtn;

@property (nonatomic, strong) CHTTPSessionManager *manager;
@property(nonatomic,strong)NSDictionary *dic;
@property (nonatomic, assign) int countFlag; // 验证码倒计时相关
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JZForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self createViewFrame];
    [self setNotificationShow];
    [self otherSetting];
   
}

#pragma mark - 通知和其他设置
-(void)setNotificationShow
{
    //通知键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)otherSetting
{
    
    if (_phoneTextField.text.length == 0) {
        _codeBtn.enabled = NO;
    }
    if (_phoneTextField.text.length == 0 && _codeTextField.text.length == 0 && _pwdTextField.text.length == 0) {
        _finishBtn.enabled = NO;
    }
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
//改变字符
-(void)textFieldDidChange
{
    self.codeBtn.enabled = (self.phoneTextField.text.length != 0);
    self.finishBtn.enabled = (self.phoneTextField.text.length != 0 && self.codeTextField.text.length != 0 && self.pwdTextField.text.length != 0);
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createViewFrame
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT + 16, self.view.c_width, 20)];
    [self.view addSubview:topView];
    [CFastAddsubView addLabelWithFrame:CGRectMake((topView.c_width - 100) / 2, 0, 100, 20) text:@"找回密码" textColor:@"#000000" textAlignment:NSTextAlignmentCenter fontSize:18 superView:topView];
    UIButton *backBtn = [CFastAddsubView addButtonWithRect:CGRectMake(0, 0, 30, topView.c_height) image:@"back" highlightedImage:nil target:self selector:@selector(back) superView:topView];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    
    //手机号View
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_SCALE*36, CGRectGetMaxY(topView.frame)+SCREEN_SCALE*36, SCREEN_WIDTH - SCREEN_SCALE*36*2, SCREEN_SCALE*192)];
    [self.view addSubview:backgroundView];
    //输入手机号
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backgroundView.c_width, backgroundView.c_height / 3)];
    [backgroundView addSubview:phoneView];
    self.phoneTextField = [CFastAddsubView addTextField:CGRectMake(0, phoneView.c_height - 36, phoneView.c_width, 30) font:15 placeholder:@"请输入手机号" placeholderColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft superView:phoneView];
    [CFastAddsubView addLineViewRect:1 lineColor:[UtilityHelper colorWithHexString:@"#E3E3E3"] SuperView:phoneView];

    //输入验证码
    UIView *codeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame), backgroundView.c_width, backgroundView.c_height / 3)];
    [backgroundView addSubview:codeView];
    self.codeTextField = [CFastAddsubView addTextField:CGRectMake(0, phoneView.c_height - 36, phoneView.c_width - 110, 30) font:15 placeholder:@"请输入验证码" placeholderColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft superView:codeView];
    self.codeBtn = [CFastAddsubView addbuttonWithRect:CGRectMake(codeView.c_width - 100, codeView.c_height - 36, 100, 30) LabelText:@"获取验证码" TextFont:15 NormalTextColor:CColor(255, 147, 51) highLightTextColor:nil  disabledColor:CGrayColor(153) SuperView:codeView buttonTarget:self Action:@selector(getCodeClick:)];
    [CFastAddsubView addLineViewRect:1 lineColor:[UtilityHelper colorWithHexString:@"#E3E3E3"] SuperView:codeView];
    
    //设置密码
    UIView *pwdView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(codeView.frame), backgroundView.c_width, backgroundView.c_height / 3)];
    [backgroundView addSubview:pwdView];
    self.phoneTextField = [CFastAddsubView addTextField:CGRectMake(0, phoneView.c_height - 36, phoneView.c_width, 30) font:15 placeholder:@"请输入密码" placeholderColor:[UtilityHelper colorWithHexString:@"#BEBEBE"] keyboardType:UIKeyboardTypeNumberPad borderStyle:UITextBorderStyleNone textAlignment:NSTextAlignmentLeft superView:pwdView];
    [CFastAddsubView addLineViewRect:1 lineColor:[UtilityHelper colorWithHexString:@"#E3E3E3"] SuperView:pwdView];

    //登录按钮
    self.finishBtn =  [CFastAddsubView addButtonWithRect:CGRectMake(SCREEN_SCALE*36, CGRectGetMaxY(backgroundView.frame) + SCREEN_SCALE*36, self.view.c_width - SCREEN_SCALE*36*2, SCREEN_SCALE*46) NormalBackgroundImageName:@"btnBgNormal" andDisabledBackgroundImageName:@"btnBgEnabled" superView:self.view titleText:@"完  成" titleFont:[UIFont systemFontOfSize:18] TitleNormalColor:[UIColor whiteColor] TitleHighLightColor:[UIColor whiteColor] buttonTarget:self Action:@selector(finishBtnClick:)];
    self.finishBtn.layer.cornerRadius = iPhone5?20:23;
    self.finishBtn.layer.masksToBounds = YES;
    
}

//获取验证码
- (void)getCodeClick:(UIButton *)sender {
    if ([UtilityHelper isValidatePhone:self.phoneTextField.text]) {
        NSString *str = [NSString stringWithFormat:@"%@/login/send_message_app/",TESTSERVER];
        // 请求参数
        NSDictionary *parameters = @{ @"telephone" : self.phoneTextField.text};
        [_manager POST:str parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        [SVProgressHUD showError:@"输入手机号错误"];
    }
}

//60秒倒计时
- (void)changeTimeShow
{
    if (self.countFlag>1) {
        self.countFlag--;
        self.codeBtn.userInteractionEnabled = NO;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",self.countFlag] forState:UIControlStateNormal];
    }else{
        [self.timer invalidate];
        self.codeBtn.userInteractionEnabled = YES;
        [self.codeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
    }
}

- (void)finishBtnClick:(id)sender {
    if ([self checkAllOfTextField]) {
        [self getNetWorkRequest];
    }
}

-(void)getNetWorkRequest
{
    NSString *str = [NSString stringWithFormat:@"%@/login/forget_phone_ios/",TESTSERVER];
    //请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"telephone"] = self.phoneTextField.text;
    parameters[@"password"] = self.pwdTextField.text;
    parameters[@"code"] = self.codeTextField.text;
   
    [_manager POST:str parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.dic = dic;
         NSInteger code = 0;
         code = [self.dic[@"code"] integerValue];
         if(code == 1) {
             [SVProgressHUD showSuccess:[self.dic[@"msg"] safeString]];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else {
             [SVProgressHUD showError:self.dic[@"msg"]];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD showError:@"请求失败"];
     }];
}


-(BOOL)checkAllOfTextField
{
    if ([UtilityHelper isValidatePhone:_phoneTextField.text] == NO){
        [SVProgressHUD showError:@"输入手机号错误"];
        return NO;
    }
    if (_codeTextField.text.length != 4) {
        [SVProgressHUD showError:@"验证码格式错误"];
        return NO;
    }
    if (![UtilityHelper checkPassword:_pwdTextField.text]) {
        [SVProgressHUD showError:@"密码格式错误，长度为6~20位，支持字母、数字及其组合"];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark - 懒加载
- (CHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [CHTTPSessionManager manager];
    }
    return _manager;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
