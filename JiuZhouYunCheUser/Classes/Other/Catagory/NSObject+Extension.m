//
//  NSObject+Extension.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)
- (BOOL)safeDictWithKey:(NSString *)key
{
    BOOL res = NO;
    
    if ([self isSafeDictionary]) {
        NSDictionary *dictTemp = (NSDictionary *)self;
        if (dictTemp.count && dictTemp[key]) {
            res = YES;
        }
    }
    
    return res;
}

- (BOOL)hasArrayForKey:(NSString *)key
{
    if (![self isSafeDictionary]) return NO;
    
    NSDictionary *dic = (NSDictionary *)self;
    
    if(![dic[key] isSafeObj]) return NO;
    
    if(![dic[key] isKindOfClass:[NSArray class]]) return NO;
    
    return [(NSArray *)dic[key] count] > 0;
}

- (NSURL *)safeUrl
{
    if ([self isSafeString]) {
        return [[NSURL alloc] initWithString:(NSString *)self];
    }
    return nil;
}

/**
 安全对象判断
 */
- (BOOL)isSafeObj
{
    BOOL res = NO;
    
    if (self && ![self isKindOfClass:[NSNull class]] && ![self isEqual:[NSNull null]]) {
        res = YES;
    }
    
    return res;
}

- (BOOL)isSafeArray
{
    BOOL res = NO;
    
    if ([self isSafeObj]) {
        if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]) {
            res = YES;
        }
    }
    
    return res;
}

- (BOOL)isSafeString
{
    BOOL res = NO;
    
    if ([self isSafeObj]) {
        if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSMutableString class]]) {
            NSString *stringTemp = (NSString *)self;
            if ([stringTemp isEqualToString:@"<null>"] || [stringTemp isEqualToString:@"(null)"] || [stringTemp isEqualToString:@"null"] || !stringTemp.length) {
                res = NO;
            } else {
                res = YES;
            }
        }
    }
    
    return res;
}

- (BOOL)isSafeDictionary
{
    BOOL res = NO;
    
    if ([self isSafeObj]) {
        if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]) {
            res = YES;
        }
    }
    
    return res;
}

- (NSString *)safeString
{
    if ([self isSafeString]) {
        return (NSString *)self;
    }
    return nil;
}

- (BOOL)arrayHasData
{
    BOOL res = NO;
    
    if ([self isSafeArray]) {
        NSArray *array = (NSArray *)self;
        if (array.count) {
            res = YES;
        }
    }
    
    return res;
}

- (BOOL)dictionaryHasData
{
    BOOL res = NO;
    
    if ([self isSafeDictionary]) {
        NSDictionary *dictTemp = (NSDictionary *)self;
        if ([[dictTemp allKeys] count]) {
            res = YES;
        }
    }
    
    return res;
}
@end
