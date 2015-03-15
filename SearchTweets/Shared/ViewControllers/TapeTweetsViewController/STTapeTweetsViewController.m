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
    [self.requestManager requestTweetsCount:100 offset:0 completion:^(NSArray *array, NSError *error) {
        NSLog(@"123");
    }];
    
}


@end
