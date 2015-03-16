//
//  STProfileViewController.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STProfileViewController.h"

@interface STProfileViewController ()

@end

@implementation STProfileViewController



#pragma mark - ViewController methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.title = STLocalizedString(@"Profile");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupUI];
}

#pragma mark - private methods
- (void)p_setupUI
{
   
}


@end
