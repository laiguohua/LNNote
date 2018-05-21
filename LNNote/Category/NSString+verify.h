//
//  NSString+verify.h
//  LNNote
//
//  Created by lgh on 2018/5/18.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (verify)

//手机号验证
+ (BOOL)verifyMobileStr:(NSString *)mobile;

@end
