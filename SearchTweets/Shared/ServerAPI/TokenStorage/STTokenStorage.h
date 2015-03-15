//
//  STAccountManager.h
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTokenStorage : NSObject

+ (void)saveKey:(NSString *)key;
+ (void)savePrivateKey:(NSString *)key;

+ (NSString *)key;
+ (NSString *)privateKey;

@end
