//
//  STSearchUserDataSource.h
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTweetsAPIProtocol.h"
#import "STImageDownloaderProtocol.h"

@protocol STSearchDataSourceDelegate;
@class STRequestManager;
@class STTweetsNibLoader;

@interface STSearchDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    STTweetsNibLoader *_nibLoader;
}

- (instancetype)initWithDelegate:(id<STSearchDataSourceDelegate>)delegate
                       tweetsAPI:(id<STTweetsAPIProtocol>)tweetsAPI
                 imageDownloader:(id<STImageDownloaderProtocol>)imageDownloader;

- (void)searchTweetsWithText:(NSString *)text;

@end

@protocol STSearchDataSourceDelegate  <NSObject>

- (void)updateTableUsers;

@end