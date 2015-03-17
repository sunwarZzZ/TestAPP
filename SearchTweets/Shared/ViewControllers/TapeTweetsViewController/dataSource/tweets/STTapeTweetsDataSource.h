//
//  STTapeTweetsDataSource.h
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STRequestManager;
@class STTweetsNibLoader;
@protocol STTapeTweetsDataSourceDelegate;

@interface STTapeTweetsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    STTweetsNibLoader *_nibLoader;
}

- (instancetype)initWithDelegate:(id<STTapeTweetsDataSourceDelegate>)delegate
                  requestManager:(STRequestManager *)requestManager;

- (void)requestTweetsCount:(int)count offset:(int)offset;
- (int)tweetsCount;

@end

@protocol STTapeTweetsDataSourceDelegate  <NSObject>

- (void)updateTableTapeTweets;

@end