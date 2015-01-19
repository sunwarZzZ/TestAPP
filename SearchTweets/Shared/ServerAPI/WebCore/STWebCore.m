//
//  STWebCore.m
//  SearchTweets
//
//  Created by aleksei on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STWebCore.h"

static const int TIME_OUT_INTERVAL = 60;

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
- (NSURLSessionDataTask *)createTaskType:(TypeRequest_WebCore)type
                              requestURL:(NSURL *)url
                               parametrs:(NSDictionary *)parametrs
                                  sucess:(SuccessCompletion)completion
                                 failure:(FailureCompletion)failure
{
    NSMutableURLRequest *request = [self p_requestWithType:type url:url parametrs:parametrs];
    NSURLSessionDataTask *sessionDataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(error == nil)
        {
            NSDictionary *json = [self p_deserializarionJsonData:data error:&error];
            if(error == nil)
            {
                return completion(json);
            }
        }
        failure(error);
    }];
    return sessionDataTask;
}

#pragma mark - private methods
- (NSMutableURLRequest *)p_requestWithType:(TypeRequest_WebCore)typeRequest
                                       url:(NSURL *)url
                                 parametrs:(NSDictionary *)parametrs
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:TIME_OUT_INTERVAL];
    
    return request;
}

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
