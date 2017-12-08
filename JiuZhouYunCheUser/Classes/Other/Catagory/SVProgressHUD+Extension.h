//
//  SVProgressHUD+Extension.h
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (Extension)

+ (void)showCircle;

+ (void)showStatus:(NSString*)status;
+ (void)showStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)showError:(NSString*)status;
+ (void)showError:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)showSuccess:(NSString*)status;
+ (void)showSuccess:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

@end
