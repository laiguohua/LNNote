//
//  WebViewController.m
//  LNNote
//
//  Created by lgh on 2018/4/16.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "wkwebViewController.h"
#import "JsModel.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (nonatomic,strong)JSContext *context;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"webView";
    self.webView.delegate = self;
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"webViewHtmlForios" ofType:@"html"];
    NSURL *localUrl = [[NSURL alloc] initFileURLWithPath:htmlPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:localUrl]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (IBAction)ocCallJsOne:(UIButton *)sender {
    
    if(self.context){
        //oc直接调起js里的方法
        [self.context evaluateScript:@"ocCallJs('lance','123456')"];
    }
}
- (IBAction)ocCallJsTwo:(UIButton *)sender {
    
    if(self.context){
        //通过 JSContext 调用JS 方法，执行
        JSValue *JSfunc =self.context[@"ocCallJs"];
        [JSfunc callWithArguments:@[@"lance",@"123456"]];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //以下这种是直接注册js方法，不注入模型，这种方法适用于js端没有模型的，直接调方法时使用
    self.context[@"clikOne"] = ^(NSString *paramer){
        NSLog(@"点击了单个参数的方法，参数为：%@",paramer);
    };
    self.context[@"clikMore"] = ^(NSString *paramer1,NSString *paramer2){
        NSLog(@"点击了多个参数的方法，参数1为：%@ 参数2为：%@",paramer1,paramer2);
    };
    __weak __typeof(self)weakSelf = self;
    self.context[@"jumpToWkWebview"] = ^{
        __strong __typeof(self)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            wkwebViewController *wkwebVC = [[wkwebViewController alloc] initWithNibName:@"wkwebViewController" bundle:nil];
            [strongSelf.navigationController pushViewController:wkwebVC animated:YES];
        });

    };
    //这是以模型注入的方式，注意，如果上面没有对你的方法已经在监听，则模型里的方法就不会再跑，例如clikMore方法，上面已经在监听这个方法了，但模型注入的方法也在clikMore里面调用，这时候如果上面监听了，模型里的方法不会走
    JsModel *model = [JsModel new];
    self.context[@"object"] = model;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
