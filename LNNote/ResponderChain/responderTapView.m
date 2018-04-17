//
//  responderTapView.m
//  LNNote
//
//  Created by lgh on 2018/4/17.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "responderTapView.h"
#import "UIResponder+route.h"

@implementation responderTapView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGes];
}

//这边这个点击事件将会一直沿着事件响应链传下去，直到被拦截住,而事件传递的过程是无感知的，非常适合在视图层次多的情况下传到底层的情况
//拦截的地方要实现传过去的方法,比如这里的darkViewTapAction:userInfor:
- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self routeEventWithSelecterName:@"darkViewTapAction:userInfor:" object:sender userInfor:@{@"myKey":@"这是从点击视图传过来的参数"}];
}

@end
