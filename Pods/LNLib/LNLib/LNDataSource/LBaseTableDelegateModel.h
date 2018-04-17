//
//  LBaseTableDelegateModel.h
//  AlertDemo
//
//  Created by lgh on 2017/9/28.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCellConfigDelegate.h"

//选中某一行的回调，indexPath 行位置 cellModel这个行所要显示的数据
typedef void(^tableViewDidSelectBlock)(NSIndexPath *indexPath,id cellModel);

@interface LBaseTableDelegateModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak)UITableView *weakTableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

//是否使用ios8中的系统自动布局  要通过initWithDataArr 方法传值
@property (nonatomic,assign,readonly)BOOL useAutomaticDimension;

//必须是实现了LCellConfigDelegate协议的cell名称
@property (nonatomic,strong,readonly)NSArray <NSString *> *cellClassNames;

//选中某一行的回调，indexPath 行位置 cellModel这个行所要显示的数据
@property (nonatomic,copy)tableViewDidSelectBlock ln_tableViewDidSelectBlock;

//获取该下标要显示的数据模型 ,不实现，则默认dataArr[indexPath.row]
@property (nonatomic,copy)id(^ln_tableViewRowDataBlock)(NSIndexPath *indexPath);

//加载每一个cell的时候，会在返回cell前回调，外部可以获取这个cell作处理,只能改变UI，不能改变cell对应的数据
@property (nonatomic,copy)void(^ln_tableViewRowCellBlock)(NSIndexPath *indexPath,UITableViewCell<LCellConfigDelegate> *acell);

//获取cell 下标的cell类，cellClassNames里存放的类型，不实现默认取cellClassNames里的第一个
@property (nonatomic,copy)Class(^ln_tableViewRowCellClassIndexBlock)(NSIndexPath *indexPath);

//获取section 下标的cell个数，一般用在组中，默认为dataArr.count
@property (nonatomic,copy)NSInteger(^ln_tableViewRowsNumBlock)(NSInteger section);

//获取有多少个组，默认为1
@property (nonatomic,copy)NSInteger(^ln_tableViewSectionNumBlock)(void);

//nibCellNames 存放实现了LCellConfigDelegate协议的带xib的类名  classCellNames 存放实现了LCellConfigDelegate协议的类名
+ (UITableView *)createTableWithStyle:(UITableViewStyle)style rigistNibCellNames:(NSArray <NSString *> *)nibCellNames rigistClassCellNames:(NSArray <NSString *> *)classCellNames;

/*
 基类实现了@required修饰的代理和点击回调的代理 如果子类还有其它要求，请实现其它代理,或者可以再次实现 ，也可以通过实现相关Block来实现
 */
- (id)initWithDataArr:(NSMutableArray *)dataArr tableView:(UITableView *)tableView cellClassNames:(NSArray <NSString *> *)cellClassNames useAutomaticDimension:(BOOL)useAutomaticDimension cellDidSelectedBlock:(tableViewDidSelectBlock)selectedBlock;

//要实现以上Block  最好在此方法实现,可以不调super ，因为基类里没有实现任何东西
- (void)ln_delegateConfig;





@end
