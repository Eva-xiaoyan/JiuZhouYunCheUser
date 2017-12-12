//
//  UtilityHelper.h
//  JiuZhouLogistics
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 hengshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityHelper : NSObject

//电话号码格式判断方法
+ (BOOL)isValidatePhone:(NSString *)phone;
// 检测密码
+ (BOOL)checkPassword:(NSString *) password;
// 检测昵称
+ (BOOL)checkUserName:(NSString *) username;

//计算带行间距文字的高度
+ (CGFloat)getHeightWithLableSpacing:(CGFloat)spacing Width:(CGFloat)width text:(NSString *)text fontSize:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines;

@end
