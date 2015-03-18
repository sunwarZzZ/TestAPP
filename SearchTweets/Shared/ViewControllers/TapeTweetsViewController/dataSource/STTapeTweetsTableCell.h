//
//  STTapeTweetsTableCell.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/16/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTableViewCell.h"
#import "STAvatarManagerProtocol.h"

@class STTweet;
@protocol STTapeTweetsTableCellDelegate;

@interface STTapeTweetsTableCell : STTableViewCell

+ (CGSize)constraintSize;
+ (CGFloat)correctHeight;
+ (CGFloat)minHeigt;

+ (UIFont *const)fontTweetText;
+ (UIFont *const)fontUserName;

- (void)setupWithTweet:(STTweet *)tweet
         avatarManager:(id<STAvatarManagerProtocol>)avatarManager;



@property (nonatomic, weak) id<STTapeTweetsTableCellDelegate> delegate;

@end

@protocol STTapeTweetsTableCellDelegate <NSObject>


@end