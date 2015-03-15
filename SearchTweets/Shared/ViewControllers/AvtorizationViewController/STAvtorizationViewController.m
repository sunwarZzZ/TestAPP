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
#import "STAPIConstans.h"
#import "STSegueID.h"

@interface STAvtorizationViewController()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIView *progressView;

@property (nonatomic, weak) IBOutlet UIButton *avtorizationButton;
@property (nonatomic, weak) IBOutlet UILabel *textInfoLabel;

@property (nonatomic, strong) STRequestManager *requestManager;

@end

@implementation STAvtorizationViewController


#pragma mark - ViewController methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _requestManager = [STRequestManager new];
        self.title = STLocalizedString(@"Avtorization");
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
}

#pragma mark - IBActions
- (IBAction)avtorizationButtonPressed:(UIButton *)button
{
    [self p_showProgress];
    [self p_requestAvtorization];
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self p_showProgress];
    if([self p_isAvtorizationRequest:request])
    {
        [self.requestManager requestAccessTokenWithOAuthVerifier:[self p_oauthVerifierFromRequest:request]
                                                      completion:^(BOOL sucess, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self p_hideProgress];
                [self p_hideWebView];
                
                if(sucess)
                {
                    [self.navigationController performSegueWithIdentifier:kPresentRootControllerSegue sender:self];
                }
                else
                {
                    [self p_showAlertFailRequestAvtorization];
                }
            });
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
    [self p_showWebView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}


#pragma mark - private methods
- (void)p_setupUI
{
    [self p_hideProgress];
    [self p_hideWebView];
    
    self.textInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25];
    self.textInfoLabel.textColor = [UIColor whiteColor];
    self.textInfoLabel.text = STLocalizedString(@"Avtorization");
    
    [self.avtorizationButton setTitle:STLocalizedString(@"Login") forState:UIControlStateNormal];
    self.avtorizationButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.avtorizationButton.layer.borderWidth = 1;
    self.avtorizationButton.layer.cornerRadius = 5;
    [self.avtorizationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.avtorizationButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)p_requestAvtorization
{
    [self.requestManager requestAvtorizationToken:^(NSURLRequest *const requestToken, NSError *const error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error == nil)
            {
                [self.webView loadRequest:requestToken];
            }
            else
            {
                [self p_showAlertFailRequestAvtorization];
            }
        });
    }];
}

- (void)p_showAlertFailRequestAvtorization
{
    RIButtonItem *okButton = [RIButtonItem itemWithLabel:@"Ok" action:^
    {
        [self p_showProgress];
        [self p_requestAvtorization];
    }];
    
    [[[UIAlertView alloc] initWithTitle:STLocalizedString(@"Warning") message:STLocalizedString(@"FailRequestAvtorization") cancelButtonItem:okButton otherButtonItems:nil]show];
}


- (BOOL)p_isAvtorizationRequest:(NSURLRequest *)request
{
    NSString *requestText = [NSString stringWithFormat:@"%@",request];
    NSRange textRange = [[requestText lowercaseString] rangeOfString:[kCallbackURL lowercaseString]];
    return textRange.location != NSNotFound ? YES : NO;
}

- (NSString *)p_oauthVerifierFromRequest:(NSURLRequest *)request
{
    NSString *oauthVerifer = nil;
    NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
    for (NSString *param in urlParams)
    {
        NSArray *keyValue = [param componentsSeparatedByString:@"="];
        NSString *key = [keyValue firstObject];
        
        if ([key isEqualToString:kOauthVeriferKey] && keyValue.count > 1)
        {
            oauthVerifer = [keyValue objectAtIndex:1];
            break;
        }
    }
    return oauthVerifer;
}

- (void)p_hideProgress
{
    self.progressView.hidden = YES;
}

- (void)p_showProgress
{
    self.progressView.hidden = NO;
}

- (void)p_showWebView
{
    self.webView.hidden = NO;
}

- (void)p_hideWebView
{
    self.webView.hidden = YES;
}

@end
