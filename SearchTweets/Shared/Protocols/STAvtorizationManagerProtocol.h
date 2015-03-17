//
//  STAvtorizationManagerProtocol.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STAvtorizationManagerProtocol <NSObject>

+ (BOOL)isAvtorization;

- (void)requestAvtorizationToken:(void(^)(NSURLRequest *const requestToken, NSError *const error))comletion;
- (void)requestAccessTokenWithOAuthVerifier:(NSString *)verifier
                                 completion:(void(^)(BOOL success, NSError *error))completion;

@end
