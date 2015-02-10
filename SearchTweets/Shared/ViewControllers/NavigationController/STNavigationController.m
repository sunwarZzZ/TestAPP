//
//  STNavigationController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STNavigationController.h"
#import "STSettingsManager.h"
#import "STSegueIdentifierConstant.h"


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
    if([STSettingsManager isAvtorization])
    {
        [self performSegueWithIdentifier:kShowSearchSegue sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:kShowStartSegue sender:self];
    }
}



@end
