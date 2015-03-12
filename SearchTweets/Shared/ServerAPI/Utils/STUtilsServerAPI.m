//
//  STUtilsServerAPI.m
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STUtilsServerAPI.h"
#import "STServerAPIConstans.h"

static NSString *const ACCESS_TOKEN_KEY = @"access_token";
static NSString *const ACCESS_TOKEN_SECRET_KEY = @"access_token_secret";
static NSString *const KEYCHAIN_ID = @"no_identifier";

@implementation STUtilsServerAPI

+ (BOOL)isAvtorizationRequest:(NSURLRequest *)request
{
    NSString *requestText = [NSString stringWithFormat:@"%@",request];
    NSRange textRange = [[requestText lowercaseString] rangeOfString:[CALLBACK_URL lowercaseString]];
    return textRange.location != NSNotFound ? YES : NO;
}

+ (NSString *)oauthVerifierFromRequest:(NSURLRequest *)request
{
    NSString *oauthVerifer = nil;
    NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
    for (NSString *param in urlParams)
    {
        NSArray *keyValue = [param componentsSeparatedByString:@"="];
        NSString *key = [keyValue firstObject];
        
        if ([key isEqualToString:OAUTH_VERIFER_KEY] && keyValue.count > 1)
        {
            oauthVerifer = [keyValue objectAtIndex:1];
            break;
        }
    }
    return oauthVerifer;
}

+ (void)saveAccessToken:(NSString *)accessToken
{
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_ID accessGroup:nil];
//    [keychainItem setObject:accessToken forKey:(__bridge id)kSecAttrAccount];
}

+ (void)saveAccessTokenSecret:(NSString *)accessTokenSecret
{
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_ID accessGroup:nil];
//    [keychainItem setObject:accessTokenSecret forKey:(__bridge id)kSecValueData];
}

+ (NSString *)accessToken
{
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_ID accessGroup:nil];
//    return [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    return nil;
}

+ (NSString *)accessTokenSecret
{
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_ID accessGroup:nil];
//    return [keychainItem objectForKey:(__bridge id)kSecValueData];
    return nil;
}


@end
