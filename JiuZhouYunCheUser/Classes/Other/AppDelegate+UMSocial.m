//
//  AppDelegate+UMSocial.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "AppDelegate+UMSocial.h"

@implementation AppDelegate (UMSocial)

- (void)setupUMSocial {
    
    [[UMSocialManager defaultManager] openLog:NO];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58451e0da40fa33b48001408"];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1c6339cb3d75699a" appSecret:@"44dc3aaf33be2c5027372e80d179ccf6" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    //第一个 1105486705  zQPL4Fx8qncI4p4n
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106424530"  appSecret:@"b6juYlRjWRGfZ61m" redirectURL:@"http://mobile.umeng.com/social"];
    
}

@end
