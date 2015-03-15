//
//  STWebCore.m
//  SearchTweets
//
//  Created by aleksei on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STWebCore.h"
#import "OAMutableURLRequest.h"

@interface STWebCore()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation STWebCore

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
{
    if(self = [super init])
    {
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return self;
}

#pragma mark - public methods
- (NSURLSessionDataTask *)createTaskJSONWithRequest:(OAMutableURLRequest *)request
                                         completion:(SuccessCompletionJSON)completion

{
    [request prepare];
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSDictionary *json = nil;
        if(data != nil)
        {
            json = [self p_deserializarionJsonData:data error:nil];
        }
        completion(json, error);
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask *)createTaskStringBodyWithRequest:(OAMutableURLRequest *)request
                                               completion:(SuccessCompletionStringBody)completion
{
    [request prepare];
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSString *httpBody = nil;
        if(data)
        {
            httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        completion(httpBody, error);
    }];
    return sessionDataTask;
}

#pragma mark - private methods
- (NSDictionary *)p_deserializarionJsonData:(NSData *)jsonData error:(NSError **)error
{
    NSDictionary *jsonDictionary = nil;
    if([jsonData isKindOfClass:[NSData class]])
    {
        jsonDictionary =  [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:error];
    }
    return jsonDictionary;
}

- (NSData *)p_serializarionJsonDictionary:(NSDictionary *)dictionary error:(NSError **)error
{
    NSData *jsonData = nil;
    if([dictionary isKindOfClass:[NSDictionary class]])
    {
        jsonData =  [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:error];
    }
    return jsonData;
}

@end
