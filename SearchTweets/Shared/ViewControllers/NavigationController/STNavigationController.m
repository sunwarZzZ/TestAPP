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
#import "STLocator.h"
#import "STRootTabBarController.h"
#import "STAvtorizationViewController.h"

@interface STNavigationController()

@property (nonatomic, strong) STLocator *locator;

@end

@implementation STNavigationController

#pragma mark - ViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locator = [[STLocator alloc] init];
    [[self.locator avatarManager] setupEnableCache:YES];
    [self p_selectStartController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     id destination = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:kPresentAvtorizationControllerSegue])
    {
        if([destination isKindOfClass:[STAvtorizationViewController class]])
        {
            STAvtorizationViewController *avtorizationViewController = destination;
            [avtorizationViewController setupAvtorizationManager:[self.locator avtorizationManager]];
        }
    }
    else if([[segue identifier] isEqualToString:kPresentRootControllerSegue])
    {
        if([destination isKindOfClass:[STRootTabBarController class]])
        {
            STRootTabBarController *root = destination;
            [root setupWithLocator:self.locator];
        }
    }
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

- (void)p_setupUI
{
    self.navigationBar.translucent = YES;
}


@end
