# ATList

[![CI Status](https://img.shields.io/travis/ablett/ATList.svg?style=flat)](https://travis-ci.org/ablett/ATList)
[![Version](https://img.shields.io/cocoapods/v/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)
[![License](https://img.shields.io/cocoapods/l/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)
[![Platform](https://img.shields.io/cocoapods/p/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)

## Example

1. 通用配置(可选，如不配置，则使用默认)

```objectiveC
#import "UIScrollView+ATList.h"
@implementation ATAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [ATCenter setupConfig:^(ATConfig * _Nonnull config) {
        config.loadType = ATLoadTypeAll;
        config.loadStrategy = ATLoadStrategyAuto;
        
        ATBlank *failureBlank = blankMake(blankImage(ATBlankTypeFailure), @"数据请求失败☹️", @"200014");
        ATBlank *noDataBlank = blankMake(blankImage(ATBlankTypeNoData), @"暂时没有数据🙂", @"点击刷新");
        noDataBlank.tapEnable = YES;
        ATBlank *noNetworkBlank = blankMake(blankImage(ATBlankTypeNoNetwork), @"貌似没有网络🙄", @"请检查设置");

        config.blankDic = @{@(ATBlankTypeFailure)   : failureBlank,
                            @(ATBlankTypeNoData)    : noDataBlank,
                            @(ATBlankTypeNoNetwork) : noNetworkBlank,
                            };
        
        config.length = 18;
    }];
    
    return YES;
}
@end
```
2. 具体页面中使用

```objectiveC
#import "UIScrollView+ATList.h"
//加载数据
__weak __typeof(&*self)weakSelf = self;
[self.tableView loadConfig:^(ATConfig * _Nonnull config) {
    
    // 1. 针对具体页面进行配置（可选）；
    //config.loadType = ATLoadTypeNew;
    //config.loadStrategy = ATLoadStrategyAuto;
    //config.blankDic = @{@(ATBlankTypeFailure) : blankMake(blankImage(ATBlankTypeFailure), @"绘本数据加载失败", @"40015")};
    //config.length = 15;
    
} start:^(ATList * _Nonnull list) {
    
    // 2. 发起请求；
    NSDictionary *parameters = @{@"offset"  : @(list.range.location),
                                 @"number"  : @(list.range.length)};
    __strong __typeof(&*self)strongSelf = weakSelf;
    [weakSelf requestData:parameters finished:^(NSError *error, NSArray *datas) {
    
        // 3. 添加数据（当前加载状态为下拉刷新时移除旧数据）；
        if (list.loadStatus == ATLoadStatusNew) [strongSelf.datas removeAllObjects];
        if (datas && datas.count > 0) [strongSelf.datas addObjectsFromArray:datas];
        
        // 4. 刷新页面。
        [list finish:error];
    }];
}];

/** 若 config.loadStrategy = ATLoadStrategyManual，则需要手动调用 [self.tableView.at_list loadNew];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.tableView.at_list loadNew];
});
 */
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
