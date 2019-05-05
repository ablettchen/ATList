//
//  ATViewController.m
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 04/22/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATViewController.h"
#import "UIScrollView+ATList.h"

@interface ATViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;
@end

@implementation ATViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    
    self.datas = [NSMutableArray array];
    
    //加载数据
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView loadConfig:^(ATConfig * _Nonnull config) {
        
        //config.loadType = ATLoadTypeNew;
        //config.loadStrategy = ATLoadStrategyAuto;
        //config.blankDic = @{@(ATBlankTypeFailure) : blankMake(blankImage(ATBlankTypeFailure), @"绘本数据加载失败", @"40015")};
        //config.length = 15;
        
    } start:^(ATList * _Nonnull list) {
        NSDictionary *parameters = @{@"offset"  : @(list.range.location),
                                     @"number"  : @(list.range.length)};
        __strong __typeof(&*self)strongSelf = weakSelf;
        [weakSelf requestData:parameters finished:^(NSError *error, NSArray *datas) {
            //3. 添加数据
            //当前加载状态为下拉刷新时移除旧数据
            if (list.loadStatus == ATLoadStatusNew) [strongSelf.datas removeAllObjects];
            if (datas && datas.count > 0) [strongSelf.datas addObjectsFromArray:datas];
            //4. 刷新
            [list finish:error];
        }];

    }];

    /** 若 config.loadStrategy = ATLoadStrategyManual，则需要手动调用 [self.tableView.at_list loadNew];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.at_list loadNew];
    });
     */
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
                NSInteger value = range.location*range.length+i+1;
                [models addObject:@(value)];
            }
            if (finished) finished(nil, models);
            //if (finished) finished(errorMake(nil, 500, @"unknow"), nil);
            return;
        }else {
            for (int i=0; i<2; i++) {
                NSInteger value = range.location*range.length+i+1;
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
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", [self.datas[indexPath.row] intValue]];
    return cell;
}

@end
