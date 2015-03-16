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
#import "STRequestManager.h"
#import "STUser.h"

static const int kCountSectionTableTweets = 1;

@interface STTapeTweetsDataSource(Protected)

- (STTapeTweetsTableCell *)loadCell;

@end

@interface STTapeTweetsDataSource() <STTapeTweetsTableCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<STTapeTweetsDataSourceDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) STRequestManager *requestManager;

@end

@implementation STTapeTweetsDataSource

- (instancetype)initWithDelegate:(id<STTapeTweetsDataSourceDelegate>)delegate
                  requestManager:(STRequestManager *)requestManager;
{
    if(self = [super init])
    {
        NSParameterAssert(requestManager);
        _requestManager = requestManager;
        _delegate = delegate;
     
    }
    return self;
}


#pragma mark - public methods
- (void)requestTweetsCount:(int)count offset:(int)offset
{
    [self.requestManager requestTweetsCount:count offset:offset completion:^(NSArray *array, NSError *error) {
        
        if(array && error == nil)
        {
            if(self.tweets == nil)
            {
                self.tweets = [NSMutableArray arrayWithArray:array];
            }
            else
            {
                [self.tweets addObjectsFromArray:array];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate updateTableTapeTweets];
            });
        }
    }];
}


- (int)tweetsCount
{
    return self.tweets.count;
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STTapeTweetsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[STTapeTweetsTableCell reuseID]];
    
    if(cell == nil)
    {
        cell = [self loadCell];
        cell.delegate = self;
    }
    
    STTweet *tweet = [_tweets objectAtIndex:indexPath.row];
    [cell setupWithTweet:tweet requestManager:self.requestManager avatarVisible:YES];
    
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
