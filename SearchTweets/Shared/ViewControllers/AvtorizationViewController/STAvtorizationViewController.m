//
//  AvtorizationViewController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STAvtorizationViewController.h"
#import "OAuthConsumer.h"

static NSString *const CLIENT_ID = @"C53gFbMswkpfUgZ07EdU2N5wg";
static NSString *const SECRET_KEY = @"mwusu3Fb9P68Uccy46MexcQnVeZkMIpJ0PSNcwCrnldrjGB1oL";
static NSString *const CALLBACK_URL = @"http://codegerms.com/callback";

@interface STAvtorizationViewController()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, strong) OAConsumer *consumer;
@property (nonatomic, strong) OAToken *requestToken;
@property (nonatomic, strong) OAToken *accessToken;

@end

@implementation STAvtorizationViewController


#pragma mark - ViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupUI];
    
    self.consumer =  [[OAConsumer alloc] initWithKey:CLIENT_ID secret:SECRET_KEY callbackURL:CALLBACK_URL];
    NSURL *requestTokenURL = [NSURL URLWithString:@"https:api.twitter.com/oauth/request_token"];
    OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                                                               consumer:self.consumer
                                                                                  token:nil
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    
    OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:CALLBACK_URL];
    [requestTokenRequest setHTTPMethod:@"POST"];
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
   
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:requestTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
    
    
}

#pragma mark - IBActions
- (IBAction)leftBarButtonPressed:(UIBarButtonItem *)leftBarButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OADataFetcher handler

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = self.requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    [self.webView loadRequest:authorizeRequest];
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError *)error
{
    NSLog(@"%@", error);
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBarButtonPressed:)];
}

@end
