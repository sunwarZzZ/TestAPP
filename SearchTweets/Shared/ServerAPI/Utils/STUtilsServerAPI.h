//
//  STUtilsServerAPI.h
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STUtilsServerAPI : NSObject

+ (BOOL)isAvtorizationRequest:(NSURLRequest *)request;
+ (NSString *)oauthVerifierFromRequest:(NSURLRequest *)request;

+ (void)saveAccessToken:(NSString *)accessToken;
+ (void)saveAccessTokenSecret:(NSString *)accessTokenSecret;

+ (NSString *)accessToken;
+ (NSString *)accessTokenSecret;

@end
