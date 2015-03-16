//
//  STSearchUserDataSource.m
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSearchUserDataSource.h"
#import "STRequestManager.h"
#import "STSearchUserTableCell.h"
#import "STUser.h"
static const int kCountSectionTableUsers = 1;

@interface STSearchUserDataSource()

@property (nonatomic, strong) STRequestManager *requestManager;
@property (nonatomic, weak) id<STSearchUserDataSourceDelegate> delegate;
@property (nonatomic, strong) NSArray *users;

@end

@implementation STSearchUserDataSource

- (instancetype)initWithDelegate:(id<STSearchUserDataSourceDelegate>)delegate
                  requestManager:(STRequestManager *)requestManager
{
    if(self = [super init])
    {
        _requestManager = requestManager;
        _delegate = delegate;
    }
    return self;
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STSearchUserTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[STSearchUserTableCell reuseID]];
    
    if(cell == nil)
    {
      //  cell = [self loadCell];
        cell.delegate = self;
    }
    
    STUser *user = [_users objectAtIndex:indexPath.row];
    [cell setupWithUser:user requestManager:_requestManager];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _users.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kCountSectionTableUsers;
}

@end
