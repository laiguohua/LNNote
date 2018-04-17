//
//  LNHttpManager.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "LNHttpManager.h"
#import "MBManager.h"

@interface LNHttpManager()

@property (nonatomic,strong)NSLock *lock;
@property (nonatomic,strong)NSMutableDictionary *signDic;

@end

@implementation LNHttpManager

+ (LNHttpManager *)shareManagerWithBaseUrlStr:(NSString *)baseUrl{
    static LNHttpManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[LNHttpManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl?:@""] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 15.0;
        manager.lock = [[NSLock alloc] init];
        [manager.reachabilityManager startMonitoring];
        
    });
    return manager;
}

+ (LNHttpManager *)shareManager{
    return [self shareManagerWithBaseUrlStr:@""];
}

- (NSMutableDictionary *)signDic{
    if(!_signDic){
        _signDic = [NSMutableDictionary dictionary];
    }
    return _signDic;
}
- (NSURLSessionTask *)post:(NSString *)interfacstring parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self post:interfacstring parameter:parameter hudType:HUD_notShow progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)get:(NSString *)interfacstring parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self get:interfacstring parameter:parameter hudType:HUD_notShow progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)postWithHud:(NSString *)interfacstring parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self post:interfacstring parameter:parameter hudType:HUD_showAndCompleHidden progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)getWithHud:(NSString *)interfacstring parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    return [self get:interfacstring parameter:parameter hudType:HUD_showAndCompleHidden progress:[progress copy] success:[success copy] failure:[failure copy]];
}

- (NSURLSessionTask *)post:(NSString *)interfacstring parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    
    if(![self isNetWorking]){
        if(failure){
            failure(NSURLErrorNotConnectedToInternet,nil,@"暂无网络，请检查网络状况",nil);
        }
        return nil;
    }
    
    NSURLSessionTask *atask = [self POST:interfacstring parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress){
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handHUDwithTask:task message:@"success" code:0];
        if(success){
            success(0,responseObject,@"success",task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handHUDwithTask:task message:@"获取数据失败，请检查网络状况" code:error.code];
        if(failure){
            failure(error.code,nil,@"获取数据失败，请检查网络状况",task);
        }
    }];
    if(ahudType != HUD_notShow){
        [MBManager showHUD];
        [self.lock lock];
        [self.signDic setObject:@(ahudType) forKey:@(atask.taskIdentifier)];
        [self.lock unlock];
    }
    return atask;
}

- (NSURLSessionTask *)get:(NSString *)interfacstring parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure{
    
    if(![self isNetWorking]){
        if(failure){
            failure(NSURLErrorNotConnectedToInternet,nil,@"暂无网络，请检查网络状况",nil);
        }
        return nil;
    }
    
    NSURLSessionTask *atask = [self GET:interfacstring parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress){
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handHUDwithTask:task message:@"success" code:0];
        if(success){
            success(0,responseObject,@"success",task);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handHUDwithTask:task message:@"获取数据失败，请检查网络状况" code:error.code];
        if(failure){
            failure(error.code,nil,@"获取数据失败，请检查网络状况",task);
        }
    }];
    if(ahudType != HUD_notShow){
        [MBManager showHUD];
        [self.lock lock];
        [self.signDic setObject:@(ahudType) forKey:@(atask.taskIdentifier)];
        [self.lock unlock];
    }
    return atask;
}

- (void)handHUDwithTask:(NSURLSessionTask *)task message:(NSString *)message code:(NSInteger)code{
    if(!task) return;
    [self.lock lock];
    HUDTYPE type = [[self.signDic objectForKey:@(task.taskIdentifier)] integerValue];
    [self.signDic removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
    if(type == HUD_notShow) return;
    if(type & HUD_showAndCompleHidden){
        [MBManager hiddenHUD];
    }
    if(type & HUD_showAndCompleShowFailureMessage){
        [MBManager showHUDWithMessage:message];
    }
    if(type & HUD_showAndCompleShowSuccessMessage){
        [MBManager showHUDWithMessage:message];
    }
}

- (void)cancelAllTask{
    for(NSURLSessionTask *task in self.tasks){
        if(task.state == NSURLSessionTaskStateSuspended || task.state == NSURLSessionTaskStateRunning){
            [task cancel];
        }
    }
}

- (BOOL)isNetWorking{
    if(self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){
        return NO;
    }
    return YES;
}


@end
