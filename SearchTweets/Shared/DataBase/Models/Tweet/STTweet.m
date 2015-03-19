//
//  STTweet.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/15/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTweet.h"

@implementation STTweet

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ = %@, tweetId = %lld, text = %@, dateCreated = %d, user = %@", [self class], self, _tweetId, _text, _dateCreated, _user];
}

- (NSString *)debugDescription
{
    return [self description];
}

@end
