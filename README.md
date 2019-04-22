# ATList

[![CI Status](https://img.shields.io/travis/ablett/ATList.svg?style=flat)](https://travis-ci.org/ablett/ATList)
[![Version](https://img.shields.io/cocoapods/v/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)
[![License](https://img.shields.io/cocoapods/l/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)
[![Platform](https://img.shields.io/cocoapods/p/ATList.svg?style=flat)](https://cocoapods.org/pods/ATList)

## Example

```objectiveC
    #import "UIScrollView+ATList.h"

    //加载数据
    __weak __typeof(&*self)weakSelf = self;
    [self.tableView loadData:^(ATList * _Nonnull list) {
        
        //1. 列表刷新配置
        list.loadType = ATLoadTypeAll;
        
        list.blankDic = @{@(ATBlankTypeFailure) : blankMake(blankImage(ATBlankTypeFailure), @"加载失败了", @"404")};
        [list start];
        
        //2. 请求数据
        //请求参数
        NSDictionary *parameters = @{@"offset"  : @(list.range.location),
                                     @"number"  : @(list.range.length)};
        __strong __typeof(&*self)strongSelf = weakSelf;
        [weakSelf requestDataWithParameters:parameters finished:^(NSError *error, NSArray *datas) {
            //3. 添加数据
            //当前加载状态为下拉刷新时移除旧数据
            if (list.loadStatus == ATLoadStatusNew) [strongSelf.datas removeAllObjects];
            if (datas && datas.count > 0) [strongSelf.datas addObjectsFromArray:datas];
            //4. 刷新
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
