//
//  AvtorizationViewController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STAvtorizationViewController.h"

@interface STAvtorizationViewController()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation STAvtorizationViewController


#pragma mark - ViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupUI];
}

#pragma mark - IBActions
- (IBAction)leftBarButtonPressed:(UIBarButtonItem *)leftBarButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonPressed:)];
}

@end
