//
//  ATList.m
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 2019/4/22.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATList.h"
#import "ATRefreshHeader.h"
#import "ATRefreshFooter.h"
#import "UIScrollView+ATBlank.h"

@interface ATConfig ()
@end
@implementation ATConfig

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.loadType = ATLoadTypeNew;
    self.loadStrategy = ATLoadStrategyAuto;
    self.length = 0;
    
    return self;
}

@end

@interface ATList ()

@property (strong, readwrite, nonatomic, nonnull) ATConfig *config;
@property (assign, readwrite, nonatomic) enum ATLoadStatus loadStatus;      ///< 加载状态
@property (assign, readwrite, nonatomic) NSRange range;                     ///< 数据范围

@property (strong, nonatomic) NSValue *loadStatusValue;                     ///< 加载状态
@property (strong, nonatomic) NSValue *rangeValue;                          ///< 数据范围

@property (strong, nonatomic) __kindof UIScrollView *listView;              ///< 目标View
@property (strong, nonatomic) ATRefreshHeader *header;                      ///< 刷新头
@property (strong, nonatomic) ATRefreshFooter *footer;                      ///< 刷新尾
@property (assign, nonatomic) enum ATBlankType blankType;                   ///< 空白页类型
@property (strong, nonatomic) ATBlank *blank;                               ///< 空白页
@property (assign, nonatomic) NSInteger lastItemCount;                      ///< 记录上次条数

@property (strong, nonatomic) UIColor *cachedListColor;                     ///< 记录listView的背景色(为了解决自适应的问题，待优化)
@property (strong, nonatomic) UIColor *cachedListSuperColor;                ///< 记录listView.superView的背景色(为了解决自适应的问题，待优化)

@end
@implementation ATList

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.config = [ATConfig new];
    self.loadStatus = ATLoadStatusIdle;
    self.range = NSMakeRange(0, self.config.length);
    self.lastItemCount = 0;
    
    return self;
}

#pragma mark - setter, getter

- (ATRefreshHeader *)header {
    if (!_header) {
        _header = [ATRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
        [_header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [_header setTitle:@"释放更新" forState:MJRefreshStatePulling];
        [_header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        _header.stateLabel.font = [UIFont systemFontOfSize:13];
        _header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        _header.stateLabel.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        _header.lastUpdatedTimeLabel.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        _header.automaticallyChangeAlpha = YES;
        _header.lastUpdatedTimeLabel.hidden = YES;
    }
    return _header;
}

- (ATRefreshFooter *)footer {
    if (!_footer) {
        _footer = [ATRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        _footer.stateLabel.font = [UIFont systemFontOfSize:13];
        _footer.stateLabel.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
    }
    return _footer;
}

- (void)setLoadStatusValue:(NSValue *)loadStatusValue {
    _loadStatusValue = loadStatusValue;
    enum ATLoadStatus loadStatus;
    [loadStatusValue getValue:&loadStatus];
    self.loadStatus = loadStatus;
}

- (void)setRangeValue:(NSValue *)rangeValue {
    _rangeValue = rangeValue;
    NSRange range;
    [rangeValue getValue:&range];
    self.range = range;
}

- (void)setListView:(__kindof UIScrollView *)listView {
    _listView = listView;
    if (!self.cachedListColor) {
        self.cachedListColor = listView.backgroundColor;
    }
    if (!self.cachedListSuperColor) {
        self.cachedListSuperColor = listView.superview.backgroundColor;
    }
}

#pragma mark - privite

- (void)loadMore {
    if (self.loadStatus == ATLoadStatusNew) {return;}

    self.loadStatus = ATLoadStatusMore;
    int loc = ceil((float)self.listView.at_itemsCount/self.config.length)?:1;
    self.range = NSMakeRange(loc, self.config.length);
    
    SEL loadMoreSEL = NSSelectorFromString(@"loadMore");
    AT_SAFE_PERFORM_SELECTOR(self.listView, loadMoreSEL, nil);
}

- (void)reloadData {
    
    if (self.listView.at_itemsCount == 0) {
        self.listView.backgroundColor = [UIColor clearColor];
        self.listView.superview.backgroundColor = [UIColor whiteColor];
    }else {
        if (self.cachedListColor) {
            self.listView.backgroundColor = self.cachedListColor;
            self.listView.superview.backgroundColor = self.cachedListSuperColor;
        }
    }
    
    SEL reloadSEL = NSSelectorFromString(@"reloadData");
    if (!AT_SAFE_PERFORM_SELECTOR(self.listView, reloadSEL, nil)) {
        [self.listView setNeedsDisplay];
    }
}

- (void)setBlankType:(enum ATBlankType)blankType {
    _blankType = blankType;
    if (!self.config.blankDic || self.config.blankDic.count == 0) {
        self.blank = defaultBlank(blankType);
    }else {
        if (self.config.blankDic[@(blankType)]) {
            self.blank = self.config.blankDic[@(blankType)];
        }else {
            self.blank = defaultBlank(blankType);
        }
    }
    
    __weak __typeof(&*self)weakSelf = self;
    self.blank.tapBlock = ^{
        if (!weakSelf.blank.imageAnimating) {
            weakSelf.blank.imageAnimating = YES;
            [weakSelf.listView reloadBlankData];
            [weakSelf loadNew];
        }
    };
    
    [self.listView setBlank:self.blank];
    [self.listView reloadBlankData];
}

#pragma mark - public

- (void)setConfig:(nullable ATConfig *)config; {
    if (config == nil) {
        config = [ATConfig new];
    }
    _config = config;
    switch (self.config.loadType) {
        case ATLoadTypeNone:{
            self.listView.mj_header = nil;
            break;
        }
        case ATLoadTypeNew:
        case ATLoadTypeMore:
        case ATLoadTypeAll:{
            if (config.loadStrategy == ATLoadStrategyAuto) {
                self.listView.mj_header = self.header;
            }
            break;
        }
    }
}

- (void)finish:(nullable NSError *)error {
    if (self.blank.isImageAnimating) {
        self.blank.imageAnimating = NO;
    }
    [self.listView reloadBlankData];
    
    if (self.config.loadType == ATLoadTypeNone) {
        self.loadStatus = ATLoadStatusNew;
    }
    
    if (self.loadStatus == ATLoadStatusNew) {
        [self.listView.mj_header endRefreshing];
        [self.listView.mj_footer resetNoMoreData];
        if (self.listView.at_itemsCount == 0) {
            if (error) {
                self.blankType = ATBlankTypeFailure;
            }else {
                self.blankType = ATBlankTypeNoData;
            }
        }else {
            if (self.config.loadType == ATLoadTypeAll) {
                if (self.listView.at_itemsCount >= self.config.length) {
                    if (self.config.loadStrategy == ATLoadStrategyAuto) {
                        self.listView.mj_footer = self.footer;
                    }
                }else {
                    self.listView.mj_footer = nil;
                }
            }
        }
    }else if (self.loadStatus == ATLoadStatusMore) {
        if ((self.listView.at_itemsCount - self.lastItemCount) < self.range.length) {
            [self.listView.mj_footer endRefreshingWithNoMoreData];
        }else {
            self.listView.mj_footer = self.footer;
            [self.listView.mj_footer endRefreshing];
        }
    }
    
    [self reloadData];
    self.loadStatus = ATLoadStatusIdle;
    
    self.lastItemCount = self.listView.at_itemsCount;
}

- (void)loadNew {
    self.loadStatus = ATLoadStatusNew;
    self.range = NSMakeRange(0, self.config.length);
    self.lastItemCount = 0;
    
    SEL loadNewSEL = NSSelectorFromString(@"loadNew");
    AT_SAFE_PERFORM_SELECTOR(self.listView, loadNewSEL, nil);
}

- (void)beginning {
    [self.header beginRefreshing];
}

@end


@implementation ATCenter

+ (instancetype)center {
    return [[[self class] alloc] init];
}

+ (instancetype)defaultCenter {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self center];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)setupConfig:(void(^)(ATConfig * _Nonnull config))block {
    ATConfig *config = [ATConfig new];
    AT_SAFE_BLOCK(block, config);
    self.config = config;
}

+ (void)setupConfig:(void(^)(ATConfig * _Nonnull config))block {
    [[ATCenter defaultCenter] setupConfig:block];
}

@end
