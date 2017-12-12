//
//  CHTTPSessionManager.m
//  JiuZhouYunCheUser
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 曹晓燕. All rights reserved.
//

#import "CHTTPSessionManager.h"

@implementation CHTTPSessionManager

-(instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

@end
