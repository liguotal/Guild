//
//  MRRequestDelegate.h
//  LYStore
//
//  Created by MrXir on 14-6-16.
//  Copyright (c) 2014年 Summer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MRRequestDelegate <NSObject>

@optional

- (void)requestWasRefused:(NSMutableURLRequest *)request;

/**
 NSString *bytes = nil;
 NSString *kB = nil;
 NSString *MB = nil;
 NSString *fileSize = nil;
 
 if (contentLength < 100) {
 bytes = [self notRounding:contentLength / 1.0f afterPoint:1];
 fileSize = [bytes stringByAppendingString:@"bytes"];
 }
 
 if (contentLength >= 100 && contentLength < 100000) {
 kB = [self notRounding:contentLength / 1000.0f afterPoint:1];
 fileSize = [kB stringByAppendingString:@"kB"];
 }
 
 if (contentLength >= 100000) {
 MB = [self notRounding:contentLength / 1000000.0f afterPoint:1];
 fileSize = [MB stringByAppendingString:@"MB"];
 }
 
 if (fileSize) {
 NSLog(@"%@",fileSize);
 }
 **/
- (void)receivedContentLength:(NSInteger)contentLength connection:(NSURLConnection *)connection;

/**
 NSLog(@"progressValue:%f",progressValue);
 NSString *percentageString = nil;
 
 if (progressValue < 0.01f) {
 CGFloat percentageLessThanOne = progressValue * 100;
 percentageString = [self notRounding:percentageLessThanOne afterPoint:2];
 NSLog(@"百分比:%@%@",percentageString,@"%");
 }
 
 if (progressValue >= 0.01f && progressValue < 1.0f) {
 CGFloat percentageMoreThanOne = progressValue * 100;
 percentageString = [self notRounding:percentageMoreThanOne afterPoint:2];
 NSLog(@"百分比:%@%@",percentageString,@"%");
 }
 
 if (progressValue >= 1.0f) {
 percentageString = @"100";
 NSLog(@"百分比:%@%@",percentageString,@"%");
 }
 **/
- (void)receivedDataProgressValue:(CGFloat)progressValue connection:(NSURLConnection *)connection;

- (void)requestSucceeded:(NSDictionary *)userInfo connection:(NSURLConnection *)connection;

- (void)requestSucceeded:(NSData *)data jsonFail:(NSError *)error connection:(NSURLConnection *)connection;

- (void)requestFailed:(NSError *)error body:(NSDictionary *)body connection:(NSURLConnection *)connection;



@end
