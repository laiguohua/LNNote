//
//  LKBaseParseManager.m
//  LaiKeBaoNew
//
//  Created by lgh on 2018/3/20.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "LKBaseParseManager.h"
static LKBaseParseManager *manager = nil;
@implementation LKBaseParseManager

+ (LKBaseParseManager *)shareManager{
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
        manager.codeKey = @"retCode";
        manager.dataKey = @"data";
        manager.errorMessageKey = @"retDesc";
    });
    return manager;
}

@end
