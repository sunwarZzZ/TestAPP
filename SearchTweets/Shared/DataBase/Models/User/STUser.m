//
//  STContact.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/15/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STUser.h"

@implementation STUser

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ = %@, userId = %ld, name = %@, descriptionText = %@, avatarURLString = %@", [self class], self, _userId, _name, _descriptionText, _avatarURLString];
}

- (NSString *)debugDescription
{
    return [self description];
}

@end
