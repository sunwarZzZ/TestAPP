//
//  STSettingsItem.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/18/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, STSettingsItemType)
{
    STSettingsItemTypeAvatarVisible
};

@interface STSettingsItem : NSObject

@property (nonatomic, assign) int settingsId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) STSettingsItemType type;

@end
