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
#import "STUser.h"
#import "STTweet.h"

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
        _consumer =  [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecretKey];
    }
    return self;
}

#pragma mark - public methods
+ (BOOL)isAvtorization
{
    return [STTokenStorage key] && [STTokenStorage privateKey] ? YES : NO;
}

- (void)requestTweetsCount:(int)count
                    offset:(int)offset
                completion:(void(^)(NSArray *array, NSError *error))completion
{
    OAMutableURLRequest *request = [self p_createURLrequestTweetsCount:count offset:offset];
    [[self.webCore createTaskJSONWithRequest:request completion:^(id JSON, NSError *error)
     {
         NSArray *tweets = nil;
         if(JSON)
         {
             tweets = [self p_parseTweetsFromJSON:JSON];
         }
         completion(tweets, error);
         
     }] resume];
}


- (void)requestAvtorizationToken:(void (^)(NSURLRequest *const, NSError *const))comletion
{
    OAMutableURLRequest *requestToken = [self p_createURLrequestAvtorizationToken];
    [[self.webCore createTaskStringBodyWithRequest:requestToken completion:^(NSString *body, NSError *error)
      {
          if(body)
          {
              OAMutableURLRequest* authorizeRequest = [self p_createURLrequestAvtorizationWithBody:body];
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

    OAMutableURLRequest* accessTokenRequest = [self p_createURLrequestAccessTokenVerifier:verifier];
    
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
#pragma mark create request methods
- (OAMutableURLRequest *)p_createURLrequestAvtorizationToken
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

- (OAMutableURLRequest *)p_createURLrequestAccessTokenVerifier:(NSString *)verifier
{
    NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:self.consumer token:self.requestToken realm:nil signatureProvider:nil];
    OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
    [accessTokenRequest setHTTPMethod:@"POST"];
    accessTokenRequest.oa_parameters = [NSArray arrayWithObject:verifierParam];
    return accessTokenRequest;
}

- (OAMutableURLRequest *)p_createURLrequestAvtorizationWithBody:(NSString *)body
{
    self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:body];
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

- (OAMutableURLRequest *)p_createURLrequestTweetsCount:(int)count
                                                offset:(int)offset
{
    NSURL *url = [NSURL URLWithString: [kBaseURLStringAPI_1_1 stringByAppendingString:kHomeTimeline]];
    OAToken *token = [[OAToken alloc] initWithKey:[STTokenStorage key] secret:[STTokenStorage privateKey]];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:self.consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    OARequestParameter *countParamater = [[OARequestParameter alloc] initWithName:@"count" value:@"100"];
    request.oa_parameters = [NSArray arrayWithObject:countParamater];
    
    [request setHTTPMethod:@"GET"];
    
    return request;
}

#pragma mark JSON parser methods
- (NSArray *)p_parseTweetsFromJSON:(id)json
{
    NSMutableArray *tweets;
    
    if([json isKindOfClass:[NSArray class]])
    {
        tweets = [NSMutableArray new];
        
        for(NSDictionary *dictionary in json)
        {
            STUser *user = [self p_userFromDictionary:[dictionary objectForKey:@"user"]];
            if(user)
            {
                STTweet *tweet = [STTweet new];
                tweet.user = user;
                NSString *text = [dictionary objectForKey:@"text"];
                
                if([text isEqual:[NSNull null]] == NO)
                {
                    tweet.text = text;
                }
                [tweets addObject:tweet];
            }
        }
    }
    
    return tweets;
}

- (STUser *)p_userFromDictionary:(NSDictionary *)dictionary
{
    STUser *user = nil;
    
    if(dictionary)
    {
        long userId = [[dictionary objectForKey:@"id"] longValue];
        NSString *name = [dictionary objectForKey:@"name"];
        NSString *description = [dictionary objectForKey:@"description"];
        NSString *imageURLString = [dictionary objectForKey:@"profile_image_url"];
        
        if(name && [name isEqual:[NSNull null]] == NO)
        {
            user = [STUser new];
            user.userId = userId;
            user.name = name;
            
            if([description isEqual:[NSNull null]] == NO)
            {
                user.descriptionText = description;
            }
            
            if([imageURLString isEqual:[NSNull null]] == NO)
            {
                user.avatarURLString = imageURLString;
            }
        }
    }
    
    return user;
}


@end
