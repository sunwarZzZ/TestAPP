//
//  STSettingsManager.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSettingsManager.h"
#import "STUtilsServerAPI.h"

@implementation STSettingsManager

+ (BOOL)isAvtorization
{
    return [STUtilsServerAPI accessToken] &&  [STUtilsServerAPI accessTokenSecret] ? YES : NO;
}

@end
