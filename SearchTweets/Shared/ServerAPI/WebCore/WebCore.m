//
//  WebCore.m
//  GuitarSongs
//
//  Created by Aleksei Ivankov on 15.12.14.
//  Copyright (c) 2014 Aleksei Ivankov. All rights reserved.
//

#import "WebCore.h"
#import "AFHTTPSessionManager.h"

@interface WebCore()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation WebCore

- (instancetype)initWithURL:(NSURL *)URL
{
    if(self = [super init])
    {
        NSParameterAssert(URL);
        
         _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}


- (NSURLSessionDataTask *)createTaskType:(TypeRequest_WebCore)type
                              requestURL:(NSURL *)url
                               parametrs:(NSDictionary *)parametrs
                              completion:(RequestCompletion)completion;
{
    void(^Sucess)(NSURLSessionDataTask *task, id data) = ^(NSURLSessionDataTask *task, id data)
    {
        completion([self jsonWithData:data], nil);
    };
    
    void(^Failure)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error)
    {
        completion(nil, error);
    };
    
    
    NSURLSessionDataTask *requestTask = nil;
    
    if(type == POST_WebCore)
    {
        requestTask = [self.sessionManager POST:[url absoluteString] parameters:parametrs success:Sucess failure:Failure];
    }
    else if(type == GET_WebCore)
    {
        requestTask = [self.sessionManager GET:[url absoluteString] parameters:parametrs success:Sucess failure:Failure];
    }
    else if(type == PUT_WebCore)
    {
        requestTask = [self.sessionManager PUT:[url absoluteString] parameters:parametrs success:Sucess failure:Failure];
    }
    
    return requestTask;
}

- (NSDictionary *)jsonWithData:(NSData *)data
{
    NSDictionary *json = nil;
    if([data isKindOfClass:[NSData class]])
    {
        NSError *error = nil;
        json =  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"deserialization json error = %@", error);
    }
    return json;
}

@end
