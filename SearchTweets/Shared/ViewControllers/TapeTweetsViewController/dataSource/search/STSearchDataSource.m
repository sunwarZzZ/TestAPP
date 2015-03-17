//
//  STSearchUserDataSource.m
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSearchDataSource.h"
#import "STRequestManager.h"
#import "STTapeTweetsTableCell.h"
#import "STTweet.h"
#import "STUser.h"
#import "STTweetsNibLoader.h"

static const int kCountSectionTableSearch = 1;

@interface STSearchDataSource()<STTapeTweetsTableCellDelegate>

@property (nonatomic, strong) STRequestManager *requestManager;
@property (nonatomic, weak) id<STUsersDataSourceDelegate> delegate;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) STTweetsNibLoader *nibLoader;

@end

@implementation STSearchDataSource

- (instancetype)initWithDelegate:(id<STUsersDataSourceDelegate>)delegate
                  requestManager:(STRequestManager *)requestManager
{
    if(self = [super init])
    {
        _requestManager = requestManager;
        _delegate = delegate;
    }
    return self;
}

#pragma mark - public methods
- (void)searchTweetsWithText:(NSString *)text
{
    [self.requestManager requestSearchTweetsWithText:text completion:^(NSArray *tweets, NSError *error)
    {
        if(tweets && error == nil)
        {
            self.tweets = tweets;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate updateTableUsers];
            });
        }
    }];
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
    [cell setupWithTweet:tweet imageDownloader:self.requestManager avatarVisible:YES];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tweets.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kCountSectionTableSearch;
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
