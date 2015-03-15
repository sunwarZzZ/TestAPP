//
//  STRequestManager.h
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STRequestManager : NSObject

+ (BOOL)isAvtorization;

- (void)requestTapeTweets;
- (void)requestAvtorizationToken:(void(^)(NSURLRequest *const requestToken, NSError *const error))comletion;
- (void)requestAccessTokenWithOAuthVerifier:(NSString *)verifier
                                 completion:(void(^)(BOOL success, NSError *error))completion;



@end
