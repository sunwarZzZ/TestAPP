//
//  RootTabBarController.m
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STRootTabBarController.h"
#import "STLocator.h"
#import "STTapeTweetsViewController.h"
#import "STProfileViewController.h"
#import "STNotificationsKey.h"

@interface STRootTabBarController ()

@property (nonatomic, strong) STLocator *locator;

@end

@implementation STRootTabBarController

- (void)dealloc
{

}

#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self p_setupChildControllers];
    [self p_setupUI];
}


#pragma mark - public methods
- (void)setupWithLocator:(STLocator *)locator
{
    self.locator = locator;
}


#pragma mark - private methods
- (void)p_setupUI
{
    [self p_setupTabBar];
}

- (void)p_setupChildControllers
{
    for(UINavigationController *navigationController in self.viewControllers)
    {
        if([[navigationController.viewControllers firstObject] isKindOfClass:[STTapeTweetsViewController class]])
        {
            STTapeTweetsViewController *tapeTweetsViewController = [navigationController.viewControllers firstObject];
            [tapeTweetsViewController setupWithAvatarManager:[self.locator avatarManager]];
            [tapeTweetsViewController setupWithTweetsAPI:[self.locator tweetsAPI]];
            [tapeTweetsViewController setupWithDataBaseStorage:[self.locator dataBaseStorage]];
            [tapeTweetsViewController setupWithSettingsManager:[self.locator settingsManager]];
        }
        else if([[navigationController.viewControllers firstObject] isKindOfClass:[STProfileViewController class]])
        {
            STProfileViewController *profileViewController = [navigationController.viewControllers firstObject];
            [profileViewController setupSettingsManager:[self.locator settingsManager]];
        }
    }
}

- (void)p_setupTabBar
{
    NSArray *items = self.tabBar.items;
    NSArray *viewControllers = self.viewControllers;
    
    if(items.count == viewControllers.count)
    {
        for(int i = 0; i < viewControllers.count; i++)
        {
            UINavigationController *navigationController = [viewControllers objectAtIndex:i];
            UITabBarItem *tabBarItem = [items objectAtIndex:i];
            tabBarItem.title = [[[navigationController viewControllers] firstObject] title];
        }
    }
}


@end
