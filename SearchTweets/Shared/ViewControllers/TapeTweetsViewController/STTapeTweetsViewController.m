//
//  STTweetListViewController.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsViewController.h"
#import "STRequestManager.h"
#import "STTapeTweetsTableCell.h"
#import "STTweet.h"
#import "STUser.h"

static const int kCountSectionTableTweets = 1;

@interface STTapeTweetsViewController ()<STTapeTweetsTableCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableTweets;

@property (nonatomic, strong) STRequestManager *requestManager;
@property (nonatomic, strong) NSMutableArray *tweets;


@end

@interface STTapeTweetsViewController(Protected)

- (STTapeTweetsTableCell *)loadCell;

@end

@implementation STTapeTweetsViewController

#pragma mark - UIViewController methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.title = STLocalizedString(@"Main");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.requestManager = [[STRequestManager alloc]init];
    
    [self p_setupUI];
    [self p_setupDataSource];
    [self p_requestTweetsCount:0 offset:100];
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
    
    STTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    [cell setupWithTweet:tweet];
    [cell setupRequestManager:self.requestManager];
    [cell setupAvatarVisible:YES];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kCountSectionTableTweets;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    STTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    
    CGSize tweetTextContentSize = [tweet.text boundingRectWithSize:[STTapeTweetsTableCell constraintSize] options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[STTapeTweetsTableCell fontTweetText]} context:nil].size;
    
    CGSize userNameContentSize = [tweet.user.name boundingRectWithSize:[STTapeTweetsTableCell constraintSize] options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[STTapeTweetsTableCell fontUserName]} context:nil].size;
    
    height = round(tweetTextContentSize.height + userNameContentSize.height + [STTapeTweetsTableCell correctHeight]);
    
    if(height < [STTapeTweetsTableCell minHeigt])
    {
        height = [STTapeTweetsTableCell minHeigt];
    }
    
    return height;
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.tableTweets.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)p_setupDataSource
{
    self.tableTweets.delegate = self;
    self.tableTweets.dataSource = self;
}

- (void)p_requestTweetsCount:(int)count offset:(int)offset
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
                [self.tableTweets reloadData];
            });
        }
    }];
}


@end
