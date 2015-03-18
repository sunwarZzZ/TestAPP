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

@property (nonatomic, strong) NSDateFormatter *dateFormater;

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation STRequestManager

- (instancetype)init
{
    if(self = [super init])
    {
        _webCore = [[STWebCore alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _consumer =  [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecretKey];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        
        _dateFormater = [NSDateFormatter new];
        [_dateFormater setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    }
    return self;
}

#pragma mark - STAvtorizationManagerProtocol
+ (BOOL)isAvtorization
{
    return [STTokenStorage key] && [STTokenStorage privateKey] ? YES : NO;
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

#pragma mark - STImageDownloaderProtocol
- (void)requestAvatarWithStringURL:(NSString *)stringURL
                        completion:(void(^)(UIImage *avatar, NSError *error))completion;
{
    OAMutableURLRequest *request = [self p_createURLRequestAvatarWithStringURL:stringURL];
    [[self.webCore createTaskImageWithRequest:request comletion:^(UIImage *image, NSError *error) {
        
        UIImage *avatar = nil;
        if(image && error == nil)
        {
            avatar = image;
        }
        completion(avatar, error);
        
    }] resume];
}

- (void)requestTweetsCount:(int)count
                completion:(void(^)(NSArray *array, NSError *error))completion
{
    OAMutableURLRequest *request = [self p_createURLrequestTweetsCount:count];
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
- (void)requestSearchTweetsWithText:(NSString *)text
                         completion:(void(^)(NSArray *tweets, NSError *error))completion;
{
    [self.queue cancelAllOperations];
    OAMutableURLRequest *request = [self p_createURLRequestSearchWithString:text];
    [self.queue addOperationWithBlock:^{
        [[self.webCore createTaskJSONWithRequest:request completion:^(id JSON, NSError *error)
          {
              NSArray *tweets = nil;
              if(JSON)
              {
                  tweets = [self p_parseSearchTweetsFromJSON:JSON];
              }
              completion(tweets, error);
              
          }] resume];
    }];
}
#pragma mark - private methods
#pragma mark create request methods
- (OAMutableURLRequest *)p_createURLrequestAvtorizationToken
{
    NSURL *requestTokenURL = [NSURL URLWithString:kTokenURLString];
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
    NSURL* accessTokenUrl = [NSURL URLWithString:kAccessTokenURLString];
    OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:self.consumer token:self.requestToken realm:nil signatureProvider:nil];
    OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:kOauthVeriferKey value:verifier];
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
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:kOauthTokenKey value:oauthToken];
    authorizeRequest.oa_parameters = [NSArray arrayWithObject:oauthTokenParam];
    return authorizeRequest;
}

- (OAMutableURLRequest *)p_createURLrequestTweetsCount:(int)count
{
    NSURL *url = [NSURL URLWithString: [kBaseURLStringAPI_1_1 stringByAppendingString:kHomeTimeline]];
    OAToken *token = [[OAToken alloc] initWithKey:[STTokenStorage key] secret:[STTokenStorage privateKey]];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:self.consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    OARequestParameter *countParamater = [[OARequestParameter alloc] initWithName:kCountKey value:[NSString stringWithFormat:@"%d",count]];
    request.oa_parameters = [NSArray arrayWithObjects:countParamater, nil];
    
    [request setHTTPMethod:@"GET"];
    
    return request;
}

- (OAMutableURLRequest *)p_createURLRequestAvatarWithStringURL:(NSString *)stringURL
{
    NSURL *url = [NSURL URLWithString: stringURL];
    OAToken *token = [[OAToken alloc] initWithKey:[STTokenStorage key] secret:[STTokenStorage privateKey]];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:self.consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    [request setHTTPMethod:@"GET"];
    
    return request;

}

- (OAMutableURLRequest *)p_createURLRequestSearchWithString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:[kBaseURLStringAPI_1_1 stringByAppendingString:kSearchTweets]];
    OAToken *token = [[OAToken alloc] initWithKey:[STTokenStorage key] secret:[STTokenStorage privateKey]];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:self.consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    OARequestParameter *countParamater = [[OARequestParameter alloc] initWithName:kSearchKey value:string];
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
            STUser *user = [self p_userFromDictionary:[dictionary objectForKey:kUserKey]];
            if(user)
            {
                STTweet *tweet = [STTweet new];
                tweet.user = user;
                NSString *text = [dictionary objectForKey:kTextKey];
                NSNumber *tweetID = [dictionary objectForKey:kIdKey];
                NSString *dateCreatedString = [dictionary objectForKey:kCreatedKey];
                NSDate *dateCreated = [self.dateFormater dateFromString:dateCreatedString];
                
                
                if(text && [text isEqual:[NSNull null]] == NO)
                {
                    tweet.text = text;
                }
                
                if(tweetID && [tweetID isEqual:[NSNull null]] == NO)
                {
                    tweet.tweetId = [tweetID longLongValue];
                }
                
                if(dateCreated && [dateCreated isEqual:[NSNull null]] == NO)
                {
                    tweet.dateCreated = [dateCreated timeIntervalSince1970];
                }
                
                [tweets addObject:tweet];
            }
        }
    }
    
    return tweets;
}

- (NSArray *)p_parseSearchTweetsFromJSON:(id)json
{
    NSMutableArray *tweets;
    
    if([json isKindOfClass:[NSDictionary class]])
    {
        tweets = [NSMutableArray new];
        NSArray *statuses = [json objectForKey:kStatusesKey];
        
        for(NSDictionary *dictionary in statuses)
        {
            STUser *user = [self p_userFromDictionary:[dictionary objectForKey:kUserKey]];
            if(user)
            {
                STTweet *tweet = [STTweet new];
                tweet.user = user;
                NSString *text = [dictionary objectForKey:kTextKey];
                NSNumber *tweetID = [dictionary objectForKey:kIdKey];
                NSString *dateCreatedString = [dictionary objectForKey:kCreatedKey];
                NSDate *dateCreated = [self.dateFormater dateFromString:dateCreatedString];
                
                if(text && [text isEqual:[NSNull null]] == NO)
                {
                    tweet.text = text;
                }
                
                if(tweetID && [tweetID isEqual:[NSNull null]] == NO)
                {
                    tweet.tweetId = [tweetID longLongValue];
                }
                
                if(dateCreated && [dateCreated isEqual:[NSNull null]] == NO)
                {
                    tweet.dateCreated = [dateCreated timeIntervalSince1970];;
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
        long long userId = [[dictionary objectForKey:kIdKey] longLongValue];
        NSString *name = [dictionary objectForKey:kNameKey];
        NSString *description = [dictionary objectForKey:kDescriptionKey];
        NSString *imageURLString = [dictionary objectForKey:kProfileImageUrlKey];
        
        if(name && [name isEqual:[NSNull null]] == NO)
        {
            user = [STUser new];
            user.userId = userId;
            user.name = name;
            
            if(description && [description isEqual:[NSNull null]] == NO)
            {
                user.descriptionText = description;
            }
            
            if(imageURLString && [imageURLString isEqual:[NSNull null]] == NO)
            {
                user.avatarURLString = imageURLString;
            }
        }
    }
    
    return user;
}


@end
