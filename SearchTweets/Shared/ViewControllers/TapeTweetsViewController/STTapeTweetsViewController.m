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
#import "STTweetsAPIProtocol.h"
#import "STDataBaseStrorageProtocol.h"

static const int kCountTweets = 100;

@interface STTapeTweetsViewController () <UISearchDisplayDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableTweets;
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;

@property (nonatomic, weak) id<STTweetsAPIProtocol> tweetsAPI;
@property (nonatomic, weak) id<STDataBaseStrorageProtocol> dataBaseStorage;

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
    
    [self.dataBaseStorage tweets:^(NSArray *tweets) {
        [self.tapeTweetsDataSource setupWithTweets:tweets];
        [self.tableTweets reloadData];
    }];
    
    [self p_requestTweetsCount:kCountTweets];
}

#pragma mark - public methods
- (void)setupWithAvatarManager:(id<STAvatarManagerProtocol>)avatarManager;
{
    _avatarManager = avatarManager;
}

- (void)setupWithTweetsAPI:(id<STTweetsAPIProtocol>)tweetsAPI
{
    self.tweetsAPI = tweetsAPI;
}

- (void)setupWithDataBaseStorage:(id<STDataBaseStrorageProtocol>)dataBaseStorage
{
    self.dataBaseStorage = dataBaseStorage;
}


#pragma mark - UISearchControllerDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if(searchString)
    {
        [self p_searchTweetsWithText:searchString];
    }
    return YES;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [_avatarManager setupEnableCache:NO];
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [_avatarManager setupEnableCache:YES];
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

- (void)p_requestTweetsCount:(int)count
{
    [self.tweetsAPI requestTweetsCount:count completion:^(NSArray *array, NSError *error) {
        if(array && error == nil)
        {
            [self.dataBaseStorage addTweets:array completion:^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tapeTweetsDataSource setupWithTweets:array];
                    [self.tableTweets reloadData];
                });
            }];
        }
        else
        {
            NSLog(@"request tweets error %@", error);
        }
    }];
}

- (void)p_searchTweetsWithText:(NSString *)text
{
    [self.tweetsAPI requestSearchTweetsWithText:text completion:^(NSArray *tweets, NSError *error)
     {
         if(tweets && error == nil)
         {
             [self.searchDataSource setupWithTweets:tweets];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.searchDisplayController.searchResultsTableView reloadData];
             });
         }
         else
         {
             NSLog(@"search error %@", error);
         }
     }];
}

@end
