//
//  ATRefreshGifHeader.h
//  ATList_Example
//
//  Created by ablett on 2019/10/21.
//  Copyright © 2019 ablett. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATRefreshGifHeader : MJRefreshGifHeader

@property(strong, nonatomic, nonnull) NSArray<UIImage *>*idleImages;
@property(strong, nonatomic, nonnull) NSArray<UIImage *>*refreshingImages;

@end

NS_ASSUME_NONNULL_END
