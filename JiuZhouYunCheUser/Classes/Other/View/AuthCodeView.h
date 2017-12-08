//
//  AuthCodeView.h
//  HeHeWan
//
//  Created by chenshan on 2016/11/28.
//  Copyright © 2016年 hehewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthCodeView : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组
@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串

- (void)changeAuthCode;

@end
