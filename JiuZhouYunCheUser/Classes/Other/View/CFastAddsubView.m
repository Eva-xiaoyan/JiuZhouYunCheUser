//
//  CFastAddsubView.m
//  JiuZhouYunCheUser
//
//  Created by hengshi on 2017/12/29.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "CFastAddsubView.h"

@implementation CFastAddsubView
//画线  行高为自行设置
+(void)addLineViewRect:(CGFloat)height lineColor:(UIColor *)color SuperView:(UIView *)superView
{
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, superView.c_height - height, superView.c_width, height)];
    [lineV setBackgroundColor:color];
    [superView addSubview:lineV];
}

//画线
+(void)addLineWithRect:(CGRect)rect lineColor:(UIColor *)color SuperView:(UIView *)superView
{
    UIView *lineV = [[UIView alloc]initWithFrame:rect];
    [lineV setBackgroundColor:color];
    [superView addSubview:lineV];
}

#pragma mark - UITextField
- (UITextField *)addTextField:(CGRect)frame placeholder:(NSString *)text font:(float)font superView:(UIView *)superView
{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.font = [UIFont systemFontOfSize:font];
    textField.contentVerticalAlignment = NSTextAlignmentLeft;
    textField.placeholder = text;
    textField.textColor = [UtilityHelper colorWithHexString:@"#888888"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [superView addSubview:textField];
    return textField;
}

//textField  
+ (UITextField *)addTextField:(CGRect)rect font:(float)font placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor keyboardType:(UIKeyboardType)keyboardType borderStyle:(UITextBorderStyle)borderStyle textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.font = [UIFont systemFontOfSize:font];
    textField.textAlignment = textAlignment;
    textField.placeholder = placeholder;
    [textField setPlaceholderColor:placeholderColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = borderStyle;
    textField.keyboardType = keyboardType;
    [superView addSubview:textField];
    return textField;
}

#pragma mark - UILabel
// 添加label 多行  带行间距
+ (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(NSString *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines fontSize:(float)fonSize lineSpacing:(NSInteger)lineSpacing superView:(UIView *)superView
{
    UILabel *label =[[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = [UtilityHelper colorWithHexString:textColor];
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    [label setFont:[UIFont systemFontOfSize:fonSize]];//显示字体
    label.backgroundColor = [UIColor clearColor];
    
    if (![label.text isEqualToString:@""]) {
        //设置行间距
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:SFSTR(text)];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        //设置行距
        [style setLineSpacing:lineSpacing];
        
        //根据给定长度与style设置attStr式样
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [SFSTR(text) length])];
        //Label获取attStr式样
        label.attributedText = attStr;
//        [label setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    //Label自适应大小
    [label sizeToFit];
    [superView addSubview:label];
    return label;
}

// 添加label 单行
+ (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(NSString *)textColor textAlignment:(NSTextAlignment)textAlignment fontSize:(float)fonSize superView:(UIView *)superView
{
    UILabel *label =[[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = [UtilityHelper colorWithHexString:textColor];
    label.textAlignment = textAlignment;
    [label setFont:[UIFont systemFontOfSize:fonSize]];//显示字体
    [superView addSubview:label];
    return label;
}

#pragma mark - button
//带图片button
+ (UIButton *)addButtonWithRect:(CGRect)rect image:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target selector:(SEL)aSelector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//带文字button
+(UIButton *)addbuttonWithRect:(CGRect)rect LabelText:(NSString *)text TextFont:(CGFloat)font NormalTextColor:(UIColor *)normalColor highLightTextColor:(UIColor *)highLightColor disabledColor:(UIColor *)disabledColor SuperView:(UIView *)superView buttonTarget:(id)target Action:(SEL)action
{
    UIButton * button = [self addbuttonWithRect:rect SuperView:superView buttonTarget:target Action:action events:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:font]];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateHighlighted];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highLightColor forState:UIControlStateHighlighted];
    [button setTitleColor:disabledColor forState:UIControlStateDisabled];
    return button;
}
//文字图片button  默认文字居左 NSLineBreakByTruncatingTail
+ (UIButton *)addButtonWithRect:(CGRect)buttonRect NormalImageName:(NSString *)normal andSelectedImageName:(NSString *)selected ButtonTag:(NSInteger)buttonTag superView:(UIView *)superView    titleText:(NSString *)text titleFont:(UIFont *)font TitleNormalColor:(UIColor *)titleNMColor TitleHighLightColor:(UIColor *)titleHLColor buttonTarget:(id)target Action:(SEL)action{
    UIButton * button=  [self addButtonWithRect:buttonRect image:normal highlightedImage:selected target:target selector:action];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment=NSTextAlignmentLeft;
    button.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    return (UIButton *)[superView viewWithTag:buttonTag];
}

//空白button
+ (UIButton *)addbuttonWithRect:(CGRect)rect SuperView:(UIView *)superView buttonTarget:(id)target Action:(SEL)action events:(UIControlEvents)event
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    [button addTarget:target action:action forControlEvents:event];
    [button setExclusiveTouch:YES];
    [superView addSubview:button];
    
    return button;
}

//计算不同字体的宽度
+ (CGSize)getWordRealSizeWithFont:(UIFont *)font WithConstrainedRect:(CGRect )constrainedRect WithStr:(NSString *)string{
    CGSize realSize = CGSizeZero;
    realSize = [string boundingRectWithSize:constrainedRect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return realSize;
}

@end
