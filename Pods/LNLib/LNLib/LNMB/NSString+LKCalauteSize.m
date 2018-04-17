//
//  NSString+LKCalauteSize.m
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/26.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "NSString+LKCalauteSize.h"

@implementation NSString (LKCalauteSize)

- (CGSize)caluateSize:(CGSize)asize withFont:(UIFont *)afont{
    // 计算文本的大小
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(asize.width, asize.height) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                       attributes:@{NSFontAttributeName:afont}        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit;
    
}

@end
