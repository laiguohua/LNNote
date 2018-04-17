//
//  UIResponder+route.m
//  AlertDemo
//
//  Created by lgh on 2018/2/25.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "UIResponder+route.h"

@implementation UIResponder (route)
- (void)routeEventWithSelecterName:(NSString *)selecterName object:(id)object userInfor:(NSDictionary *)userInfor{
    [[self nextResponder] routeEventWithSelecterName:selecterName object:object userInfor:userInfor];
}
@end
