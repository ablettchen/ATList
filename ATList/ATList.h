//
//  ATList.h
//  ATList
//  https://github.com/ablettchen/ATList.git
//
//  Created by ablett on 2019/4/22.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATBlank.h"

NS_ASSUME_NONNULL_BEGIN

#define AT_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
#define AT_SAFE_PERFORM_SELECTOR(Obj, Sel, Arg) ({ \
    BOOL perform = NO; \
    if (Obj && Sel) { \
        if ([Obj respondsToSelector:Sel]) { \
            [Obj performSelectorOnMainThread:Sel withObject:Arg waitUntilDone:YES]; \
            perform = YES; \
            } \
    } \
    (perform); \
})

typedef NS_OPTIONS(NSUInteger, ATLoadType) {
    ATLoadTypeNone = 0,                             ///< 无
    ATLoadTypeNew = 1 << 0,                         ///< 下拉刷新
    ATLoadTypeMore = 1 << 1,                        ///< 上拉加载
    ATLoadTypeAll = ATLoadTypeNew | ATLoadTypeMore  ///< 下拉刷新和上拉加载
};

typedef NS_ENUM(NSUInteger, ATLoadStrategy) {
    ATLoadStrategyAuto,                             ///< 自动，马上进入加载状态
    ATLoadStrategyManual,                           ///< 手动，list.loadNew(); 进行加载，且loadType自动设置为ATLoadTypeNone
};

typedef NS_ENUM(NSUInteger, ATLoadStatus) {
    ATLoadStatusIdle,                               ///< 闲置
    ATLoadStatusNew,                                ///< 下拉刷新
    ATLoadStatusMore,                               ///< 上拉加载
};

@interface ATConfig : NSObject

@property (assign, nonatomic) ATLoadType loadType;                                      ///< 加载类型，默认:ATLoadTypeNew
@property (assign, nonatomic) enum ATLoadStrategy loadStrategy;                         ///< 加载策略，默认:ATLoadStrategyAuto
@property (assign, nonatomic) NSUInteger length;                                        ///< 加载长度
@property (strong, nonatomic, nullable) NSDictionary <NSNumber *, ATBlank *>*blankDic;  ///< 空白页配置

@end

/** 快速配置下拉刷新、上拉加载、空白页，适用于 UITableView、UICollectionView、UIScrollView */

@interface ATList : NSObject

@property (strong, readonly, nonatomic, nonnull) ATConfig *config;                      ///< 配置
@property (assign, readonly, nonatomic) enum ATLoadStatus loadStatus;                   ///< 加载状态
@property (assign, readonly, nonatomic) NSRange range;                                  ///< 数据范围

/** 设置配置项 */
- (void)setConfig:(nullable ATConfig *)config;

/** 结束加载 */
- (void)finish:(nullable NSError *)error;

/** 加载新数据*/
- (void)loadNew;

/** 进入刷新状态 */
- (void)beginning;

@end

@interface ATCenter : NSObject

@property (strong, nonatomic, nullable) ATConfig *config;

+ (instancetype)center;
+ (instancetype)defaultCenter;

- (void)setupConfig:(void(^)(ATConfig * _Nonnull config))block;
+ (void)setupConfig:(void(^)(ATConfig * _Nonnull config))block;

@end

NS_ASSUME_NONNULL_END
