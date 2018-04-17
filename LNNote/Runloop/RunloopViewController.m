//
//  RunloopViewController.m
//  LNNote
//
//  Created by lgh on 2018/4/17.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "RunloopViewController.h"

@interface RunloopViewController ()

@property (nonatomic,assign)CFRunLoopObserverRef observer;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSInteger totalNum;
@property (nonatomic,assign)NSInteger caluateNum;

@end

@implementation RunloopViewController
- (void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.caluateNum = 0;
    [self createCurrentRunloopObserver];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
}


- (void)timeAction{
    NSLog(@"定时器执行方法");
}

- (void)executeWaitingMethod{
    if(self.caluateNum <= 100){
        self.totalNum += self.caluateNum;
        self.caluateNum ++;
        if(self.caluateNum > 100){
            NSLog(@"计算完毕，结果为:%ld",self.totalNum);
        }else{
            [self executeWaitingMethod];
        }
    }
    
    
}

- (void)createThreadRunloop{
    
}
//添加runloop观察者
- (void)createCurrentRunloopObserver{
    self.observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting | kCFRunLoopExit, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopBeforeWaiting:
            {
                NSLog(@"即将进入休眠");
                //要休眠的时候让它去做计算的事
                [self executeWaitingMethod];
            }
                break;
            case kCFRunLoopExit:
            {
                NSLog(@"即将退出");
            }
                break;
                
            default:
                break;
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observer, kCFRunLoopDefaultMode);
    
    CFRelease(self.observer);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observer, kCFRunLoopDefaultMode);
    self.observer = NULL;
    
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
