//
//  ATExampleController.m
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 04/22/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATExampleController.h"

@interface ATExampleController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;
@property (assign, nonatomic) BOOL addData; ///< 是否加载数据，模拟请求数据使用
@end

@implementation ATExampleController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    self.navigationItem.title = @"ATList";
    self.datas = [NSMutableArray array];
    _addData = YES; // self.addData == NO 则加载请求失败空白页
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColorHex(0xf6f6f6ff);

    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.loadStrategy == ATLoadStrategyManual) {
        self.navigationItem.rightBarButtonItem = \
        [[UIBarButtonItem alloc] initWithTitle:@"手动加载"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(loadDatas)];
    }

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 具体列表配置（可选，如不设置，则取 ATListDefaultConf，ATListDefaultConf 未设置时取 conf）
    @weakify(self);
    [self.tableView updateListConf:^(ATListConf * _Nonnull conf) {
        conf.loadStrategy = self.loadStrategy;
        conf.loadType = self.loadType;
        conf.blankDic = @{@(ATBlankTypeFailure) : blankMake(blankImage(ATBlankTypeFailure), @"绘本数据加载失败", @"10015")};
        conf.length = 20;
    }];

    // 加载数据
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
        _tableView.rowHeight = 44.f;
        _tableView.estimatedRowHeight = 0.f;
        _tableView.estimatedSectionHeaderHeight = 0.f;
        _tableView.estimatedSectionFooterHeight = 0.f;
        _tableView.layer.borderWidth = 3.f;
        _tableView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 34, 0);
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [self.view addSubview:_tableView];
        adjustsScrollViewInsets_NO(_tableView, self);
    }
    return _tableView;
}

#pragma mark - privite

- (void)loadDatas {
    [self.tableView.atList loadNewData];
}

- (void)requestData:(NSDictionary *)parameters
           finished:(void(^)(NSError *error, NSArray *datas))finished {
    NSLog(@"\nparameters:%@", parameters);
    NSMutableArray *models = [NSMutableArray array];
    
    NSRange range = NSMakeRange([parameters[@"offset"] intValue], [parameters[@"number"] intValue]);
    
    void (^block)(void) = ^(void) {
        
        switch (self.loadType) {
            case ATLoadTypeNone:
            case ATLoadTypeNew:{
                for (int i=0; i<range.length; i++) {
                    NSInteger value = range.location + i + 1;
                    [models addObject:@(value)];
                }
            }break;
            case ATLoadTypeMore:
            case ATLoadTypeAll:{
                if (range.location < 2) {
                    for (int i=0; i<range.length; i++) {
                        NSInteger value = range.location + i + 1;
                        [models addObject:@(value)];
                    }
                }else {
                    for (int i=0; i<2; i++) {
                        NSInteger value = range.location + i + 1;
                        [models addObject:@(value)];
                    }
                }
            }break;
            default:
                break;
        }
        
        if (self.addData) {
            if (finished) finished(nil, models);
        }else {
            if (finished) finished(errorMake(nil, 500, @"unknow"), nil);
        }
        self.addData = YES;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColorHex(0xffffffff) : UIColorHex(0x9999991A);
    cell.textLabel.text = [NSString stringWithFormat:@"%d", [self.datas[indexPath.row] intValue]];
    return cell;
}

@end
