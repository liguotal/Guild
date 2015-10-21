//
//  MRRequest.m
//  LYStore
//
//  Created by MrXir on 14-6-16.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import "MRRequest.h"

#import "MRRequestQueue.h"

#define UTF8STRING(A) [(A) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@interface MRRequest ()

@property (nonatomic,assign) NSInteger totalLength;

@property (nonatomic,strong) NSMutableData *receivedData;

@property (nonatomic, assign) BOOL needsUpdateEntity;

@end

@implementation MRRequest

- (NSMutableDictionary *)staticBody
{
    static NSMutableDictionary *s_body = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_body = [[NSMutableDictionary alloc] initWithCapacity:1];
    });
    [s_body setValuesForKeysWithDictionary:self.parameters];
    return s_body;
}

- (NSData *)dataWithJSONObject:(id)object
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error) NSLog(@"%@",error);
    return data;
}

- (NSData *)dataWithoutSpace:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *theData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return theData;
}

- (id)requestWithPath:(NSString *)path method:(NSString *)method parameters:(id)parameters
{    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    /*
     *  NSURLRequestReloadRevalidatingCacheData 暂不支持
     *  NSURLRequestReturnCacheDataElseLoad
     *  NSURLRequestReturnCacheDataDontLoad
     *  NSURLRequestReloadIgnoringCacheData
     */
    
    NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url
                                                          cachePolicy:cachePolicy
                                                      timeoutInterval:10.0f];
    [request setHTTPMethod:method];
    
    if (parameters) {
        
        NSMutableDictionary *s_body = [self staticBody];
        
        if ([s_body isEqualToDictionary:parameters]) {
            
            if ([self.delegate respondsToSelector:@selector(requestWasRefused:)]) {
                [self.delegate requestWasRefused:request];
            }
            
            NSString *text = @"正在处理上次请求,请稍后...";
            UIViewController *vc = (id)self.delegate;
            [MRAnimation showText:text onTheView:vc.navigationController.view];
            return self;
        }
        
        [s_body removeAllObjects];
        
        _parameters = parameters;
        
        s_body = [self staticBody];
        
        NSData *jsonBodyData = [self dataWithJSONObject:parameters];
        
        //**question**//
        jsonBodyData = [self dataWithoutSpace:jsonBodyData];
        
        [request setHTTPBody:jsonBodyData];

    } else {
        
        NSLog(@"parameters is nil");
    }
    
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    MRRequestQueue *queue = [MRRequestQueue quque];
    [queue addMRRequest:self];
    
    return self;
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    //NSLog(@"%.2f",(float)totalBytesWritten/(float)totalBytesExpectedToWrite);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
    
    //NSLog(@"%@",response)
    
    self.receivedData = [NSMutableData dataWithCapacity:1];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)])
    {
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        self.totalLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] integerValue];
        
        if ([self.delegate respondsToSelector:@selector(receivedContentLength:connection:)]) {
            [self.delegate receivedContentLength:_totalLength connection:connection];
        }
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    self.needsUpdateEntity = YES;
    return(cachedResponse);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
    
    CGFloat totalLength = _totalLength;
    
    CGFloat length = [_receivedData length];
    
    CGFloat progressValue = length / totalLength;
    
    if ([self.delegate respondsToSelector:@selector(receivedDataProgressValue:connection:)]) {
        [self.delegate receivedDataProgressValue:progressValue connection:connection];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"%@ %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    UIViewController *vc = (id)self.delegate;
    [MRAnimation showText:@"网络请求失败" onTheView:vc.view];
    
    NSMutableDictionary *s_body = [self staticBody];

    if ([self.delegate respondsToSelector:@selector(requestFailed:body:connection:)]) {
        [self.delegate requestFailed:error body:s_body connection:connection];
    }
    
    [s_body removeAllObjects];
    [[MRRequestQueue quque] removeMRRequest:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSData *data = _receivedData;
    NSError *error = nil;
    
    //NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"dataString:%@",dataString);
    
    NSMutableDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@ %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
        if ([self.delegate respondsToSelector:@selector(requestSucceeded:jsonFail:connection:)]) {
            [self.delegate requestSucceeded:data jsonFail:error connection:connection];
        }
        NSMutableDictionary *s_body = [self staticBody];
        [s_body removeAllObjects];
        [[MRRequestQueue quque] removeMRRequest:self];
        return;
    }
    
    if ([userInfo isKindOfClass:[NSArray class]]) {
        
        NSLog(@"%@ %@ %@ keyCoding with %@ to %@ by MRRequest.", NSStringFromClass([self class]), NSStringFromSelector(_cmd), userInfo.class,MRREQUESTUSERINFO,[NSMutableDictionary class]);
        
        userInfo = [NSMutableDictionary dictionaryWithObject:userInfo forKey:MRREQUESTUSERINFO];
    }
    
    if (![userInfo isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@ %@ jsoned object is not a kind of %@ or %@ class.", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [NSArray class],[NSDictionary class]);

        NSMutableDictionary *s_body = [self staticBody];
        [s_body removeAllObjects];
        [[MRRequestQueue quque] removeMRRequest:self];
        return;
    }
    
    
    [userInfo setObject:@(self.needsUpdateEntity) forKey:MRREQUESTSAYUNEEDTOUPDATEENTITY];
    if (self.parameters.count) [userInfo setObject:self.parameters forKey:MRREQUESTPARAMETERS];
    
    if ([self.delegate respondsToSelector:@selector(requestSucceeded:connection:)]) {
        [self.delegate requestSucceeded:userInfo connection:connection];
    }
    
    NSMutableDictionary *s_body = [self staticBody];
    [s_body removeAllObjects];
    [[MRRequestQueue quque] removeMRRequest:self];
    
}







@end
