//
//  STAccountManager.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTokenStorage.h"
#import "SSKeyChain.h"

static NSString *const PUBLIC_KEY = @"public_key";
static NSString *const PRIVATE_KEY = @"private_key";

@implementation STTokenStorage

+ (void)saveKey:(NSString *)key
{
    [SSKeychain setPassword:key forService:PUBLIC_KEY account:@""];
}

+ (void)savePrivateKey:(NSString *)key
{
    [SSKeychain setPassword:key forService:PRIVATE_KEY account:@""];
}

+ (NSString *)key
{
    return [SSKeychain passwordForService:PUBLIC_KEY account:@""];
}

+ (NSString *)privateKey
{
    return [SSKeychain passwordForService:PRIVATE_KEY account:@""];
}

@end
