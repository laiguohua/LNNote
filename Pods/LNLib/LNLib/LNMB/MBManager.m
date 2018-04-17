//
//  MBManager.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "MBManager.h"
#import "NSString+LKCalauteSize.h"

static const NSTimeInterval delayTime = 3.0;

@interface MBManager()

@end

@implementation MBManager

+ (LNMBProgressHUD *)showHUD{
    return [self showHUDMessage:nil];
}
+ (LNMBProgressHUD *)showHUDMessage:(NSString *)message{
    [self mostTopViewWithIsshow:YES comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeIndeterminate;
        if(message){
            hud.label.text = message;
        }
        hud.detailsLabel.text = nil;
    }];
    return nil;
}
+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
    return nil;
}

+ (LNMBProgressHUD *)showHUDWithMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:[block copy]];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont systemFontOfSize:14];
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
    return nil;
}

+ (LNMBProgressHUD *)showHUDInfor:(NSString *)infor{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = infor;
        hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    }];
    return nil;
}

+ (LNMBProgressHUD *)showHUDinview:(UIView *)aview animated:(BOOL)animated comple:(MBProgressHUDCompletionBlock)block{
    LNMBProgressHUD *hud = [self findLNMBProgressHUDinview:aview];
    if(![aview isKindOfClass:[UIWindow class]]){
        if(!aview.window){
            return nil;
        }
    }
    if(!hud){
        hud = [LNMBProgressHUD showHUDAddedTo:aview animated:animated];
        hud.square = NO;
    }
    hud.completionBlock = [block copy];
    
    return hud;
}

+ (void)hiddenHUD{
//    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
//        [self hiddenHUDinview:aview];
//    }];
    [self mostTopForHiidenComple:^(UIView *aview) {
        [self hiddenHUDinview:aview];
    }];
    
}
+ (void)hiddenHUDinview:(UIView *)aview{
    LNMBProgressHUD *hud = [self findLNMBProgressHUDinview:aview];
    if(hud){
        [hud hideAnimated:YES];
    }
}

+ (LNMBProgressHUD *)findLNMBProgressHUDinview:(UIView *)aview{
    NSAssert(aview, @"aview can not be nil");
    LNMBProgressHUD *hud = (LNMBProgressHUD *)[LNMBProgressHUD HUDForView:aview];
    if(!hud || hud.hasFinished){
        return nil;
    }
    hud.graceTime = .2;
    hud.minShowTime = .2;
    [aview bringSubviewToFront:hud];
    return hud;
}

+ (void)mostTopViewWithIsshow:(BOOL)isShow comple:( void(^)(UIView *))block{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSAssert(window, @"window can not be nil");
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *rootController = window.rootViewController;
    if(!rootController){
        if(block){
            block(window);
        }
        
        return;
    }
    UIViewController *topViewController = [self getCurrentControllerWithController:rootController];
    if(block){
        block(topViewController.view);
    }
    /*
    NSTimeInterval adelayTime = .3;
    //延迟，避免在viewDidLoad中加载，这时候控制器还没有present或者push 过来
    NSTimer *atimer = [NSTimer scheduledTimerWithTimeInterval:adelayTime target:self selector:@selector(delayFindController:) userInfo:@{@"acontroller":rootController,@"ablock":[block copy]} repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:atimer forMode:NSRunLoopCommonModes];
     */
    
    
}

+ (void)mostTopForHiidenComple:( void(^)(UIView *))block{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSAssert(window, @"window can not be nil");
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *rootController = window.rootViewController;
    if(!rootController){
        if(block){
            block(window);
        }
        
        return;
    }
    UIViewController *topViewController = [self getCurrentControllerWithController:rootController];
    if(block){
        block(topViewController.view);
    }
    
}


+ (void)delayFindController:(NSTimer *)timer{
    NSDictionary *dict = timer.userInfo;
    UIViewController *topViewController = [self getCurrentControllerWithController:dict[@"acontroller"]];
    void (^ablock)(UIView *) = dict[@"ablock"];
    if(ablock){
        ablock(topViewController.view);
    }
}

+ (UIViewController *)getCurrentControllerWithController:(UIViewController *)vc{
    if([vc isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *nav= (UINavigationController *)vc;
        if(nav.presentedViewController){
            return [self getCurrentControllerWithController:nav.presentedViewController];
        }
        return nav.visibleViewController;
        
    }else if([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)vc;
        UIViewController *avc = tab.selectedViewController;
        return [self getCurrentControllerWithController:avc];
    }else if(vc.presentedViewController){
        return [self getCurrentControllerWithController:vc.presentedViewController];
    }
    return vc;
}



#pragma mark - 采用Toast的方式
+ (void)lk_hudSetting{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [[UIColor colorWithRed:13/255.0 green:19/255.0 blue:26/255.0 alpha:1.0] colorWithAlphaComponent:.5];
    style.messageFont = [UIFont systemFontOfSize:16];
    style.cornerRadius = 20;
    style.messageAlignment = NSTextAlignmentCenter;
    [CSToastManager setSharedStyle:style];
    [CSToastManager setDefaultDuration:2.0];
    [CSToastManager setDefaultPosition:CSToastPositionCenter];
}
+ (void)lk_showMessage:(NSString *)message{
    
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        [self lk_setCornerWithMessage:message];
        [aview makeToast:message];
    }];
}

+ (void)lk_showMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        [self lk_setCornerWithMessage:message];
        [aview makeToast:message duration:[CSToastManager defaultDuration] position:[CSToastManager defaultPosition] title:nil image:nil style:[CSToastManager sharedStyle] completion:^(BOOL didTap) {
            if(block){
                block();
            }
        }];
    }];
}

+ (void)lk_setCornerWithMessage:(NSString *)message{
    if(!message || message.length == 0){
        CSToastStyle *style = [CSToastManager sharedStyle];
        style.cornerRadius = 20;
        return;
    }
    CSToastStyle *style = [CSToastManager sharedStyle];
    CGSize asize = CGSizeMake([UIScreen mainScreen].bounds.size.width * style.maxWidthPercentage - style.horizontalPadding * 2, MAXFLOAT);
    asize = [message caluateSize:asize withFont:style.messageFont];
    style.cornerRadius = (asize.height + style.verticalPadding * 2) / 2.0;
}


@end
