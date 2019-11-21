//
//  ATViewConf.m
//  ATList_Example
//
//  Created by ablett on 2019/7/28.
//  Copyright © 2019 ablett. All rights reserved.
//

#import "ATViewConf.h"
#import <UIScrollView+ATList.h>

@implementation ATViewConf

+ (void)listConf {
    // 列表配置（可选，如不设置，取默认）
    [ATListDefaultConf setupConf:^(ATListConf * _Nonnull conf) {
        conf.loadType = ATLoadTypeAll;
        conf.loadStrategy = ATLoadStrategyAuto;
        conf.loadHeaderStyle = ATLoadHeaderStyleNormal;
        
        ATBlank *failureBlank = blankMake(blankImage(ATBlankTypeFailure), @"请求失败", @"10010");
        ATBlank *noDataBlank = blankMake(blankImage(ATBlankTypeNoData), @"暂无数据", @"10011");
        ATBlank *noNetworkBlank = blankMake(blankImage(ATBlankTypeNoNetwork), @"没有网络", @"10012");
        noDataBlank.isTapEnable = NO;
        
        conf.blankDic = @{@(ATBlankTypeFailure)   : failureBlank,
                          @(ATBlankTypeNoData)    : noDataBlank,
                          @(ATBlankTypeNoNetwork) : noNetworkBlank,};
        
        conf.length = 20;
    }];
}

@end
