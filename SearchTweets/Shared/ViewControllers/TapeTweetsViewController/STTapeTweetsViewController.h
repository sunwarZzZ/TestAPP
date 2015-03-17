//
//  STTweetListViewController.h
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STViewController.h"
#import "STTapeTweetsDataSource.h"
#import "STSearchDataSource.h"
#import "STImageDownloaderProtocol.h"
#import "STTweetsAPIProtocol.h"



@class STRequestManager;

@interface STTapeTweetsViewController : STViewController <STTapeTweetsDataSourceDelegate, STSearchDataSourceDelegate>
{
    STTapeTweetsDataSource *_tapeTweetsDataSource;
    STSearchDataSource *_searchDataSource;
    
    id<STImageDownloaderProtocol> _imageDownloader;
    id<STTweetsAPIProtocol> _tweetsAPI;
}

- (void)setupWithImageDownloader:(id<STImageDownloaderProtocol>)imageDownloader;
- (void)setupWithTweetsAPI:(id<STTweetsAPIProtocol>)tweetsAPI;

@end
