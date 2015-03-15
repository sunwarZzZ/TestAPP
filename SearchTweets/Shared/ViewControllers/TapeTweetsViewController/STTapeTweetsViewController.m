//
//  STTweetListViewController.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsViewController.h"
#import "STRequestManager.h"

@interface STTapeTweetsViewController ()

@property (nonatomic, strong) STRequestManager *requestManager;

@end

@implementation STTapeTweetsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.requestManager = [[STRequestManager alloc]init];
    [self.requestManager requestTapeTweets];
    
}


@end
