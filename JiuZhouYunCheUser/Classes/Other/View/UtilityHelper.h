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

+ (BOOL)checkPassword:(NSString *) password;

@end
