//
//  UITextField+Extension.m
//  BaisibudejieTest
//
//  Created by 曹晓燕 on 2017/11/1.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "UITextField+Extension.h"

static NSString * const PlaceholderColorKey = @"placeholderLabel.textColor";

@implementation UITextField (Extension)

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 提前设置占位文字, 目的 : 让它提前创建placeholderLabel
    NSString *oldPlaceholder = self.placeholder;
    self.placeholder = @" ";
    self.placeholder = oldPlaceholder;
    
    // 恢复到默认的占位文字颜色
    if (placeholderColor == nil) {
        placeholderColor = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
    }
    
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:PlaceholderColorKey];
}
- (UIColor *)placeholderColor
{
    return [self valueForKeyPath:PlaceholderColorKey];
}

@end
