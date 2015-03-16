//
//  STTweetListViewController.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsViewController.h"
#import "STRequestManager.h"
#import "STTapeTweetsDataSource.h"
#import "STTweet.h"

@interface STTapeTweetsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableTweets;

@property (nonatomic, strong) STRequestManager *requestManager;
@property (nonatomic, strong) STTapeTweetsDataSource *tapeTweetsDataSource;


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
}

#pragma mark - STTapeTweetsDataSourceDelegate
- (void)updateTableTapeTweets
{
    [self.tableTweets reloadData];
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.tableTweets.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)p_setupDataSource
{
    self.tableTweets.delegate = self.tapeTweetsDataSource;
    self.tableTweets.dataSource = self.tapeTweetsDataSource;
    [self.tapeTweetsDataSource requestTweetsCount:100 offset:0];
}



@end
