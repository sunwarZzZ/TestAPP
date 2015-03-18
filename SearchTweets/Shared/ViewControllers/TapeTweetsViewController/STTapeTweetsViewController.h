//
//  STTweetListViewController.h
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STViewController.h"
#import "STTapeTweetsDataSource.h"
#import "STSearchDataSource.h"
#import "STAvatarManagerProtocol.h"
#import "STSettingsManagerProtocol.h"

@interface STTapeTweetsViewController : STViewController
{
    STTapeTweetsDataSource *_tapeTweetsDataSource;
    STSearchDataSource *_searchDataSource;
    id<STAvatarManagerProtocol> _avatarManager;
}

- (void)setupWithAvatarManager:(id<STAvatarManagerProtocol>)avatarManager;
- (void)setupWithTweetsAPI:(id<STTweetsAPIProtocol>)tweetsAPI;
- (void)setupWithDataBaseStorage:(id<STDataBaseStrorageProtocol>)dataBaseStorage;
- (void)setupWithSettingsManager:(id<STSettingsManagerProtocol>)settingsManager;

@end
