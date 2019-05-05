//
//  UIScrollView+ATList.m
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 2019/4/22.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "UIScrollView+ATList.h"
#import "UIScrollView+ATBlank.h"
#import <objc/runtime.h>

static int const dataLengthDefault = 20;
static int const dataLengthMax     = 10000;

@interface UIScrollView ()
@property (strong, readwrite, nonatomic) ATList *at_list;
@property (copy, nonatomic) void (^configBlock) (ATConfig *config);
@property (copy, nonatomic) void (^startBlock) (ATList *list);
@end

@implementation UIScrollView (ATList)

#pragma mark - setter, getter

- (void)setAt_list:(ATList *)at_list {
    objc_setAssociatedObject(self, @selector(at_list), at_list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATList *)at_list {
    ATList *list = objc_getAssociatedObject(self, _cmd);
    if (!list) {
        list = [ATList new];
        [self setAt_list:list];
    }
    return list;
}

- (void)setConfigBlock:(ATConfig *(^)(ATConfig *))configBlock {
    objc_setAssociatedObject(self, @selector(configBlock), configBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ATConfig *(^)(ATConfig *))configBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setStartBlock:(void (^)(ATList *))startBlock {
    objc_setAssociatedObject(self, @selector(startBlock), startBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(ATList *))startBlock {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - privite

- (void)loadNew {
    if (self.startBlock) {
        self.startBlock(self.at_list);
    }
}

- (void)loadMore {
    if (self.startBlock) {
        self.startBlock(self.at_list);
    }
}

- (void)loadConfig:(nullable void(^)(ATConfig * _Nonnull config))block start:(void(^)(ATList * _Nonnull list))start {
    self.configBlock = block;
    self.startBlock = start;
    
    SEL setListViewSEL = NSSelectorFromString(@"setListView:");
    AT_SAFE_PERFORM_SELECTOR(self.at_list, setListViewSEL, self);
    
    ATConfig *conf = [ATCenter defaultCenter].config?:self.at_list.config;
    AT_SAFE_BLOCK(block, conf);
    
    if (conf.length == 0) {
        if (conf.loadType == ATLoadTypeNone || \
            conf.loadType == ATLoadTypeNew) {
            conf.length = dataLengthMax;
        }else {
            conf.length = dataLengthDefault;
        }
    }
    
    [self.at_list setConfig:conf];
    
    if (conf.loadStrategy == ATLoadStrategyAuto) {
        if (self.at_list.config.loadType == ATLoadTypeNone) {
            
            ATLoadStatus loadStatus = ATLoadStatusNew;
            NSValue *loadStatusValue = [NSValue valueWithBytes:&loadStatus objCType:@encode(ATLoadStatus)];
            SEL statusSEL = NSSelectorFromString(@"setLoadStatusValue:");
            AT_SAFE_PERFORM_SELECTOR(self.at_list, statusSEL, loadStatusValue);
            
            NSRange range = NSMakeRange(0, self.at_list.config.length);
            NSValue *rangeValue = [NSValue valueWithBytes:&range objCType:@encode(NSRange)];
            SEL rangeSEL = NSSelectorFromString(@"setRangeValue:");
            AT_SAFE_PERFORM_SELECTOR(self.at_list, rangeSEL, rangeValue);

            AT_SAFE_BLOCK(start, self.at_list);
            
        }else {
            [self.at_list beginning];
        }
    }
}

@end
