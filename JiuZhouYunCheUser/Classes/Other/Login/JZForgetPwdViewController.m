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
@property (strong, nonatomic) UIButton *getCodeBtn;
@property (strong, nonatomic) UIButton *finishBtn;

@property (nonatomic, strong) CHTTPSessionManager *manager;
@property(nonatomic,strong)NSDictionary *dic;
@property (nonatomic, assign) int countFlag; // 验证码倒计时相关
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JZForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
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
        _getCodeBtn.enabled = NO;
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
    self.getCodeBtn.enabled = (self.phoneTextField.text.length != 0);
    self.finishBtn.enabled = (self.phoneTextField.text.length != 0 && self.codeTextField.text.length != 0 && self.pwdTextField.text.length != 0);
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
        self.getCodeBtn.userInteractionEnabled = NO;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)",self.countFlag] forState:UIControlStateNormal];
    }else{
        [self.timer invalidate];
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
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
