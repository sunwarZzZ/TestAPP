//
//  STNavigationController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STNavigationController.h"
#import "STSegueID.h"
#import "STRequestManager.h"

@implementation STNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_selectStartController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - private methods
- (void)p_selectStartController
{
    if([STRequestManager isAvtorization])
    {
        [self performSegueWithIdentifier:kPresentRootControllerSegue sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:kPresentAvtorizationControllerSegue sender:self];
    }
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.navigationBar.translucent = YES;
}


@end
