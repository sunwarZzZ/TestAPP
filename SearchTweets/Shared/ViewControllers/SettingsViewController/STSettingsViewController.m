//
//  STSettingsViewController.m
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSettingsViewController.h"

@interface STSettingsViewController ()

@end

@implementation STSettingsViewController


#pragma mark - ViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupUI];
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.title = STLocalizedString(@"Settings");
}

@end
