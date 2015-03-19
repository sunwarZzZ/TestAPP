//
//  STBaseViewController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STViewController.h"

@implementation STViewController

- (void)dealloc
{
    NSLog(@"destroy controller  %@", self);
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"memory Warning %@", self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
