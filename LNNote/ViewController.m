//
//  ViewController.m
//  LNNote
//
//  Created by lgh on 2018/4/16.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import <LNLib/LBaseTableDelegateModel.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "NoteCell.h"

@interface ViewController ()

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LBaseTableDelegateModel *delegateModel;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"功能列表";
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setBarTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [[UINavigationBar appearance] setTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadLocalData];
    @weakify(self);
    self.delegateModel = [[LBaseTableDelegateModel alloc] initWithDataArr:self.dataArr tableView:self.tableView cellClassNames:@[@"NoteCell"] useAutomaticDimension:YES cellDidSelectedBlock:^(NSIndexPath *indexPath, id cellModel) {
        @strongify(self);
        [self cellClikWithModel:cellModel];
    }];
}

- (void)loadLocalData{
    [self.dataArr removeAllObjects];
    NSDictionary *dict1 = @{@"type":@1,@"name":@"webjs交互"};
    [self.dataArr addObject:dict1];
}

- (void)cellClikWithModel:(NSDictionary *)dict{
    NSInteger type = [dict[@"type"] integerValue];
    switch (type) {
        case 1:
        {
            WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - lazyload
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [LBaseTableDelegateModel createTableWithStyle:UITableViewStylePlain rigistNibCellNames:nil rigistClassCellNames:@[@"NoteCell"]];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


@end
