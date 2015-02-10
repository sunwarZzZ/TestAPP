//
//  STRequestManager.h
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STRequestManager : NSObject

- (void)requestAvtorizationToken:(void(^)(NSURLRequest *const requestToken, NSError *const error))comletion;
- (void)requestAccessTokenWithOAuthVerifier:(NSString *)verifier
                                 completion:(void(^)(NSString *const accessToken,
                                                     NSString *const accessTokenSecret,
                                                     NSError *const error))completion;

- (BOOL)isAvtorizationRequest:(NSURLRequest *)request;
- (NSString *)oauthVerifierFromRequest:(NSURLRequest *)request;

@end
