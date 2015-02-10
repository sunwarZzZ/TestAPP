//
//  AvtorizationViewController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STAvtorizationViewController.h"
#import "STRequestManager.h"
#import "UIAlertView+Blocks.h"
#import "STUtilsServerAPI.h"

@interface STAvtorizationViewController()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIView *progressView;

@property (nonatomic, strong) STRequestManager *requestManager;

@end

@implementation STAvtorizationViewController


#pragma mark - ViewController methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _requestManager = [STRequestManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView.delegate = self;
    [self p_setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self p_requestAvtorization];
}

#pragma mark - IBActions
- (IBAction)leftBarButtonPressed:(UIBarButtonItem *)leftBarButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    typeof(self) __weak weakSelf = self;
    if([STUtilsServerAPI isAvtorizationRequest:request])
    {
        [self p_showProgress];
        [self.requestManager requestAccessTokenWithOAuthVerifier:[STUtilsServerAPI oauthVerifierFromRequest:request]
                                                      completion:^(NSString *const accessToken, NSString *const accessTokenSecret, NSError *const error) {
            
            [weakSelf p_hideProgress];
            [weakSelf.webView removeFromSuperview];
                                                          
            if(error == nil && accessToken && accessTokenSecret)
            {
                [STUtilsServerAPI saveAccessToken:accessToken];
                [STUtilsServerAPI saveAccessTokenSecret:accessTokenSecret];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [weakSelf p_showAlertFailRequestAvtorization];
            }
        }];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self p_hideProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}


#pragma mark - private methods
- (void)p_setupUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonPressed:)];
}

- (void)p_requestAvtorization
{
    typeof(self) __weak weakSelf = self;
    [self.requestManager requestAvtorizationToken:^(NSURLRequest *const requestToken, NSError *const error)
    {
        if(error == nil)
        {
            [weakSelf.webView loadRequest:requestToken];
        }
        else
        {
            [self p_showAlertFailRequestAvtorization];
        }
    }];
}

- (void)p_showAlertFailRequestAvtorization
{
    RIButtonItem *okButton = [RIButtonItem itemWithLabel:@"Ok" action:^
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    [[[UIAlertView alloc] initWithTitle:STLocalizedString(@"Warning") message:STLocalizedString(@"FailRequestAvtorization") cancelButtonItem:okButton otherButtonItems:nil]show];
}

- (void)p_hideProgress
{
    self.progressView.hidden = YES;
}

- (void)p_showProgress
{
    self.progressView.hidden = NO;
}


@end
