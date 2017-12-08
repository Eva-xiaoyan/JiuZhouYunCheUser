//
//  JZUserBasicInfo.h
//  JiuZhouLogistics
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 hengshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZUserBasicInfo : NSObject

@property(nonatomic,strong)NSString * user_pwd;//密码
@property(nonatomic,strong)NSString * user_phone;//手机号

+(instancetype)sharedUserBasicInfo;

//+ (BOOL)isLogin;
//+ (void)login;
+ (void)logout;

//保存登录信息
+ (void)saveLoginUserName:(NSString *)phoneNum password:(NSString *)password;
//获取登录信息
+ (NSDictionary *)getLoginParams;

@end
