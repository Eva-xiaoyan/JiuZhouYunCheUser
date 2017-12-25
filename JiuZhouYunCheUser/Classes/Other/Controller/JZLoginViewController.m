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

@property (weak, nonatomic) IBOutlet UIButton *loginPasswordBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;



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
    self.navigationController.navigationBar.hidden = YES;
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

//密码登录
- (IBAction)loginButtonClicked:(UIButton *)sender {
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
- (IBAction)codeButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//忘记密码
- (IBAction)forgetPwdClick {
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
