//
//  STSettingsManager.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/18/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSettingsManager.h"

static NSString *const kCacheAvatarsKey = @"cacheAvatars";

@implementation STSettingsManager

- (void)сacheAvatarsEnable:(BOOL)enable
{
    [UserDefaultsStandart setObject:[NSNumber numberWithBool:enable] forKey:kCacheAvatarsKey];
    [UserDefaultsStandart synchronize];
}


@end
