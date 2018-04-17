//
//  NSObject+parser.h
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/14.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNParserMarker.h"

@interface NSObject (parser)

//解析数据
- (id)ln_parseMake:(void(^)(LNParserMarker *make))block;

@end
