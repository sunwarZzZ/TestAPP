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

    [self p_setupUI];
    [self p_setupDataSource];
    
    [self.tapeTweetsDataSource requestTweetsCount:kSizePageTweets offset:0];
}

#pragma mark - public methods
- (void)setupWithImageDownloader:(id<STImageDownloaderProtocol>)imageDownloader
{
    _imageDownloader = imageDownloader;
}

- (void)setupWithTweetsAPI:(id<STTweetsAPIProtocol>)tweetsAPI
{
    _tweetsAPI = tweetsAPI;
}

- (void)setupWithDataBaseStorage:(id<STDataBaseStrorageProtocol>)dataBaseStorage
{
    _dataBaseStorage = dataBaseStorage;
}

#pragma mark - STTapeTweetsDataSourceDelegate
- (void)updateTableTapeTweets
{
    [self p_progressVisible:NO];
    [self.tableTweets reloadData];
}

- (void)loadPageTweetsWithOffset:(int)offset count:(int)count
{
    [self p_progressVisible:YES];
    [self.tapeTweetsDataSource requestTweetsCount:count offset:offset];
}

- (void)loadTweetsError:(NSError *)error
{
    [self p_progressVisible:YES];
}


#pragma mark - STSearchDataSourceDelegate
- (void)updateTableSearch
{
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchTweetsError:(NSError *)error
{

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
    
    self.searchDisplayController.searchResultsDataSource = self.searchDataSource;
    self.searchDisplayController.searchResultsDelegate = self.searchDataSource;
    self.searchDisplayController.delegate = self;
}

- (void)p_progressVisible:(BOOL)visible
{
    if(visible)
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.tableTweets.tableFooterView = activityIndicator;
        [activityIndicator startAnimating];
    }
    else
    {
        self.tableTweets.tableFooterView = nil;
    }
}


@end
