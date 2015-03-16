//
//  STSearchUserTableCell.h
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTableViewCell.h"

@class STUser;
@class STRequestManager;

@protocol STSearchUserTableCellDelegate;

@interface STSearchUserTableCell : STTableViewCell

- (void)setupWithUser:(STUser *)user
       requestManager:(STRequestManager *)requestManager;

@property (nonatomic, weak) id<STSearchUserTableCellDelegate> delegate;

@end

@protocol STSearchUserTableCellDelegate <NSObject>

@end