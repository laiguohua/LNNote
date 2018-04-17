//
//  LCellConfigDelegate.h
//  AlertDemo
//
//  Created by lgh on 2017/10/9.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LCellConfigDelegate <NSObject>

@required
- (void)ln_configCellWithInfor:(id)model;

@end
