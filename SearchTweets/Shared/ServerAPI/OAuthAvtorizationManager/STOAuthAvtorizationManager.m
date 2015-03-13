//
//  STRequestManager.m
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STOAuthAvtorizationManager.h"
#import "OAuthConsumer.h"
#import "STAPIConstans.h"
#import "SSKeychain.h"
#import "STAccountManager.h"

@interface STOAuthAvtorizationManager()

@property (nonatomic, copy) void(^requestAvtorizationTokenComletion)(NSURLRequest *const, NSError *const);
@property (nonatomic, copy) void(^requestAccessTokenComletion)(BOOL success);

@property (nonatomic, strong) OAConsumer *consumer;
@property (nonatomic, strong) OAToken *requestToken;

@end

@implementation STOAuthAvtorizationManager

+ (BOOL)isAvtorization
{
    return [STAccountManager tokenPublicKey] && [STAccountManager tokenPrivateKey] ? YES : NO;
}

- (void)requestAvtorizationToken:(void (^)(NSURLRequest *const, NSError *const))comletion
{
    self.requestAvtorizationTokenComletion = comletion;
    
    self.consumer =  [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecretKey];
    NSURL *requestTokenURL = [NSURL URLWithString:kRequestTokenURLString];
    
    OARequestParameter* requestParametrs = [[OARequestParameter alloc] initWithName:kOauthCallbackKey value:kCallbackURL];
    OAMutableURLRequest *requestToken = [[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                                                        consumer:self.consumer
                                                                           token:nil
                                                                           realm:nil
                                                               signatureProvider:nil];
 
    requestToken.oa_parameters = [NSArray arrayWithObject:requestParametrs];
    
    [requestToken setHTTPMethod:@"POST"];
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:requestToken
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
}

- (void)requestAccessTokenWithOAuthVerifier:(NSString *)verifier
                                 completion:(void(^)(BOOL success))completion;
{
    self.requestAccessTokenComletion = completion;
    
    NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:self.consumer token:self.requestToken realm:nil signatureProvider:nil];
    OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
    [accessTokenRequest setHTTPMethod:@"POST"];
    accessTokenRequest.oa_parameters = [NSArray arrayWithObject:verifierParam];
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:accessTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveAccessToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
}

#pragma mark - OADataFetcher handler
- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data
{
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:kAuthorizationURLString];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = self.requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    authorizeRequest.oa_parameters = [NSArray arrayWithObject:oauthTokenParam];
    
    if(self.requestAvtorizationTokenComletion != nil)
    {
        self.requestAvtorizationTokenComletion(authorizeRequest, nil);
        self.requestAvtorizationTokenComletion = nil;
    }
}

- (void)didReceiveAccessToken:(OAServiceTicket *)ticket data:(NSData *)data
{
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    if(self.requestAccessTokenComletion)
    {
        if(accessToken)
        {
            [STAccountManager saveTokenPrivateKey:accessToken.secret];
            [STAccountManager saveTokenPublicKey:accessToken.key];
            self.requestAccessTokenComletion(YES);
        }
        else
        {
            self.requestAccessTokenComletion(NO);
        }
        self.requestAccessTokenComletion = nil;
    }
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError *)error
{
    if(self.requestAvtorizationTokenComletion != nil)
    {
        self.requestAvtorizationTokenComletion(nil, error);
        self.requestAvtorizationTokenComletion = nil;
    }
    
    if(self.requestAccessTokenComletion  != nil)
    {
        self.requestAccessTokenComletion (NO);
        self.requestAccessTokenComletion = nil;
    }
}


@end
