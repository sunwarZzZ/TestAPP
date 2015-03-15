//
//  STWebCore.h
//  SearchTweets
//
//  Created by aleksei on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OAMutableURLRequest;

typedef void(^SuccessCompletionJSON)(id JSON, NSError *error);
typedef void(^SuccessCompletionStringBody)(NSString *body, NSError *error);

@interface STWebCore : NSObject

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

- (NSURLSessionDataTask *)createTaskJSONWithRequest:(OAMutableURLRequest *)request
                                     completion:(SuccessCompletionJSON)completion;

- (NSURLSessionDataTask *)createTaskStringBodyWithRequest:(OAMutableURLRequest *)request
                                     completion:(SuccessCompletionStringBody)completion;


@end
