//
//  UIView+Extension.m
//  BaisibudejieTest
//
//  Created by 曹晓燕 on 2017/11/1.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(CGSize)c_size
{
    return self.frame.size;
}

- (void)setC_size:(CGSize)c_size
{
    CGRect frame = self.frame;
    frame.size = c_size;
    self.frame = frame;
}

- (CGFloat)c_width
{
    return self.frame.size.width;
}

- (CGFloat)c_height
{
    return self.frame.size.height;
}

- (void)setC_width:(CGFloat)c_width
{
    CGRect frame = self.frame;
    frame.size.width = c_width;
    self.frame = frame;
}

- (void)setC_height:(CGFloat)c_height
{
    CGRect frame = self.frame;
    frame.size.height = c_height;
    self.frame = frame;
}

- (CGFloat)c_x
{
    return self.frame.origin.x;
}

- (void)setC_x:(CGFloat)c_x
{
    CGRect frame = self.frame;
    frame.origin.x = c_x;
    self.frame = frame;
}

- (CGFloat)c_y
{
    return self.frame.origin.y;
}

- (void)setC_y:(CGFloat)c_y
{
    CGRect frame = self.frame;
    frame.origin.y = c_y;
    self.frame = frame;
}

- (CGFloat)c_centerX
{
    return self.center.x;
}

- (void)setC_centerX:(CGFloat)c_centerX
{
    CGPoint center = self.center;
    center.x = c_centerX;
    self.center = center;
}

- (CGFloat)c_centerY
{
    return self.center.y;
}

- (void)setC_centerY:(CGFloat)c_centerY
{
    CGPoint center = self.center;
    center.y = c_centerY;
    self.center = center;
}

- (CGFloat)c_right
{
    //    return self.xmg_x + self.xmg_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)c_bottom
{
    //    return self.xmg_y + self.xmg_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setC_right:(CGFloat)c_right
{
    self.c_x = c_right - self.c_width;
}

- (void)setC_bottom:(CGFloat)c_bottom
{
    self.c_y = c_bottom - self.c_height;
}


@end
