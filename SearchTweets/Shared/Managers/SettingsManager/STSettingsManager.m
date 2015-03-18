//
//  STSettingsManager.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/18/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSettingsManager.h"
#import "STNotificationsKey.h"

static NSString *const kAvatarsVisible = @"avatarsVisible";

@implementation STSettingsManager

#pragma mark - STSettingsManagerProtocol
- (void)setupAvatarsVisible:(BOOL)visible
{
    [UserDefaultsStandart setObject:[NSNumber numberWithBool:visible] forKey:kAvatarsVisible];
    [UserDefaultsStandart synchronize];
    [NotificationCenterDefault postNotificationName:kAvatarAvailabilityNotificationKey object:[NSNumber numberWithBool:visible]];
}

- (BOOL)avatarsVisible
{
    return [[UserDefaultsStandart objectForKey:kAvatarsVisible] boolValue];
}


@end
