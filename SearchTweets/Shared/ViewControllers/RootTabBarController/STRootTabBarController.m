//
//  RootTabBarController.m
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STRootTabBarController.h"

@interface STRootTabBarController ()

@end

@implementation STRootTabBarController

#pragma mark - UIViewController methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupUI];
}

#pragma mark - private methods
- (void)p_setupUI
{
    [self p_setupTabBar];
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
