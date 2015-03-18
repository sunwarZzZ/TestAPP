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

static const int MAX_WIDTH_CONTAINER = 246;

@interface STTapeTweetsTableCell()

@property (nonatomic, weak) IBOutlet UILabel *nameUserLabel;
@property (nonatomic, weak) IBOutlet UILabel *tweetTextLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) id<STAvatarManagerProtocol> avatarManager;

@property (nonatomic, strong) STTweet *tweet;

@end

@implementation STTapeTweetsTableCell

- (void)awakeFromNib
{
    self.tweetTextLabel.numberOfLines = 0;
    self.nameUserLabel.numberOfLines = 0;
    
    self.nameUserLabel.font = [STTapeTweetsTableCell fontUserName];
    self.tweetTextLabel.font = [STTapeTweetsTableCell fontTweetText];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 5.0f;
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
    return 50.0f + [STTapeTweetsTableCell correctHeight];
}

+ (UIFont *const)fontTweetText
{
    return [UIFont fontWithName:@"HelveticaNeue" size:15];
}

+ (UIFont *const)fontUserName
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
}

- (void)setupWithTweet:(STTweet *)tweet avatarManager:(id<STAvatarManagerProtocol>)avatarManager
{
    self.tweet = tweet;
    self.avatarManager = avatarManager;
    
    self.tweetTextLabel.text = self.tweet.text;
    self.nameUserLabel.text = self.tweet.user.name;
      self.avatarImageView.image = nil;
    
    [self.avatarManager avatarWithUser:self.tweet.user completion:^(UIImage *avatar) {
        self.avatarImageView.image = avatar;
    }];
    
}

#pragma mark - private methods

@end
