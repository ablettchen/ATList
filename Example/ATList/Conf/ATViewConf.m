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
        
        conf.loadStyle = ATLoadStyleAll;
        conf.loadStrategy = ATLoadStrategyAuto;
        conf.loadHeaderStyle = ATLoadHeaderStyleNormal;
        
        ATBlank *failureBlank = [ATBlank blankWithImage:[ATBlank defaultImageWithType:ATBlankTypeFailure]
                                                  title:@"请求失败"
                                                   desc:@"10010"];
        
        ATBlank *noDataBlank = [ATBlank blankWithImage:[ATBlank defaultImageWithType:ATBlankTypeNoData]
                                                 title:@"暂无数据"
                                                  desc:@"10011"];
        
        ATBlank *noNetworkBlank = [ATBlank blankWithImage:[ATBlank defaultImageWithType:ATBlankTypeNoNetwork]
                                                 title:@"没有网络"
                                                  desc:@"10012"];

        noDataBlank.isTapEnable = NO;
        
        conf.blankDic = @{@(ATBlankTypeFailure)   : failureBlank,
                          @(ATBlankTypeNoData)    : noDataBlank,
                          @(ATBlankTypeNoNetwork) : noNetworkBlank,};
        
        conf.length = 20;
    }];
}

@end
