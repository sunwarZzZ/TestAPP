//
//  STServerAPIConstans.h
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#ifndef SearchTweets_STAPIConstans_h
#define SearchTweets_STAPIConstans_h

static NSString *const kConsumerKey = @"C53gFbMswkpfUgZ07EdU2N5wg";
static NSString *const kConsumerSecretKey = @"mwusu3Fb9P68Uccy46MexcQnVeZkMIpJ0PSNcwCrnldrjGB1oL";

static NSString *const kTokenURLString = @"https://api.twitter.com/oauth/request_token";
static NSString *const kAuthorizationURLString = @"https://api.twitter.com/oauth/authorize";
static NSString *const kCallbackURL = @"http://codegerms.com/callback";
static NSString *const kAccessTokenURLString = @"https://api.twitter.com/oauth/access_token";


static NSString *const kBaseURLStringAPI_1_1 = @"https://api.twitter.com/1.1";
static NSString *const kBaseURLStringUpload_1_1 = @"https://upload.twitter.com/1.1";
static NSString *const kBaseURLStringStream_1_1 = @"https://stream.twitter.com/1.1";
static NSString *const kBaseURLStringUserStream_1_1 = @"https://userstream.twitter.com/1.1";
static NSString *const kBaseURLStringSiteStream_1_1 = @"https://sitestream.twitter.com/1.1";

static NSString *const kHomeTimeline = @"/statuses/home_timeline.json";
static NSString *const kSearchTweets = @"/search/tweets.json";


static NSString *const kOauthTokenKey = @"oauth_token";
static NSString *const kOauthCallbackKey = @"oauth_callback";
static NSString *const kOauthVeriferKey = @"oauth_verifier";
static NSString *const kUserKey = @"user";
static NSString *const kTextKey = @"text";
static NSString *const kIdKey = @"id";
static NSString *const kCreatedKey = @"created_at";
static NSString *const kStatusesKey = @"statuses";
static NSString *const kDescriptionKey = @"description";
static NSString *const kNameKey = @"name";
static NSString *const kProfileImageUrlKey = @"profile_image_url";
static NSString *const kCountKey = @"count";
static NSString *const kSearchKey = @"q";




#endif
