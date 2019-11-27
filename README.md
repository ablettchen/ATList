# ATList

[![CI Status](https://img.shields.io/travis/ablett/ATList.svg?style=flat)](https://travis-ci.org/ablett/ATList)
[![Version](https://img.shields.io/cocoapods/v/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)
[![License](https://img.shields.io/cocoapods/l/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)
[![Platform](https://img.shields.io/cocoapods/p/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)

## Example

`Swift` 版本在这里 [List](https://github.com/ablettchen/List)

1. 通用配置(可选，如不配置，则使用默认)

```objectiveC
#import <UIScrollView+ATList.h>
@implementation ATAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    // Override point for customization after application launch.
    
    // 列表配置（可选，如不设置，取默认）
    [ATListDefaultConf setupConf:^(ATListConf * _Nonnull conf) {
        conf.loadStyle = ATLoadStyleAll;
        conf.loadStrategy = ATLoadStrategyAuto;
        
        ATBlank *failureBlank = blankMake(blankImage(ATBlankTypeFailure), @"请求失败", @"10010");
        ATBlank *noDataBlank = blankMake(blankImage(ATBlankTypeNoData), @"暂无数据", @"10011");
        ATBlank *noNetworkBlank = blankMake(blankImage(ATBlankTypeNoNetwork), @"没有网络", @"10012");
        noDataBlank.isTapEnable = NO;
        
        conf.blankDic = @{@(ATBlankTypeFailure)   : failureBlank,
                          @(ATBlankTypeNoData)    : noDataBlank,
                          @(ATBlankTypeNoNetwork) : noNetworkBlank,};
        
        conf.length = 20;
    }];
    
    return YES;
}
@end
```
2. 具体页面中使用

```objectiveC
#import <UIScrollView+ATList.h>

    // 具体列表配置（可选，如不设置，则取 ATListDefaultConf，ATListDefaultConf 未设置时取 conf）
    @weakify(self);
    [self.tableView updateListConf:^(ATListConf * _Nonnull conf) {
        conf.loadStrategy = self.loadStrategy;
        conf.loadStyle = self.loadStyle;
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
```

## Requirements

## Installation

ATList is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATList'
```

## Author

ablett, ablett.chen@gmail.com

## License

ATList is available under the MIT license. See the LICENSE file for more info.
