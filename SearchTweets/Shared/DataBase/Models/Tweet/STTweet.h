//
//  STTweet.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/15/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STUser;

@interface STTweet : NSObject

@property (nonatomic, assign) long long tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) int dateCreated;

@property (nonatomic, strong) STUser *user;

@end
