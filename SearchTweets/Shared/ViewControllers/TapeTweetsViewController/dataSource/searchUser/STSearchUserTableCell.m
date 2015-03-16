//
//  STSearchUserTableCell.m
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSearchUserTableCell.h"
#import "STRequestManager.h"

@interface STSearchUserTableCell()

@property (nonatomic, strong) STRequestManager *requestManager;
@property (nonatomic, strong) STUser *user;

@end

@implementation STSearchUserTableCell

- (void)setupWithUser:(STUser *)user
       requestManager:(STRequestManager *)requestManager
{
    self.user = user;
    self.requestManager = requestManager;
}

#pragma mark - private methods

@end
