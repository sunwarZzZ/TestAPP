//
//  STRequestManager.m
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STRequestManager.h"
#import "OAuthConsumer.h"
#import "STAPIConstans.h"
#import "SSKeychain.h"
#import "STTokenStorage.h"
#import "STWebCore.h"

@interface STRequestManager()

@property (nonatomic, strong) STWebCore *webCore;
@property (nonatomic, strong) OAConsumer *consumer;
@property (nonatomic, strong) OAToken *requestToken;


@end

@implementation STRequestManager

- (instancetype)init
{
    if(self = [super init])
    {
        _webCore = [[STWebCore alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}


+ (BOOL)isAvtorization
{
    return [STTokenStorage key] && [STTokenStorage privateKey] ? YES : NO;
}

- (void)requestTapeTweets
{
    self.consumer =  [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecretKey];
    OAToken *token = [[OAToken alloc] initWithKey:[STTokenStorage key] secret:[STTokenStorage privateKey]];
    NSURL *url = [NSURL URLWithString: [kBaseURLStringAPI_1_1 stringByAppendingString:kHomeTimeline]];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                        consumer:self.consumer
                                                                           token:token
                                                                           realm:nil
                                                               signatureProvider:nil];

    
    [request setHTTPMethod:@"GET"];
    
    [[self.webCore createTaskJSONWithRequest:request completion:^(id JSON, NSError *error)
     {
         NSLog(@"123");
     }] resume];
}


- (void)requestAvtorizationToken:(void (^)(NSURLRequest *const, NSError *const))comletion
{
    self.consumer =  [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecretKey];
    OAMutableURLRequest *requestToken = [self p_requestAvtorizationToken];
    
    [[self.webCore createTaskStringBodyWithRequest:requestToken completion:^(NSString *body, NSError *error)
      {
          if(body)
          {
              self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:body];
              OAMutableURLRequest* authorizeRequest = [self p_requestAvtorization];
              comletion(authorizeRequest, nil);
          }
          else
          {
              comletion(nil, error);
          }
          
      }] resume];
}

- (void)requestAccessTokenWithOAuthVerifier:(NSString *)verifier
                                 completion:(void(^)(BOOL success, NSError *error))completion;
{

    OAMutableURLRequest* accessTokenRequest = [self p_requestAccessTokenVerifier:verifier];
    
    [[self.webCore createTaskStringBodyWithRequest:accessTokenRequest completion:^(NSString *body, NSError *error)
      {
          if(body)
          {
              OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:body];
              if(accessToken)
              {
                  [STTokenStorage savePrivateKey:accessToken.secret];
                  [STTokenStorage saveKey:accessToken.key];
                  completion(YES, nil);
              }
          }
          else
          {
              completion(NO, error);
          }
      }] resume];
}

#pragma mark - private methods
- (OAMutableURLRequest *)p_requestAvtorizationToken
{
    NSURL *requestTokenURL = [NSURL URLWithString:kRequestTokenURLString];
    
    OARequestParameter* requestParametrs = [[OARequestParameter alloc] initWithName:kOauthCallbackKey value:kCallbackURL];
    OAMutableURLRequest *requestAvtorization = [[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                                                               consumer:self.consumer
                                                                                  token:nil
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    
    requestAvtorization.oa_parameters = [NSArray arrayWithObject:requestParametrs];
    
    [requestAvtorization setHTTPMethod:@"POST"];
    return requestAvtorization;
}

- (OAMutableURLRequest *)p_requestAccessTokenVerifier:(NSString *)verifier
{
    NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:self.consumer token:self.requestToken realm:nil signatureProvider:nil];
    OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
    [accessTokenRequest setHTTPMethod:@"POST"];
    accessTokenRequest.oa_parameters = [NSArray arrayWithObject:verifierParam];
    return accessTokenRequest;
}

- (OAMutableURLRequest *)p_requestAvtorization
{
    NSURL* authorizeUrl = [NSURL URLWithString:kAuthorizationURLString];
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = self.requestToken.key;
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
    authorizeRequest.oa_parameters = [NSArray arrayWithObject:oauthTokenParam];
    return authorizeRequest;
}



@end
