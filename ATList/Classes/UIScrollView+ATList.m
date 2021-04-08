//
//  UIScrollView+ATList.m
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 2019/4/22.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "UIScrollView+ATList.h"
#import <objc/runtime.h>

#if __has_include(<ATBlank/UIScrollView+ATBlank.h>)
#import <ATBlank/UIScrollView+ATBlank.h>
#else
#import "UIScrollView+ATBlank.h"
#endif


#if __has_include(<ATCategories/ATCategories.h>)
#import <ATCategories/ATCategories.h>
#else
#import "ATCategories.h"
#endif

static int const dataLengthDefault = 20;
static int const dataLengthMax     = 10000;

static char const * const kAtList = "kAtList";

@interface UIScrollView ()
@property (strong, readwrite, nonatomic) ATList *at_list;
@property (copy, nonatomic) void (^confBlock) (ATListConf *conf);
@property (copy, nonatomic) void (^loadBlock) (ATList *list);
@end

@implementation UIScrollView (ATList)

#pragma mark - setter, getter

- (void)setAt_list:(ATList *)atList {
    objc_setAssociatedObject(self, &kAtList, atList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATList *)at_list {
    ATList *list = objc_getAssociatedObject(self, &kAtList);
    if (!list) {
        list = [ATList new];
        objc_setAssociatedObject(self, &kAtList, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return list;
}

- (void)setConfBlock:(ATListConf *(^)(ATListConf *))configBlock {
    objc_setAssociatedObject(self, @selector(confBlock), configBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ATListConf *(^)(ATListConf *))confBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLoadBlock:(void (^)(ATList *))startBlock {
    objc_setAssociatedObject(self, @selector(loadBlock), startBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(ATList *))loadBlock {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - privite

- (void)loadNewData {
    AT_SAFE_BLOCK(self.loadBlock, self.at_list);
}

- (void)loadMoreData {
    AT_SAFE_BLOCK(self.loadBlock, self.at_list);
}

#pragma mark - public

- (void)at_updateListConf:(nullable void(^)(ATListConf * _Nonnull conf))block {
    self.confBlock = block;
    
    ATListConf *conf = self.at_list.conf ? : ([[ATListDefaultConf defaultConf].conf copy] ? : [ATListConf new]);
    AT_SAFE_BLOCK(block, conf);
    
    if (conf.length == 0) {
        if (!(conf.loadStyle | ATLoadStyleNone) ||
            ((conf.loadStyle & ATLoadStyleHeader) && !(conf.loadStyle & ATLoadStyleFooter))) {
            conf.length = dataLengthMax;
        }else {
            conf.length = dataLengthDefault;
        }
    }
    self.at_list.conf = conf;
}

- (void)at_loadListData:(void(^)(ATList * _Nonnull list))block {
    self.loadBlock = block;
    
    SEL setListViewSEL = NSSelectorFromString(@"setListView:");
    AT_SAFE_PERFORM_SELECTOR(self.at_list, setListViewSEL, self);

    self.at_list.conf = self.at_list.conf?:([[ATListDefaultConf defaultConf].conf copy]?:[ATListConf new]);
    
    if (self.at_list.conf.loadStrategy == ATLoadStrategyAuto) {
        if (!(self.at_list.conf.loadStyle | ATLoadStyleNone) ||
            ((self.at_list.conf.loadStyle & ATLoadStyleFooter) && !(self.at_list.conf.loadStyle & ATLoadStyleHeader))) {
            
            ATLoadStatus loadStatus = ATLoadStatusNew;
            NSValue *loadStatusValue = [NSValue valueWithBytes:&loadStatus objCType:@encode(ATLoadStatus)];
            SEL statusSEL = NSSelectorFromString(@"setLoadStatusValue:");
            AT_SAFE_PERFORM_SELECTOR(self.at_list, statusSEL, loadStatusValue);
            
            NSRange range = NSMakeRange(0, self.at_list.conf.length);
            NSValue *rangeValue = [NSValue valueWithBytes:&range objCType:@encode(NSRange)];
            SEL rangeSEL = NSSelectorFromString(@"setRangeValue:");
            AT_SAFE_PERFORM_SELECTOR(self.at_list, rangeSEL, rangeValue);
            
            AT_SAFE_BLOCK(self.loadBlock, self.at_list);
            
        }else {
            [self.at_list beginning];
        }
    }
}

@end
