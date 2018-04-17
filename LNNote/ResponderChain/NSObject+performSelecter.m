//
//  NSObject+performSelecter.m
//  AlertDemo
//
//  Created by lgh on 2018/2/25.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "NSObject+performSelecter.h"

@implementation NSObject (performSelecter)
- (id)ln_performSelecter:(SEL)aselecter arguments:(NSArray *)arguments{
    //获取签名
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aselecter];
    if(!signature){
        //抛出异常
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[self class],NSStringFromSelector(aselecter)];
        @throw [[NSException alloc] initWithName:@"ifelseboyxx remind:" reason:info userInfo:nil];
        return nil;
    }
     //创建 NSInvocation 对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = aselecter;
    NSInteger argNum = signature.numberOfArguments - 2;
    NSInteger num = MIN(argNum, arguments.count);
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:num];
    for(int i=0;i<num;i++){
        id obj = arguments[i];
        if([obj isEqual:[NSNull null]]){
            obj = nil;
        }
        //设置参数
        [invocation setArgument:&obj atIndex:2+i];
    }
    //方法调用
    [invocation invoke];
    id res = nil;
    if(signature.methodReturnLength != 0){
        //获取返回值
        [invocation getReturnValue:&res];
    }
    return res;
}
@end
