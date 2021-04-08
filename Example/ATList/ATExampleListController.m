//
//  ATExampleListController.m
//  ATList_Example
//
//  Created by ablett on 2019/7/28.
//  Copyright © 2019 ablett. All rights reserved.
//

#import "ATExampleListController.h"
#import "ATExampleController.h"
#import "ATExample.h"

@interface ATExampleListController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;
@end

@implementation ATExampleListController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.navigationItem.title = @"Example";
    self.datas = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorHex(0xf6f6f6ff);
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self addDatas];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - setter, getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 44.f;
        _tableView.estimatedRowHeight = 0.f;
        _tableView.estimatedSectionHeaderHeight = 0.f;
        _tableView.estimatedSectionFooterHeight = 0.f;
        _tableView.layer.borderWidth = 3.f;
        _tableView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 34, 0);
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self.view addSubview:_tableView];
        [_tableView adjustmentScrollInsetNO];
    }
    return _tableView;
}

#pragma mark - privite

- (void)addDatas {
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:@[
                                      ATExampleMake(ATLoadStrategyAuto, ATLoadStyleNone),
                                      ATExampleMake(ATLoadStrategyAuto, ATLoadStyleHeader),
                                      ATExampleMake(ATLoadStrategyAuto, ATLoadStyleFooter),
                                      ATExampleMake(ATLoadStrategyAuto, ATLoadStyleAll),
                                      
                                      ATExampleMake(ATLoadStrategyManual, ATLoadStyleNone),
                                      ATExampleMake(ATLoadStrategyManual, ATLoadStyleHeader),
                                      ATExampleMake(ATLoadStrategyManual, ATLoadStyleFooter),
                                      ATExampleMake(ATLoadStrategyManual, ATLoadStyleAll),
                                      ]];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColorHex(0xffffffff) : UIColorHex(0x9999991A);
    
    ATExample *example = self.datas[indexPath.row];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = UIColorHex(0x333333ff);
    cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ATExample *example = self.datas[indexPath.row];
    ATExampleController *exampleVC = [ATExampleController new];
    exampleVC.loadStrategy = example.loadStrategy;
    exampleVC.loadStyle = example.loadStyle;
    exampleVC.navigationItem.title = example.title;
    [self.navigationController pushViewController:exampleVC animated:YES];
    
}

@end
