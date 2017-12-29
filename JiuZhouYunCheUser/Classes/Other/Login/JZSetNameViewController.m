//
//  JZSetNameViewController.m
//  JiuZhouYunCheUser
//
//  Created by hengshi on 2017/12/21.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//  设置昵称和密码

#import "JZSetNameViewController.h"
#import "ProtocolViewController.h"
#import "AppDelegate.h"
#import "JZRegisterViewController.h"
#import "UtilityHelper.h"
#define KEYHEIGHT (iPhone5 ? 30.f : 0.f)
//#define BACKTOPHEIGHT (iPhoneX ? 35.f : 20.f)

@interface JZSetNameViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *userNameTextField;
@property (strong, nonatomic) UITextField *pwdTextField;
@property (strong, nonatomic) UIButton *chooseBtn;
@property (strong, nonatomic) UIButton *finishBtn;
@property(nonatomic,strong)NSDictionary *dic;

@end

@implementation JZSetNameViewController
//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];

    if (_userNameTextField.text.length == 0 && _pwdTextField.text.length == 0) {
        _finishBtn.enabled = NO;
    }
    self.userNameTextField.delegate = self;

    self.chooseBtn.selected = YES;
    self.chooseBtn.imageEdgeInsets = UIEdgeInsetsMake(9, self.chooseBtn.c_width - 13, 8, 5);
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

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

//改变字符
-(void)textFieldDidChange
{
    self.finishBtn.enabled = (self.userNameTextField.text.length != 0 && self.pwdTextField.text.length != 0);
}
//查看协议
- (void)protocolBtnClick {
    ProtocolViewController *protocolVC = [[ProtocolViewController alloc]init];
    [self presentViewController:protocolVC animated:YES completion:nil];
}
//完成按钮
- (void)finishClick:(id)sender {
    if ([self verificationBeforeRequest]) {
        [self getNetWorkRequest];
    }
}
-(void)getNetWorkRequest
{
    NSString *str = [NSString stringWithFormat:@"%@/login/set_userinfo_ios/",TESTSERVER];
    // 请求参数
    NSString *nickname = [self encodeString:self.userNameTextField.text];
    NSDictionary *param =@{@"nickname":nickname,@"password":self.pwdTextField.text};
    
    // 设置请求体和多值参数
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:str parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.dic = dic;
         NSInteger code = 0;
         if ([dic[@"code"] isSafeObj]) {
             code = [self.dic[@"code"] integerValue];
         }
         if(code == 1) {
             [SVProgressHUD showSuccess:[self.dic[@"msg"] safeString]];
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             
             appDelegate.window.rootViewController = [[JZRegisterViewController alloc]init];
             
             [self dismissViewControllerAnimated:YES completion:nil];
             [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"userName"];
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

- (BOOL)verificationBeforeRequest {
    if(![UtilityHelper checkPassword:_pwdTextField.text]) {
        [SVProgressHUD showError:@"密码格式错误，长度为6~20位，支持字母、数字及其组合"];
        return NO;
    }
    if (!self.chooseBtn.selected) {
        [SVProgressHUD showError:@"请选择《九州运车用户注册协议》"];
        return NO;
    }
    return YES;
}
- (NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)unencodedString, NULL, (CFStringRef)@"!*'()%;:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//返回按钮
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
//选择协议
- (void)chooseBtnClick {
    self.chooseBtn.selected = !self.chooseBtn.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
