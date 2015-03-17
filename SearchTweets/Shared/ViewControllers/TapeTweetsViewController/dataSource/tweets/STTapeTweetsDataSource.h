//
//  STTapeTweetsDataSource.h
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTweetsAPIProtocol.h"
#import "STImageDownloaderProtocol.h"
#import "STDataBaseStrorageProtocol.h"

@class STRequestManager;
@class STTweetsNibLoader;
@protocol STTapeTweetsDataSourceDelegate;

extern const int kSizePageTweets;

@interface STTapeTweetsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    STTweetsNibLoader *_nibLoader;
}

- (instancetype)initWithDelegate:(id<STTapeTweetsDataSourceDelegate>)delegate
                       tweetsAPI:(id<STTweetsAPIProtocol>)tweetsAPI
                 imageDownloader:(id<STImageDownloaderProtocol>)imageDownloader
                 dataBaseStorage:(id<STDataBaseStrorageProtocol>)dataBaseStorage;

- (void)requestTweetsCount:(int)count offset:(int)offset;

@end

@protocol STTapeTweetsDataSourceDelegate  <NSObject>

- (void)updateTableTapeTweets;
- (void)loadPageTweetsWithOffset:(int)offset count:(int)count;
- (void)loadTweetsError:(NSError *)error;

@end