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

@interface STRootTabBarController ()

@property (nonatomic, strong) STLocator *locator;

@end

@implementation STRootTabBarController

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
            [tapeTweetsViewController setupWithImageDownloader:[self.locator imageDownloader]];
            [tapeTweetsViewController setupWithTweetsAPI:[self.locator tweetsAPI]];
        }
        else if([[navigationController.viewControllers firstObject] isKindOfClass:[STTapeTweetsViewController class]])
        {
            STProfileViewController *profileViewController = [navigationController.viewControllers firstObject];
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
