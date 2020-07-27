//
//  ATRefreshHeader.h
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 2018/11/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <MJRefresh/MJRefreshStateHeader.h>

@interface ATRefreshHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
