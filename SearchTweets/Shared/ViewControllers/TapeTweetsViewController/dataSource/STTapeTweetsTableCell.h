//
//  STTapeTweetsTableCell.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/16/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableViewCell.h"

@class STTweet;
@class STRequestManager;
@protocol STTapeTweetsTableCellDelegate;

@interface STTapeTweetsTableCell : STTableViewCell

+ (CGSize)constraintSize;
+ (CGFloat)correctHeight;
+ (CGFloat)minHeigt;

+ (UIFont *const)fontTweetText;
+ (UIFont *const)fontUserName;

- (void)setupWithTweet:(STTweet *)tweet;
- (void)setupAvatarVisible:(BOOL)visible;
- (void)setupRequestManager:(STRequestManager *)requestManager;

@property (nonatomic, weak) id<STTapeTweetsTableCellDelegate> delegate;

@end

@protocol STTapeTweetsTableCellDelegate <NSObject>


@end