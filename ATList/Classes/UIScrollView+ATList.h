//
//  UIScrollView+ATList.h
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 2019/4/22.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATList.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ATList)

@property (strong, readonly, nonatomic, nonnull) ATList *at_list;

- (void)at_updateListConf:(nullable void(^)(ATListConf * _Nonnull conf))block;
- (void)at_loadListData:(void(^)(ATList * _Nonnull list))block;

@end

NS_ASSUME_NONNULL_END
