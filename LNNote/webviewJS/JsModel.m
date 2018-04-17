//
//  JsModel.m
//  LNNote
//
//  Created by lgh on 2018/4/16.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "JsModel.h"

@implementation JsModel


- (void)callMethod{
    NSLog(@"js调了这个方法");
}

- (void)method:(NSString *)paramer1 WithTwoParamer:(NSString *)paramer2{
    NSLog(@"接收到的参数为:%@  %@",paramer1,paramer2);
}

@end
