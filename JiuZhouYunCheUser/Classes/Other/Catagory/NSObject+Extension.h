//
//  NSObject+Extension.h
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

- (BOOL)safeDictWithKey:(NSString *)key;
- (BOOL)hasArrayForKey:(NSString *)key;

- (NSURL *)safeUrl;

/**
 安全对象判断
 */
- (BOOL)isSafeObj;
- (BOOL)isSafeArray;
- (BOOL)isSafeString;
- (BOOL)isSafeDictionary;

- (NSString *)safeString;

- (BOOL)arrayHasData;
- (BOOL)dictionaryHasData;

@end
