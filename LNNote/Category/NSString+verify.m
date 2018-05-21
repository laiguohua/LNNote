//
//  NSString+verify.m
//  LNNote
//
//  Created by lgh on 2018/5/18.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "NSString+verify.h"

@implementation NSString (verify)

+ (BOOL)verifyMobileStr:(NSString *)mobile{
    
    /**
     手机号码 13[0-9],14[5|7|9],15[0-3],15[5-9],17[0|1|3|5|6|8],18[0-9]
     移动：134[0-8],13[5-9],147,15[0-2],15[7-9],178,18[2-4],18[7-8]
     联通：13[0-2],145,15[5-6],17[5-6],18[5-6]
     电信：133,1349,149,153,173,177,180,181,189
     虚拟运营商: 170[0-2]电信  170[3|5|6]移动 170[4|7|8|9],171 联通
     上网卡又称数据卡，14号段为上网卡专属号段，中国联通上网卡号段为145，中国移动上网卡号段为147，中国电信上网卡号段为149
     */
    
    /*
     移动号段有：134、135、136、137、138、139、147、150、151、152、157、158、159、178、182、183、184、187、188。
     联通号段有130、131、132、155、156、185、186、145、176。
     
     电信号段有133、153、177、180、181、189。
     */
    NSString * MOBIL = @"^1(3[0-9]|4[579]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if ([regextestmobile evaluateWithObject:mobile]) {
        return YES;
    }
    return NO;
}
@end
