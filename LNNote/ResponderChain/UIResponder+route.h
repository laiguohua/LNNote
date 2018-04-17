//
//  UIResponder+route.h
//  AlertDemo
//
//  Created by lgh on 2018/2/25.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (route)

- (void)routeEventWithSelecterName:(NSString *)selecterName object:(id)object userInfor:(NSDictionary *)userInfor;

@end
