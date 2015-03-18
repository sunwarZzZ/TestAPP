//
//  STProfileItem.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/18/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, STProfileItemType)
{
    STProfileItemTypeSettings
};

@interface STProfileItem : NSObject

@property (nonatomic, assign) int profileId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) STProfileItemType type;

@end
