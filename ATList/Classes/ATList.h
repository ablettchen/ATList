//
//  ATList.h
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 2019/4/22.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<ATBlank/ATBlank.h>)
#import <ATBlank/ATBlank.h>
#else
#import "ATBlank.h"
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ATLoadStyle) {
    ATLoadStyleNone = 0,                                    ///< 无, 0000 0000
    ATLoadStyleHeader = 1 << 0,                             ///< 下拉刷新, 0000 0001
    ATLoadStyleFooter = 1 << 1,                             ///< 上拉加载, 0000 0010
    ATLoadStyleAll = ATLoadStyleHeader | ATLoadStyleFooter  ///< 下拉刷新和上拉加载, 0000 0001 | 0000 0010 = 0000 0011
};

typedef NS_ENUM(NSUInteger, ATLoadStrategy) {
    ATLoadStrategyAuto,                                     ///< 自动，马上进入加载状态
    ATLoadStrategyManual,                                   ///< 手动，list.loadNewData(); 进行加载
};

typedef NS_ENUM(NSUInteger, ATLoadStatus) {
    ATLoadStatusIdle,                                       ///< 闲置
    ATLoadStatusNew,                                        ///< 下拉刷新
    ATLoadStatusMore,                                       ///< 上拉加载
};

typedef NS_ENUM(NSUInteger, ATLoadHeaderStyle) {
    ATLoadHeaderStyleNormal,                                ///< 默认
    ATLoadHeaderStyleGif,                                   ///< GIF
};

@interface ATListConf : NSObject

@property (assign, nonatomic) ATLoadStyle loadStyle;                                    ///< 加载类型，默认:ATLoadStyleHeader
@property (assign, nonatomic) enum ATLoadStrategy loadStrategy;                         ///< 加载策略，默认:ATLoadStrategyAuto
@property (assign, nonatomic) NSUInteger length;                                        ///< 加载长度

@property (strong, nonatomic, nullable) UIView *customBlankView;                        ///< 自定义空白页面，默认为空
@property (strong, nonatomic, nullable) NSDictionary <NSNumber *, ATBlank *>*blankDic;  ///< 空白页配置

@property (assign, nonatomic) enum ATLoadHeaderStyle loadHeaderStyle;                   ///< 刷新头部样式，默认：ATLoadHeaderStyleNormal
@property (strong, nonatomic, nonnull) NSArray<UIImage *>*refreshingImages;             ///< 刷新时的图片组

- (void)reset;

@end

/** 快速配置下拉刷新、上拉加载、空白页，适用于 UITableView、UICollectionView、UIScrollView */

@interface ATList : NSObject

@property (strong, nonatomic, nonnull) ATListConf *conf;                                ///< 配置
@property (assign, readonly, nonatomic) enum ATLoadStatus loadStatus;                   ///< 加载状态
@property (assign, readonly, nonatomic) NSRange range;                                  ///< 数据范围

/** 结束加载 */
- (void)finish:(nullable NSError *)error;

/** 加载新数据*/
- (void)loadNewData;
- (void)loadNewDataWithAnimated:(BOOL)animated;
- (void)loadNewDataWithAnimated:(BOOL)animated length:(NSUInteger)length;

/** 进入刷新状态 */
- (void)beginning;

+ (NSBundle *)listBundle;

@end

@interface ATListDefaultConf : NSObject

@property (strong, nonatomic, nullable) ATListConf *conf;

+ (instancetype)defaultConf;

- (void)setupConf:(void(^)(ATListConf * _Nonnull conf))block;
+ (void)setupConf:(void(^)(ATListConf * _Nonnull conf))block;

@end

NS_ASSUME_NONNULL_END
