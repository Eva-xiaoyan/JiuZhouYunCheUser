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
// 检测昵称
+ (BOOL)checkUserName:(NSString *) username
{
    NSString *pattern = @"[0-9A-Za-z]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:username];
    
    return isMatch;
}

//颜色值
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return CColor(r, g, b);
}


@end
