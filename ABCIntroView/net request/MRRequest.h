//
//  MRRequest.h
//  LYStore
//
//  Created by MrXir on 14-6-16.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MRRequestDelegate.h"
#import "MRAnimation.h"
struct PageSize {
    NSInteger start;
    NSInteger count;
};
typedef struct PageSize PageSize;

CG_INLINE PageSize PageSizeMake(NSInteger start, NSInteger count);

CG_INLINE PageSize PageSizeMake(NSInteger start, NSInteger count)
{
    PageSize size;
    size.start = start;
    size.count = count;
    return size;
}

#define MRREQUESTSAYUNEEDTOUPDATEENTITY @"MRREQUESTSAYUNEEDTOUPDATEENTITY"

#define MRREQUESTPARAMETERS @"MRREQUESTPARAMETERS"

#define MRREQUESTUSERINFO @"MRREQUESTUSERINFO"

@interface MRRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<MRRequestDelegate>delegate;

@property (readonly, nonatomic, strong) NSURLConnection *connection;

@property (readonly, nonatomic, strong) NSDictionary *parameters;

/**
 *
 *  @brief 缓存策略:NSURLRequestReturnCacheDataElseLoad, 比较 NSCachedURLResponse, 相同返回, 10 秒超时.
 *
 *  @brief 提供额外的缓存标志 BOOL MRREQUESTSAYUNEEDUPDATEENTITY.
 *
 *  @brief 在:SEL(connection:willCacheResponse:) 中 self.MRREQUESTSAYUNEEDUPDATEENTITY = YES.
 *
 *  @brief 利用缓存标志充当持久化策略标志.
 *
 *  @brief 在:SEL(connectionDidFinishLoading:) 中 在解析之后的字典中插入持久化标志.
 *
 *  setObject:@(self.MRREQUESTSAYUNEEDUPDATEENTITY) forKey:@"MRREQUESTSAYUNEEDUPDATEENTITY"
 */
- (id)requestWithPath:(NSString *)path method:(NSString *)method parameters:(id)parameters;


@end

