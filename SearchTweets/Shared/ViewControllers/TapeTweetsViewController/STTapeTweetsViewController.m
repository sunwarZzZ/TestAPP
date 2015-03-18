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
#import "STNotificationsKey.h"

static const int kCountTweets = 100;

@interface STTapeTweetsViewController () <UISearchDisplayDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableTweets;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, weak) IBOutlet UISearchDisplayController *searchDisplayController;
#pragma clang diagnostic pop

@property (nonatomic, weak) id<STTweetsAPIProtocol> tweetsAPI;
@property (nonatomic, weak) id<STDataBaseStrorageProtocol> dataBaseStorage;
@property (nonatomic, weak) id<STSettingsManagerProtocol> settingsManager;

@property (nonatomic, strong) STTapeTweetsDataSource *tapeTweetsDataSource;
@property (nonatomic, strong) STSearchDataSource *searchDataSource;


@end

@implementation STTapeTweetsViewController

@synthesize searchDisplayController;

- (void)dealloc
{
    [self p_unsubscribeNotifications];
}

#pragma mark - UIViewController methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.title = STLocalizedString(@"Main");
        [self p_subscribeNotifications];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (void)setupWithSettingsManager:(id<STSettingsManagerProtocol>)settingsManager
{
    self.settingsManager = settingsManager;
}

#pragma mark - Notification handlers
- (void)avatarsAvailabilityNotification:(NSNotification *)notification
{
    if([notification object])
    {
        [_avatarManager setupEnableAvatars:[[notification object] boolValue]];
        [self.tableTweets reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
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
    [_avatarManager setupCacheEnable:NO];
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [_avatarManager setupCacheEnable:YES];
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

- (void)p_subscribeNotifications
{
    [NotificationCenterDefault addObserver:self selector:@selector(avatarsAvailabilityNotification:) name:kAvatarAvailabilityNotificationKey  object:nil];
}

- (void)p_unsubscribeNotifications
{
    [NotificationCenterDefault removeObserver:self forKeyPath:kAvatarAvailabilityNotificationKey];
}

@end
