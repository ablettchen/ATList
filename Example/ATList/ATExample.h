//
//  ATExample.h
//  ATList_Example
//
//  Created by ablett on 2019/7/28.
//  Copyright © 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATExample : NSObject

@property (copy, nonatomic) NSString *title;

@property (assign, nonatomic) ATLoadStrategy loadStrategy;
@property (assign, nonatomic) ATLoadType loadType;

+ (ATExample *)exampleWithLoadStrategy:(ATLoadStrategy)loadStrategy loadType:(ATLoadType)loadType;

@end

NS_INLINE ATExample* ATExampleMake(ATLoadStrategy loadStrategy, ATLoadType loadType) {
    return [ATExample exampleWithLoadStrategy:loadStrategy loadType:loadType];
}

NS_ASSUME_NONNULL_END
