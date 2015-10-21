//
//  MRRequestQueue.m
//  LYStore
//
//  Created by MrXir on 14-6-20.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "MRRequestQueue.h"

@implementation MRRequestQueue

+ (MRRequestQueue *)quque
{
    static dispatch_once_t onceToken;
    static MRRequestQueue *s_MRRequestQueue = nil;
    dispatch_once(&onceToken, ^{
        s_MRRequestQueue = [[MRRequestQueue alloc] init];
    });
    return s_MRRequestQueue;
}

- (MRRequest *)requestWithParameters:(NSDictionary *)parameters
{
    MRRequest *object = nil;
    for (MRRequest *request in self.quque) {
        if ([request.parameters isEqualToDictionary:parameters]) {
            object = request;
        }
    }
    return object;
}

- (void)addMRRequest:(MRRequest *)request
{
    if (!self.quque)
        _quque = [NSMutableArray arrayWithCapacity:1];
    if (request) [self.quque addObject:request];
}

- (void)removeMRRequest:(MRRequest *)request
{
    request.delegate = nil;
    [request.connection cancel];
    [_quque removeObject:request];
}

@end
