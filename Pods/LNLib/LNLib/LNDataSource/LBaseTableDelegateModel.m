//
//  LBaseTableDelegateModel.m
//  AlertDemo
//
//  Created by lgh on 2017/9/28.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "LBaseTableDelegateModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface LBaseTableDelegateModel()

@property (nonatomic,strong,readwrite)NSArray <NSString *> *cellClassNames;

//是否使用ios8中的系统自动布局  默认为NO
@property (nonatomic,assign,readwrite)BOOL useAutomaticDimension;

@property (nonatomic,strong,readwrite)NSMutableDictionary *respondDict;

@end


@implementation LBaseTableDelegateModel

//nibCellNames 存放实现了LCellConfigDelegate协议的带xib的类名  classCellNames 存放实现了LCellConfigDelegate协议的类名
+ (UITableView *)createTableWithStyle:(UITableViewStyle)style rigistNibCellNames:(NSArray <NSString *> *)nibCellNames rigistClassCellNames:(NSArray <NSString *> *)classCellNames{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    for(NSString *className in nibCellNames){
        [tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    }
    for(NSString *className in classCellNames){
        [tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
    return tableView;
}


#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif

- (id)initWithDataArr:(NSMutableArray *)dataArr tableView:(UITableView *)tableView cellClassNames:(NSArray <NSString *> *)cellClassNames useAutomaticDimension:(BOOL)useAutomaticDimension cellDidSelectedBlock:(tableViewDidSelectBlock)selectedBlock{
    self = [super init];
    if(self){
        
        
        self.useAutomaticDimension = useAutomaticDimension;
        self.dataArr = dataArr;
        self.cellClassNames = [cellClassNames mutableCopy];
        self.ln_tableViewDidSelectBlock = [selectedBlock copy];
        self.weakTableView = tableView;
        [self ln_delegateConfig];
        tableView.dataSource = self;
        tableView.delegate = self;
    }
    return self;
}



#pragma mark - tableView 代理 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.ln_tableViewSectionNumBlock){
        return self.ln_tableViewSectionNumBlock();
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.ln_tableViewRowsNumBlock){
        return self.ln_tableViewRowsNumBlock(section);
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    return UITableViewAutomaticDimension;
    if(_useAutomaticDimension) return UITableViewAutomaticDimension;
    
    id cellModel = [self cellModelWithIndexPath:indexPath];
    Class aclass = [self cellClassWithIndexPath:indexPath];
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(aclass) configuration:^(UITableViewCell<LCellConfigDelegate> *cell) {
        [cell ln_configCellWithInfor:cellModel];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Class aclass = [self cellClassWithIndexPath:indexPath];
    UITableViewCell<LCellConfigDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(aclass)];
    [cell ln_configCellWithInfor:[self cellModelWithIndexPath:indexPath]];
    if(self.ln_tableViewRowCellBlock){
        self.ln_tableViewRowCellBlock(indexPath,cell);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.ln_tableViewDidSelectBlock){
        self.ln_tableViewDidSelectBlock(indexPath,[self cellModelWithIndexPath:indexPath]);
    }
}

#pragma mark - method
- (id)cellModelWithIndexPath:(NSIndexPath *)indexPath{
    id cellModel;
    //外部可实现此block 自定义传数据进来
    if(self.ln_tableViewRowDataBlock){
        cellModel = self.ln_tableViewRowDataBlock(indexPath);
    }else{
        cellModel = self.dataArr[indexPath.row];
    }
    return cellModel;
}

- (Class)cellClassWithIndexPath:(NSIndexPath *)indexPath{
    Class cellClass;
    //外部可实现此block 自定义类型传进来
    if(self.ln_tableViewRowCellClassIndexBlock){
        Class aclass = self.ln_tableViewRowCellClassIndexBlock(indexPath);
        if([self.cellClassNames containsObject:NSStringFromClass(aclass)]){
            cellClass = aclass;
        }else{
            NSAssert(NO, @"此类未注册");
        }
    }else{
        cellClass = NSClassFromString([self.cellClassNames firstObject]);
        
    }
    NSAssert(cellClass, @"获取到的cell不能为空");
#if DEBUG
    if(![[self.respondDict valueForKey:NSStringFromClass(cellClass)] boolValue]){
        BOOL flag = [cellClass instancesRespondToSelector:@selector(ln_configCellWithInfor:)];
        [self.respondDict setValue:@(flag) forKey:NSStringFromClass(cellClass)];
        if(!flag){
            NSString *errorMessage = [NSString stringWithFormat:@"%@ %@",NSStringFromClass(cellClass),@"必须实现LCellConfigDelegate协议"];
            NSAssert(NO, errorMessage);
        }
    }
#endif
    return cellClass;
}


- (void)ln_delegateConfig{
    
}

- (NSMutableDictionary *)respondDict{
    if(!_respondDict){
        _respondDict = [NSMutableDictionary dictionary];
    }
    return _respondDict;
}




@end
