//
//  AvtorizationViewController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STAvtorizationViewController.h"
#import "OAuthConsumer.h"
#import "NSMutableURLRequest+Parameters.h"

static NSString *const CONSUMER_KEY = @"C53gFbMswkpfUgZ07EdU2N5wg";
static NSString *const CONSUMER_SECRET_KEY = @"mwusu3Fb9P68Uccy46MexcQnVeZkMIpJ0PSNcwCrnldrjGB1oL";

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
    
    self.consumer =  [[OAConsumer alloc] initWithKey:CONSUMER_KEY secret:CONSUMER_SECRET_KEY];
    NSURL *requestTokenURL = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                                                               consumer:self.consumer
                                                                                  token:nil
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    
    [requestTokenRequest setHTTPMethod:@"POST"];
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
    authorizeRequest.oa_parameters = [NSArray arrayWithObject:oauthTokenParam];

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
