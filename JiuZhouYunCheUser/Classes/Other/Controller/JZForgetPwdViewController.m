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

@interface JZForgetPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (nonatomic, strong) CHTTPSessionManager *manager;
@property(nonatomic,strong)NSDictionary *dic;
@property (nonatomic, assign) int countFlag; // 验证码倒计时相关
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JZForgetPwdViewController
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
//获取验证码
- (IBAction)getCodeClick {
    // 取消所有的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    if ([UtilityHelper isValidatePhone:self.phoneTextField.text]) {
        //请求参数
        NSString *str = @"http://m.jiuzhouyunche.com/iosuser/login/send_message_app/";
        //请求参数
        NSDictionary *parameters = @{@"telephone" : _phoneTextField.text};
        [self.manager POST:str parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            }else{
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

//确认
- (IBAction)makeSureClick {
    
    NSString *str = @"http://www.jiuzhouyunche.com/express/index/ios_forgetpass";
    //请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"telephone"] = self.phoneTextField.text;
    parameters[@"password"] = self.pwdTextField.text;
    parameters[@"code"] = self.codeTextField.text;
    
    [self.manager POST:str parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         self.dic = dic;
         
         NSInteger code = 0;
         code = [self.dic[@"code"] integerValue];
         if(code == 1) {
             [SVProgressHUD showSuccess:[self.dic[@"msg"] safeString]];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }else {
             [SVProgressHUD showError:self.dic[@"msg"]];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD showError:@"请求失败"];
     }];
    
    
}
//返回登录页按钮
- (IBAction)loginClick {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
