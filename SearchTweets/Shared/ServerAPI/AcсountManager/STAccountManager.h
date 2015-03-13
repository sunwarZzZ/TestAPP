//
//  STAccountManager.h
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STAccountManager : NSObject

+ (void)saveTokenPublicKey:(NSString *)key;
+ (void)saveTokenPrivateKey:(NSString *)key;

+ (NSString *)tokenPublicKey;
+ (NSString *)tokenPrivateKey;

@end
