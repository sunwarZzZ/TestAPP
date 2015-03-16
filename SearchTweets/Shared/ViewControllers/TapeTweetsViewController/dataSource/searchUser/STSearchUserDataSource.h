//
//  STSearchUserDataSource.h
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STSearchUserDataSourceDelegate;
@class STRequestManager;

@interface STSearchUserDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithDelegate:(id<STSearchUserDataSourceDelegate>)delegate
                  requestManager:(STRequestManager *)requestManager;

- (void)searchUserWithText:(NSString *)text;

@end

@protocol STSearchUserDataSourceDelegate  <NSObject>

- (void)updateTableSearch;

@end