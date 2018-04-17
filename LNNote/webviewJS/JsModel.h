//
//  JsModel.h
//  LNNote
//
//  Created by lgh on 2018/4/16.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

//继承协议，把js里的方法写进来，注意多参数的情况，参数与参数间以大写间隔开来
@protocol OcInteractionJsDelegate <JSExport>
- (void)callMethod;

- (void)method:(NSString *)paramer1 WithTwoParamer:(NSString *)paramer2;

@end

@interface JsModel : NSObject<OcInteractionJsDelegate>


@end
