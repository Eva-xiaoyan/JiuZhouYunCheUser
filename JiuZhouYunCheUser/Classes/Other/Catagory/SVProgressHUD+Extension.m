//
//  SVProgressHUD+Extension.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "SVProgressHUD+Extension.h"

@implementation SVProgressHUD (Extension)

+ (void)showCircle
{
    [SVProgressHUD show];
    //2秒后，取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showStatus:(NSString*)status
{
    [SVProgressHUD showWithStatus:status];
    
    //2秒后，取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD setDefaultMaskType:maskType];
    
    //2秒后，取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showError:(NSString*)status
{
    [SVProgressHUD showErrorWithStatus:status];
    
    //2秒后，取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showError:(NSString*)status maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD setDefaultMaskType:maskType];
    
    //2秒后，取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showSuccess:(NSString*)status
{
    [SVProgressHUD showSuccessWithStatus:status];
    
    //2秒后，取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showSuccess:(NSString*)status maskType:(SVProgressHUDMaskType)maskType {
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD setDefaultMaskType:maskType];
    
    //2秒后，取消显示HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


@end
