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

//计算带行间距文字的高度
+ (CGFloat)getHeightWithLableSpacing:(CGFloat)spacing Width:(CGFloat)width text:(NSString *)text fontSize:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines
{
    NSMutableParagraphStyle * newParagraph = [[NSMutableParagraphStyle alloc] init];
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName,newParagraph,NSParagraphStyleAttributeName,nil];
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(width,fontSize*3) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:attributeDic context:nil].size;
    if (newSize.height > fontSize*1.5) {
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
        NSMutableAttributedString *newAttText = [[NSMutableAttributedString alloc] initWithString:SFSTR(text)];
        [newParagraph setLineSpacing:spacing];
        [newAttText addAttribute:NSParagraphStyleAttributeName value:newParagraph range:NSMakeRange(0, [SFSTR(text) length])];
        newLabel.attributedText = newAttText;
        newLabel.font = [UIFont systemFontOfSize:fontSize];
        newLabel.numberOfLines = numberOfLines;
        [newLabel sizeToFit];
        newSize = newLabel.frame.size;
    }
    
    return newSize.height;
}



@end
