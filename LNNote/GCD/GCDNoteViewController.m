//
//  GCDNoteViewController.m
//  LNNote
//
//  Created by lgh on 2018/4/17.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "GCDNoteViewController.h"

uint64_t dispatch_benchmark(size_t count, void (^block)(void));

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

@interface GCDNoteViewController ()

@property (nonatomic,strong)dispatch_source_t source;

@end

@implementation GCDNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"GCD相关";
}

- (IBAction)cancelSource:(UIButton *)sender{
    if(!self.source) return;
    dispatch_source_cancel(self.source);
    self.source = nil;
}

- (IBAction)sendSource:(UIButton *)sender{
    //    dispatch_source_merge_data(self.source, 1);
    for(int i=1;i<4;i++){
        //不可以传0或负数
        if(self.source){
            dispatch_source_merge_data(self.source, i);
        }
        
    }
}

//死锁测试
- (IBAction)deadlockTest:(UIButton *)sender{
    //这种情况不会死锁,疑问：在同步block里面打印出来的线程是main，主线程，但并不会死锁，不解
    /*
     原因：队列和线程的关系，一个线程可能有多个队列，同步的，不会创建新的线程，在当前线程顺序执行，并行同步队列，不会创建新的线程而且会是顺序执行相当于串行同步队列,并行有可能会创建新的线程
     所以，因为它是同步的，不会创建新的线程，所以block里面还是当前线程，main,但因为它们是在不同的队列中，所以不会死锁，通俗地讲，线程死锁，似乎可以理解为队列死锁,关心的是队列queue之间的锁问题
     */
    //    dispatch_queue_t queue = dispatch_queue_create("com.lance.test", DISPATCH_QUEUE_SERIAL);
    //    dispatch_sync(queue, ^{
    //        NSLog(@"在串行列队中同步执行");
    //        NSLog(@"%@",[NSThread currentThread]);
    //    });
    //    NSLog(@"执行完了");
    //    NSLog(@"===%@",[NSThread currentThread]);
    
    
    
    //以下情况下会死锁
    /*
     原因：NSLog(@"开始"); 是在主线程中执行的，进入dispatch_sync后，因为它是同步的，所以这里要返回，也就是里面的block完成之后才能继续回来执行NSLog(@"执行完了");  因为block是在dispatch_get_main_queue()主线程中执行，所以它需要等待主线程的任务完成之后才能执行block里的内容，而这时候，在外部的主线程又在等待dispatch_sync里的block完成才能继续执行，所以两个互相等待，死锁
     */
    //    NSLog(@"开始");
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        NSLog(@"在主列队中同步执行");
    //    });
    //    NSLog(@"执行完了");
    
    //只要是异步，会创建新的线程,无论队列是同步队列还是并行队列
    /*
     
     */
    dispatch_queue_t queue = dispatch_queue_create("com.lance.test", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t queue = dispatch_queue_create("com.lance.test", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"异步执行");
        NSLog(@"%@",[NSThread currentThread]);
    });
    NSLog(@"执行完毕");
}
//事件源测试
- (IBAction)dispatch_sourceTest:(UIButton *)sender{
    if(self.source) return;
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue);//DISPATCH_SOURCE_TYPE_DATA_OR//DISPATCH_SOURCE_TYPE_DATA_ADD
    __weak __typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(self.source, ^{
        __strong __typeof(self)strongSelf = weakSelf;
        NSLog(@"收到了一个事件");
        //这个数值为，相加的结果，如果发送间隔很小，则会累加，比如第一次发送1  第二次2 则结果为1+2 = 3,如果间隔不是很小，则为发送的数据，如发送1就是1 ，发送2就是2 ，不会累加
        NSLog(@"监听函数：%lu",dispatch_source_get_data(strongSelf.source));
    });
    dispatch_resume(self.source);
    
    
    
}
//循环测试
- (IBAction)dispatch_applyTest:(UIButton *)sender{
    //    TICK;
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    //它是同步的
    //    dispatch_apply(10, queue, ^(size_t index) {
    //        NSLog(@"index is  %zu thead is %@",index,[NSThread currentThread]);
    //    });
    //    NSLog(@"我已经执行完了");//Time: 0.001356
    //    TOCK;
    
    
    //    TICK;
    //    for(int i=0;i<10;i++){
    //        NSLog(@"index is  %d thead is %@",i,[NSThread currentThread]);
    //    }
    //    NSLog(@"我已经执行完了");
    //    NSLog(@"我已经执行完了");//Time: 0.003039
    //    TOCK;
    
    //    TICK;
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_async(queue, ^{
    //        //它是同步的
    //        dispatch_apply(10, queue, ^(size_t index) {
    //            NSLog(@"index is  %zu thead is %@",index,[NSThread currentThread]);
    //        });
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            NSLog(@"我已经执行完了");//Time: Time: 0.002021
    //            TOCK;
    //        });
    //    });
    
    dispatch_queue_t global = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    
    TICK;
    //在多线程下，访问数组要加锁
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //如果是在串行队列中则不需要
    //    dispatch_queue_t queue = dispatch_queue_create("com.jufun.test", DISPATCH_QUEUE_SERIAL);
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:1000];
    //多线程，要加锁
    NSLock *lock = [[NSLock alloc] init];
    //它是同步的
    dispatch_apply(1000, queue, ^(size_t index) {
        NSLog(@"index is  %zu thead is %@",index,[NSThread currentThread]);
        [lock lock];
        [muArr addObject:@{@"score":[NSString stringWithFormat:@"%d",arc4random() % 100],@"age":[NSString stringWithFormat:@"%d",arc4random() % 50]}];
        [lock unlock];
    });
    NSLog(@"我已经执行完了");//10次 Time: 0.001789  1000次：Time: 0.256533
    TOCK;
    
    //    TICK;
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:1000];
    //    //多线程，要加锁
    //    NSLock *lock = [[NSLock alloc] init];
    //    for(int i=0;i<1000;i++){
    //        dispatch_async(queue, ^{
    //            NSLog(@"index is  %d thead is %@",i,[NSThread currentThread]);
    //            [lock lock];
    //            [muArr addObject:@{@"score":[NSString stringWithFormat:@"%d",arc4random() % 100],@"age":[NSString stringWithFormat:@"%d",arc4random() % 50]}];
    //            [lock unlock];
    //
    //        });
    //    }
    //    dispatch_barrier_async(queue, ^{
    //        NSLog(@"我已经执行完了");//10次 Time: 0.001970 1000 次 Time: 0.285985
    //        TOCK;
    //    });
    
    
    /*从以上测试可以看出，dispatch_apply在循环操作方面速度基本上是最快的,充分发挥了GCD线程管理方面的优势*/
    
}


@end
