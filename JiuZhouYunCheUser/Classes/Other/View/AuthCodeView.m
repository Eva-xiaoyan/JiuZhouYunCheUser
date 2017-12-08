//
//  AuthCodeView.m
//  HeHeWan
//
//  Created by chenshan on 2016/11/28.
//  Copyright © 2016年 hehewan. All rights reserved.
//  认证

#import "AuthCodeView.h"

#define kRandomColor  [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1.0];
#define kLineCount 6
#define kLineWidth 1.0
#define kCharCount 4
#define kFontSize [UIFont systemFontOfSize:arc4random() % 5 + 15]

@implementation AuthCodeView

- (instancetype)init {
    if(self == [super init]) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor colorWithHexString:@"e6edff"];
        
        [self getAuthcode];//获得随机验证码
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor colorWithHexString:@"e6edff"];
        
        [self getAuthcode];//获得随机验证码
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
//        self.backgroundColor = [UIColor colorWithHexString:@"e6edff"];
        
        [self getAuthcode];//获得随机验证码
    }
    return self;
}

#pragma mark 获得随机验证码
- (void)getAuthcode {

    _dataArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    
    _authCodeStr = [[NSMutableString alloc] initWithCapacity:kCharCount];
  
    for (int i = 0; i < kCharCount; i++) {
        NSInteger index = arc4random() % (_dataArray.count - 1);
        NSString *tempStr = [_dataArray objectAtIndex:index];
        _authCodeStr = (NSMutableString *)[_authCodeStr stringByAppendingString:tempStr];
    }
}

#pragma mark 点击界面切换验证码
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self getAuthcode];
    
    [self setNeedsDisplay];
}
//改变验证码
- (void)changeAuthCode {
    [self getAuthcode];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
   
//    self.backgroundColor = [UIColor colorWithHexString:@"e6edff"];
   
    NSString *text = [NSString stringWithFormat:@"%@",_authCodeStr];
    
    CGSize cSize = [@"A" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
//    int width = rect.size.width / text.length - cSize.width;
//    int height = rect.size.height - cSize.height;
    
    CGPoint point;
    
    float pX,pY;
    pY = 5;
    for ( int i = 0; i < text.length; i++) {
        pX = 5 + cSize.width*i + 5*i;
        //pX = arc4random() % width + rect.size.width/text.length * i;
        //pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        
//        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"TrebuchetMS-Bold" size:15],
//            NSForegroundColorAttributeName:[UIColor colorWithHexString:@"e19853"]}];
    }
}

@end
