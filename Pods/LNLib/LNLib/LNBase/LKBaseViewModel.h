//
//  LKBaseViewModel.h
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/12.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <MJExtension/MJExtension.h>

#import "LNHttpConfig.h"

#import "MBManager.h"


//网络请求结果的回调,外部关心这个结果即可，或者子类对这个回调再次封装
typedef void(^requestResultBlock)(BOOL success,NSInteger apiFlag,NSInteger code ,id data ,id orginData,NSString *message);

@interface LKBaseViewModel : NSObject

//数据源
@property (nonatomic,strong)NSMutableArray *dataSoure;

//最后发起请求的配置
@property (nonatomic,strong,readonly)LNHttpConfig *lastHttpConfig;

//请求回调
@property (nonatomic,copy)requestResultBlock resultBlock;

//初始化
- (void)lk_initialize;

//实例化一个基础的请求配置
- (LNHttpConfig *)lk_defaultHttpConfigWithApi:(NSString *)apiStr hudType:(HUDTYPE)hudType;

//开启一个请求,对于开启一个接口，关注的应该是这个请求的配置，中间请求过程和结果处理无需关心，因为配置已经决定了请求和结果处理
- (RACCommand *)startHttpWithRequestConfig:(LNHttpConfig *)model;

//重新请求和最后一次发起请求一样的请求
- (RACCommand *)reStartHttp;

//统一处理错误信息
- (void)handleErrmsg:(NSString *)errmsg errorCodeNum:(NSNumber *)errorCodeNum httpConfig:(LNHttpConfig *)config subscriber:(id<RACSubscriber>)subscriber;

//检测数据的返回类型是否符合，不符合的话内部会作错误处理发送,外部只要关心为YES的情况
- (BOOL)checkDataWithClass:(Class)aclass data:(id)data  httpConfig:(LNHttpConfig *)config subscriber:(id<RACSubscriber>)subscriber;

@end
