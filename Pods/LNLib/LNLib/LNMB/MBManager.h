//
//  MBManager.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNMBProgressHUD.h"
#import <Toast/UIView+Toast.h>

@interface MBManager : NSObject

+ (LNMBProgressHUD *)showHUD;
+ (LNMBProgressHUD *)showHUDMessage:(NSString *)message;
+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message;
+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block;
+ (LNMBProgressHUD *)showHUDInfor:(NSString *)infor;
+ (LNMBProgressHUD *)showHUDinview:(UIView *)aview  animated:(BOOL)animated comple:(MBProgressHUDCompletionBlock)block;

+ (void)hiddenHUD;
+ (void)hiddenHUDinview:(UIView *)aview;

+ (LNMBProgressHUD *)findLNMBProgressHUDinview:(UIView *)aview;

#pragma mark - 采用Toast的方式
+ (void)lk_hudSetting;
+ (void)lk_showMessage:(NSString *)message;
+ (void)lk_showMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block;

@end
