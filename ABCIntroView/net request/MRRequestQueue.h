//
//  MRRequestQueue.h
//  LYStore
//
//  Created by MrXir on 14-6-20.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MRRequest.h"

@interface MRRequestQueue : NSObject

@property (readonly, nonatomic, strong) NSMutableArray *quque;

+ (MRRequestQueue *)quque;

- (MRRequest *)requestWithParameters:(NSDictionary *)parameters;

- (void)addMRRequest:(MRRequest *)request;

- (void)removeMRRequest:(MRRequest *)request;

@end
