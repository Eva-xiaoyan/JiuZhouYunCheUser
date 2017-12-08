//
//  JZUserBasicInfo.m
//  JiuZhouLogistics
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 hengshi. All rights reserved.
//

#import "JZUserBasicInfo.h"

@interface JZUserBasicInfo ()

@property (nonatomic, assign) BOOL isLogin;

@end
@implementation JZUserBasicInfo

static JZUserBasicInfo *_sharedUserBasicInfo;
+(instancetype)sharedUserBasicInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUserBasicInfo = [[self alloc]init];
    });
    return _sharedUserBasicInfo;
}
- (instancetype)init {
    if(self == [super init]) {
        //姓名
        _user_phone = [[NSUserDefaults standardUserDefaults] stringForKey:@"JZUserName"];
        //
        _user_pwd = [[NSUserDefaults standardUserDefaults] stringForKey:@"JZUserPassword"];
        
    }
    return self;
}


//退出登录
+ (void)logout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults synchronize];
    
}
//保存登录信息
+ (void)saveLoginUserName:(NSString *)userName password:(NSString *)password {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:@"username"];
    [userDefaults setObject:password forKey:@"password"];
    [userDefaults synchronize];
}
//获取登录信息
+ (NSDictionary *)getLoginParams {
    id params = [[NSUserDefaults standardUserDefaults] objectForKey:@"JZUserLoginParams"];
    if([params isSafeDictionary]) return params;
    
    return nil;
}
@end
