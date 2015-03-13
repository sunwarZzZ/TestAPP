//
//  STWebCore.h
//  SearchTweets
//
//  Created by aleksei on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TypeRequestWebCore)
{
    TypeRequestWebCorePOST,
    TypeRequestWebCoreGET,
    TypeRequestWebCorePUT
};

typedef void(^SuccessCompletion)(id JSON);
typedef void(^FailureCompletion)(NSError *error);

@interface STWebCore : NSObject

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration;

- (NSURLSessionDataTask *)createTaskType:(TypeRequestWebCore)type
                              requestURL:(NSURL *)url
                               parametrs:(NSDictionary *)parametrs
                                  sucess:(SuccessCompletion)completion
                                 failure:(FailureCompletion)failure;


@end
