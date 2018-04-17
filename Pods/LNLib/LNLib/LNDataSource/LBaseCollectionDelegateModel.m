//
//  LBaseCollectionDelegateModel.m
//  AlertDemo
//
//  Created by lgh on 2017/9/30.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "LBaseCollectionDelegateModel.h"

@interface LBaseCollectionDelegateModel()

@property (nonatomic,strong,readwrite)NSArray <NSString *> *cellClassNames;

@property (nonatomic,strong,readwrite)NSMutableDictionary *respondDict;


@end

@implementation LBaseCollectionDelegateModel


//NSArray 存放实现了LCellConfigDelegate的带xib类名  classCellNames 存放实现了LCellConfigDelegate的类名
+ (UICollectionView *)createCollectionViewWithLayout:(UICollectionViewLayout *)layout rigistNibCellNames:(NSArray <NSString *> *)nibCellNames rigistClassCellNames:(NSArray <NSString *> *)classCellNames{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    for(NSString *className in nibCellNames){
        [collectionView registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:className];
    }
    for(NSString *className in classCellNames){
        [collectionView registerClass:NSClassFromString(className) forCellWithReuseIdentifier:className];
    }
    return collectionView;
}

#if DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif

- (id)initWithDataArr:(NSMutableArray *)dataArr collectionView:(UICollectionView *)collectionView cellClassNames:(NSArray <NSString *> *)cellClassNames cellDidSelectedBlock:(collectionViewDidSelectBlock)selectedBlock{
    self = [super init];
    if(self){
        self.dataArr = dataArr;
        self.cellClassNames = [cellClassNames mutableCopy];
        self.weakCollectionView = collectionView;
        self.ln_collectionViewDidSelectBlock = [selectedBlock copy];
        [self ln_delegateConfig];
        collectionView.dataSource = self;
        collectionView.delegate = self;
    }
    return self;
}



#pragma mark - tableView 代理

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(self.ln_collectionViewSectionNumBlock){
        self.ln_collectionViewSectionNumBlock();
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.ln_collectionViewRowsNumBlock){
        return self.ln_collectionViewRowsNumBlock(section);
    }
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Class aclass = [self cellClassWithIndexPath:indexPath];
    UICollectionViewCell<LCellConfigDelegate> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(aclass) forIndexPath:indexPath];
    [cell ln_configCellWithInfor:[self cellModelWithIndexPath:indexPath]];
    if(self.ln_collectionViewRowCellBlock){
        self.ln_collectionViewRowCellBlock(indexPath,cell);
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.ln_collectionViewDidSelectBlock){
        self.ln_collectionViewDidSelectBlock(indexPath,[self cellModelWithIndexPath:indexPath]);
    }
    
}

#pragma mark - method
- (id)cellModelWithIndexPath:(NSIndexPath *)indexPath{
    id cellModel;
    //外部可实现此block 自定义传数据进来
    if(self.ln_collectionViewRowDataBlock){
        cellModel = self.ln_collectionViewRowDataBlock(indexPath);
    }else{
        cellModel = self.dataArr[indexPath.row];
    }
    return cellModel;
}

- (Class)cellClassWithIndexPath:(NSIndexPath *)indexPath{
    Class cellClass;
    //外部可实现此block 自定义类型传进来
    if(self.ln_collectionViewRowCellClassIndexBlock){
        Class aclass = self.ln_collectionViewRowCellClassIndexBlock(indexPath);
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

//如果useAutomaticDimension 为YES 采用系统自动布局，则不需要执行以下两个代理 否则通过执行代理返回相应的高度
//- (BOOL)respondsToSelector:(SEL)aSelector{
//    if(aSelector == NSSelectorFromString(@"tableView:heightForRowAtIndexPath:")){
//        return !self.useAutomaticDimension;
//    }else if(aSelector == NSSelectorFromString(@"tableView:estimatedHeightForRowAtIndexPath:")){
//        return !self.useAutomaticDimension;
//    }
//    return [super respondsToSelector:aSelector];
//}

- (void)ln_delegateConfig{
    
}

- (NSMutableDictionary *)respondDict{
    if(!_respondDict){
        _respondDict = [NSMutableDictionary dictionary];
    }
    return _respondDict;
}




@end
