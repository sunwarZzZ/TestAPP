//
//  STTapeTweetsDataSource_iPhone.m
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsDataSource_iPhone.h"
#import "STTweetsNibLoader_iPhone.h"

@interface STTapeTweetsDataSource_iPhone()

@end

@implementation STTapeTweetsDataSource_iPhone

- (STTweetsNibLoader *)nibLoader
{
    if(_nibLoader == nil)
    {
        _nibLoader = [[STTweetsNibLoader_iPhone alloc] init];
    }
    return _nibLoader;
}

@end
