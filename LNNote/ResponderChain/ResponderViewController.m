//
//  ResponderViewController.m
//  LNNote
//
//  Created by lgh on 2018/4/17.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "ResponderViewController.h"
#import "UIResponder+route.h"
#import "NSObject+performSelecter.h"

@interface ResponderViewController ()

@end

@implementation ResponderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"响应链传值";
    
}

//在这里把响应链上传递的事件给拦下来，不再继续往下传，这里处理掉
- (void)routeEventWithSelecterName:(NSString *)selecterName object:(id)object userInfor:(NSDictionary *)userInfor{
    //把拦截下来的方法作处理之后再转发出去
    SEL aselecter = NSSelectorFromString(selecterName);
    if(!aselecter) return;
    NSMutableArray *muArr = [NSMutableArray array];
    if(object) [muArr addObject:object];
    if(userInfor) [muArr addObject:userInfor];
    //执行方法签名转发
    [self ln_performSelecter:aselecter arguments:muArr];
}

- (void)darkViewTapAction:(UITapGestureRecognizer *)sender userInfor:(NSDictionary *)dict{
    //适用场景，比如在cell中多层自定义视图时，最上层视图的事件传下来viewController来处理
    NSLog(@"这里就是从黑色视图的点击手势传下来的事件处理，整个过程，不需要在每个父视图写block等一个一个传，这就是利用了响应链的方法来传值，中间父视图无需作任何变化即可传下来");
    NSLog(@"sender:%@  \n  userInfor:%@",sender,dict);
}



@end
