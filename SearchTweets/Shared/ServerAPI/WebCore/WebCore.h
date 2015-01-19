//
//  WebCore.h
//  GuitarSongs
//
//  Created by Aleksei Ivankov on 15.12.14.
//  Copyright (c) 2014 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TypeRequest_WebCore)
{
    POST_WebCore,
    GET_WebCore,
    PUT_WebCore
};

typedef void(^RequestCompletion)(id JSON, NSError *error);

@interface WebCore : NSObject

- (instancetype)initWithURL:(NSURL *)URL;

- (NSURLSessionDataTask *)createTaskType:(TypeRequest_WebCore)type
                              requestURL:(NSURL *)url
                               parametrs:(NSDictionary *)parametrs
                              completion:(RequestCompletion)completion;

@end
