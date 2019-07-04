//
//  ATViewController.m
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 04/22/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATViewController.h"
#import <UIScrollView+ATList.h>
#import <UIScrollView+ATBlank.h>
#import <ATCategories/ATCategories.h>
#import <Masonry/Masonry.h>

@interface ATViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;
@end

@implementation ATViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.navigationItem.title = @"ATList";
    self.datas = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 可选，如不设置，取 ATListDefaultConf().conf
    @weakify(self);
    [self.tableView updateListConf:^(ATListConf * _Nonnull conf) {
        conf.loadType = ATLoadTypeAll;
        conf.loadStrategy = ATLoadStrategyAuto;
        conf.blankDic = @{@(ATBlankTypeFailure) : blankMake(blankImage(ATBlankTypeFailure), @"绘本数据加载失败", @"10015")};
        conf.length = 20;
    }];

    // 加载列表数据
    [self.tableView loadListData:^(ATList * _Nonnull list) {
        NSDictionary *parameters = @{@"offset"  : @(list.range.location),
                                     @"number"  : @(list.range.length)};
        @strongify(self);
        [self requestData:parameters finished:^(NSError *error, NSArray *datas) {
            if (list.loadStatus == ATLoadStatusNew) [self.datas removeAllObjects];
            if (datas && datas.count > 0) [self.datas addObjectsFromArray:datas];
            [list finish:error];
        }];
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 若 config.loadStrategy = ATLoadStrategyManual，则需要手动调用 [self.tableView.at_list loadNew];
        //[self.tableView.atList loadNewData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _tableView.estimatedRowHeight = 0.f;
        _tableView.estimatedSectionHeaderHeight = 0.f;
        _tableView.estimatedSectionFooterHeight = 0.f;
        _tableView.layer.borderWidth = 3.f;
        _tableView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 34, 0);
        [self.view addSubview:_tableView];
        adjustsScrollViewInsets_NO(_tableView, self);
    }
    return _tableView;
}

#pragma mark - privite

/** 模拟请求数据 */
- (void)requestData:(NSDictionary *)parameters
           finished:(void(^)(NSError *error, NSArray *datas))finished {
    NSLog(@"\nparameters:%@", parameters);
    NSMutableArray *models = [NSMutableArray array];
    NSRange range = NSMakeRange([parameters[@"offset"] intValue], [parameters[@"number"] intValue]);
    
    void (^block)(void) = ^(void) {
        
        if (range.location < 2) {
            for (int i=0; i<range.length; i++) {
                NSInteger value = range.location + i + 1;
                [models addObject:@(value)];
            }
            if (finished) finished(nil, models);
            //if (finished) finished(errorMake(nil, 500, @"unknow"), nil);
            return;
        }else {
            for (int i=0; i<2; i++) {
                NSInteger value = range.location + i + 1;
                [models addObject:@(value)];
            }
            if (finished) finished(nil, models);
            //if (finished) finished(errorMake(nil, 500, @"unknow"), nil);
            return;
        }
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

NS_INLINE NSError *errorMake(NSString *domain, NSInteger code, NSString *description) {
    return [NSError errorWithDomain:domain?:@""
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey : description?:@""}];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell"];
    if (!cell) {
        cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [UIView new];
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(cell);
            make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        }];
        
        line.backgroundColor = ((indexPath.row % 2) == 0) ? \
        [[UIColor blackColor] colorWithAlphaComponent:0.3] : \
        [[UIColor redColor] colorWithAlphaComponent:0.3];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", [self.datas[indexPath.row] intValue]];
    
    return cell;
}

@end
