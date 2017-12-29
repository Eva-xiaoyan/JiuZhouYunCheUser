//
//  CFastAddsubView.h
//  JiuZhouYunCheUser
//
//  Created by hengshi on 2017/12/29.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFastAddsubView : NSObject


/// 添加textField 多行  带行间距
+ (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(NSString *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines fontSize:(float)fonSize lineSpacing:(NSInteger)lineSpacing superView:(UIView *)superView;
#pragma mark - UITextField
///textField placeholder keyboardType borderStyle
+ (UITextField *)addTextField:(CGRect)rect font:(float)font placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor keyboardType:(UIKeyboardType)keyboardType borderStyle:(UITextBorderStyle)borderStyle textAlignment:(NSTextAlignment)textAlignment superView:(UIView *)superView;

#pragma mark - UILabel
/// 添加label 单行
+ (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(NSString *)textColor textAlignment:(NSTextAlignment)textAlignment fontSize:(float)fonSize superView:(UIView *)superView;
/// 添加label 多行  带行间距
+ (UILabel *)addLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(NSString *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines fontSize:(float)fonSize lineSpacing:(NSInteger)lineSpacing superView:(UIView *)superView;
#pragma mark - button
/// 带图片的button
+ (UIButton *)addButtonWithRect:(CGRect)rect image:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target selector:(SEL)aSelector;
///带文字button
+ (UIButton *)addbuttonWithRect:(CGRect)rect LabelText:(NSString *)text TextFont:(CGFloat)font NormalTextColor:(UIColor *)normalColor highLightTextColor:(UIColor *)highLightColor  disabledColor:(UIColor *)disabledColor SuperView:(UIView *)superView buttonTarget:(id)target Action:(SEL)action;
/// 空白button
+ (UIButton *)addbuttonWithRect:(CGRect)rect SuperView:(UIView *)superView buttonTarget:(id)target Action:(SEL)action events:(UIControlEvents)event;

///计算不同字体的宽度
+ (CGSize)getWordRealSizeWithFont:(UIFont *)font WithConstrainedRect:(CGRect )constrainedRect WithStr:(NSString *)string;
#pragma mark - UIView
///画线  行高 自行设置
+ (void)addLineViewRect:(CGFloat)height lineColor:(UIColor *)color SuperView:(UIView *)superView;
///画线 自行设置宽、高
+ (void)addLineWithRect:(CGRect)rect lineColor:(UIColor *)color SuperView:(UIView *)superView;
@end
