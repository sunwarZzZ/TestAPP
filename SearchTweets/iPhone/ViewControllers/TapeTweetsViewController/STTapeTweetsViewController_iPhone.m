//
//  STTweetListViewController_iPhone.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsViewController_iPhone.h"
#import "STTapeTweetsDataSource_iPhone.h"

@interface STTapeTweetsViewController_iPhone ()


@end

@implementation STTapeTweetsViewController_iPhone

- (STTapeTweetsDataSource *)tapeTweetsDataSource
{
    if(_tapeTweetsDataSource == nil)
    {
        _tapeTweetsDataSource = [[STTapeTweetsDataSource_iPhone alloc] initWithDelegate:self requestManager:_requestManager];
    }
    return _tapeTweetsDataSource;
}

@end
