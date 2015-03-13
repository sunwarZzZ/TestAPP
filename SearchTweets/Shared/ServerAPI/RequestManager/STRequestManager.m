//
//  STRequestManager.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STRequestManager.h"
#import "STWebCore.h"

@interface STRequestManager()

@property (nonatomic, strong) STWebCore *webCore;

@end

@implementation STRequestManager

- (instancetype)init
{
    if(self = [super init])
    {
        _webCore = [[STWebCore alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)requestTweets:(void (^)(void))completion
{
//    if(count) md[@"count"] = count;
//    if(sinceID) md[@"since_id"] = sinceID;
//    if(maxID) md[@"max_id"] = maxID;
//    
//    if(trimUser) md[@"trim_user"] = [trimUser boolValue] ? @"1" : @"0";
//    if(excludeReplies) md[@"exclude_replies"] = [excludeReplies boolValue] ? @"1" : @"0";
//    if(contributorDetails) md[@"contributor_details"] = [contributorDetails boolValue] ? @"1" : @"0";
//    if(includeEntities) md[@"include_entities"] = [includeEntities boolValue] ? @"1" : @"0";
    
    //@"statuses/home_timeline.json"
    
    
    
}

@end
