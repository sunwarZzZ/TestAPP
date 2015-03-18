//
//  STTapeTweetsDataSource.m
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsDataSource.h"
#import "STTapeTweetsTableCell.h"
#import "STTweet.h"
#import "STUser.h"
#import "STTweetsNibLoader.h"
#import "STTweetsAPIProtocol.h"
#import "STImageDownloaderProtocol.h"

static const int kCountSectionTableTweets = 1;

@interface STTapeTweetsDataSource() <STTapeTweetsTableCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) STTweetsNibLoader *nibLoader;
@property (nonatomic, weak) id<STAvatarManagerProtocol> avatarManager;

@end

@implementation STTapeTweetsDataSource

- (instancetype)initWithAvatarManager:(STAvatarManager *)avatarManager
{
    if(self = [super init])
    {
        self.avatarManager = avatarManager;
    }
    return self;
}


#pragma mark - public methods
- (void)setupWithTweets:(NSArray *)tweets
{
    self.tweets = tweets;
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STTapeTweetsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[STTapeTweetsTableCell reuseID]];
    
    if(cell == nil)
    {
        cell = [self.nibLoader loadTweetCell];
        cell.delegate = self;
    }
    
    STTweet *tweet = [_tweets objectAtIndex:indexPath.row];
    [cell setupWithTweet:tweet avatarManager:self.avatarManager];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tweets.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kCountSectionTableTweets;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    STTweet *tweet = [_tweets objectAtIndex:indexPath.row];
    
    CGSize tweetTextContentSize = [tweet.text boundingRectWithSize:[STTapeTweetsTableCell constraintSize] options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[STTapeTweetsTableCell fontTweetText]} context:nil].size;
    
    CGSize userNameContentSize = [tweet.user.name boundingRectWithSize:[STTapeTweetsTableCell constraintSize] options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[STTapeTweetsTableCell fontUserName]} context:nil].size;
    
    height = round(tweetTextContentSize.height + userNameContentSize.height + [STTapeTweetsTableCell correctHeight]);
    
    if(height < [STTapeTweetsTableCell minHeigt])
    {
        height = [STTapeTweetsTableCell minHeigt];
    }
    
    return height;
}


@end
