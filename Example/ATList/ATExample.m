//
//  ATExample.m
//  ATList_Example
//
//  Created by ablett on 2019/7/28.
//  Copyright © 2019 ablett. All rights reserved.
//

#import "ATExample.h"

@implementation ATExample

+ (ATExample *)exampleWithLoadStrategy:(ATLoadStrategy)loadStrategy loadType:(ATLoadType)loadType {
    ATExample *model = [ATExample new];
    model.loadStrategy = loadStrategy;
    model.loadType = loadType;
    
    NSString *strategyDesc = nil;
    
    switch (loadStrategy) {
        case ATLoadStrategyAuto:
            strategyDesc = @"自动";
            break;
        case ATLoadStrategyManual:
            strategyDesc = @"手动";
            break;
        default:
            break;
    }
    
    NSString *typeDesc = nil;
    switch (loadType) {
        case ATLoadTypeNone:
            typeDesc = @"无刷新";
            break;
        case ATLoadTypeNew:
            typeDesc = @"下拉刷新";
            break;
        case ATLoadTypeMore:
            typeDesc = @"上拉加载";
            break;
        case ATLoadTypeAll:
            typeDesc = @"下拉刷新 + 上拉加载";
            break;
            
        default:
            break;
    }
    
    model.title = [NSString stringWithFormat:@"%@: %@", strategyDesc, typeDesc];
    
    return model;
}

@end
