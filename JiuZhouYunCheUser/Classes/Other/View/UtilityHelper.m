//
//  UtilityHelper.m
//  JiuZhouLogistics
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 hengshi. All rights reserved.
//

#import "UtilityHelper.h"

@implementation UtilityHelper

//电话号码格式判断方法
+ (BOOL)isValidatePhone:(NSString *)phone{
    if (phone != nil && phone.length == 11) {
        return YES;
    }
    return NO;
}

// 检测密码
+ (BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"[a-zA-Z0-9]{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    
    return isMatch;
}



@end
