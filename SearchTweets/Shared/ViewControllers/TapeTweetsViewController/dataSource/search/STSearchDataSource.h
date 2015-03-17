//
//  STSearchUserDataSource.h
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STUsersDataSourceDelegate;
@class STRequestManager;
@class STTweetsNibLoader;

@interface STSearchDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    STTweetsNibLoader *_nibLoader;
}

- (instancetype)initWithDelegate:(id<STUsersDataSourceDelegate>)delegate
                  requestManager:(STRequestManager *)requestManager;

- (void)searchTweetsWithText:(NSString *)text;

@end

@protocol STUsersDataSourceDelegate  <NSObject>

- (void)updateTableUsers;

@end