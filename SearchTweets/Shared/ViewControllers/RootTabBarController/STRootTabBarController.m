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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupUI];
}

#pragma mark - private methods
- (void)p_setupUI
{
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setBarTintColor:[UIColor clearColor]];
    [self.tabBar setShadowImage:[UIImage new]];
}


@end
