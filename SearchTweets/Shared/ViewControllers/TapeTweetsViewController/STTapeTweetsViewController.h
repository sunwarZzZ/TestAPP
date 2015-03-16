//
//  STTweetListViewController.h
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STViewController.h"
#import "STTapeTweetsDataSource.h"

@class STRequestManager;

@interface STTapeTweetsViewController : STViewController <STTapeTweetsDataSourceDelegate>
{
    STTapeTweetsDataSource *_tapeTweetsDataSource;
    STRequestManager *const _requestManager;
}

@end
