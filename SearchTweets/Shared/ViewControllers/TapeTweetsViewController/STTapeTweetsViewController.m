//
//  STTweetListViewController.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsViewController.h"
#import "STRequestManager.h"
#import "STTweet.h"

@interface STTapeTweetsViewController () <UISearchDisplayDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableTweets;
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;

@property (nonatomic, strong) STRequestManager *requestManager;

@property (nonatomic, strong) STTapeTweetsDataSource *tapeTweetsDataSource;
@property (nonatomic, strong) STSearchDataSource *searchDataSource;


@end

@implementation STTapeTweetsViewController

@synthesize searchDisplayController;

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

#pragma mark - STUsersDataSourceDelegate
- (void)updateTableUsers
{
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - UISearchControllerDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if(searchString)
    {
        [self.searchDataSource searchTweetsWithText:searchString];
    }
    return YES;
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.tableTweets.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)p_setupDataSource
{
    self.tableTweets.delegate = self.tapeTweetsDataSource;
    self.tableTweets.dataSource = self.tapeTweetsDataSource;
    [self.tapeTweetsDataSource requestTweetsCount:10 offset:0];
    
    self.searchDisplayController.searchResultsDataSource = self.searchDataSource;
    self.searchDisplayController.searchResultsDelegate = self.searchDataSource;
    self.searchDisplayController.delegate = self;
}



@end
