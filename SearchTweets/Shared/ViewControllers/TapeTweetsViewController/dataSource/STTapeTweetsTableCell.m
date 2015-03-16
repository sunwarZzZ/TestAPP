//
//  STTapeTweetsTableCell.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/16/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsTableCell.h"
#import "STTweet.h"
#import "STUser.h"
#import "STRequestManager.h"

static const int MAX_WIDTH_CONTAINER = 200;

@interface STTapeTweetsTableCell()

@property (nonatomic, weak) IBOutlet UILabel *nameUserLabel;
@property (nonatomic, weak) IBOutlet UILabel *tweetTextLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, strong) STTweet *tweet;
@property (nonatomic, strong) STRequestManager *requestManager;
@property (nonatomic, assign) BOOL avatarVisible;

@end

@implementation STTapeTweetsTableCell

- (void)awakeFromNib
{
    self.tweetTextLabel.numberOfLines = 0;
    self.nameUserLabel.numberOfLines = 0;
    
    self.nameUserLabel.font = [STTapeTweetsTableCell fontUserName];
    self.tweetTextLabel.font = [STTapeTweetsTableCell fontTweetText];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
}

#pragma mark - public methods
+ (CGSize)constraintSize
{
    return CGSizeMake(MAX_WIDTH_CONTAINER, MAXFLOAT);
}

+ (CGFloat)correctHeight
{
    return 21.0f;
}

+ (CGFloat)minHeigt
{
    return 50.0f;
}

+ (UIFont *const)fontTweetText
{
    return [UIFont fontWithName:@"HelveticaNeue" size:15];
}

+ (UIFont *const)fontUserName
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
}

- (void)setupWithTweet:(STTweet *)tweet
{
    self.tweet = tweet;
    
    self.tweetTextLabel.text = self.tweet.text;
    self.nameUserLabel.text = self.tweet.user.name;
    
    if(self.avatarVisible && self.requestManager && self.tweet.user.avatarURLString)
    {
        [self p_loadAvatar];
    }
}

- (void)setupRequestManager:(STRequestManager *)requestManager
{
    self.requestManager = requestManager;
}

- (void)setupAvatarVisible:(BOOL)visible
{
    self.avatarVisible = visible;
}

#pragma mark - private methods
- (void)p_loadAvatar
{
    [self.requestManager requestAvatarUserId:self.tweet.user.userId stringURL:self.tweet.user.avatarURLString completion:^(UIImage *avatar, NSError *error)
    {
        if(avatar && error == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarImageView.image = avatar;
            });
        }
    }];
}

@end
