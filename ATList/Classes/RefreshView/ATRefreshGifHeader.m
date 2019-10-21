//
//  ATRefreshGifHeader.m
//  ATList_Example
//
//  Created by ablett on 2019/10/21.
//  Copyright © 2019 ablett. All rights reserved.
//

#import "ATRefreshGifHeader.h"


@implementation ATRefreshGifHeader

- (void)prepare {
    [super prepare];
}

- (void)setRefreshingImages:(NSArray<UIImage *> *)refreshingImages {
    _refreshingImages = refreshingImages;
    if (refreshingImages.count == 0) {return;}
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:self.refreshingImages duration:refreshingImages.count * 0.03 forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:self.refreshingImages duration:refreshingImages.count * 0.03 forState:MJRefreshStateRefreshing];
}

@end
