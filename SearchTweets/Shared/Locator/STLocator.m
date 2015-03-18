//
//  STLocator.m
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STLocator.h"
#import "STFileManager.h"
#import "STRequestManager.h"
#import "STDataBaseStorage.h"
#import "STAvatarManager.h"
#import "STSettingsManager.h"

@interface STLocator()
{
    STFileManager     *_fileManager;
    STRequestManager  *_requestManager;
    STDataBaseStorage *_dataBaseStorage;
    STAvatarManager   *_avatarManager;
    STSettingsManager *_settingsManager;
}

@end

@implementation STLocator

- (id<STDataBaseStrorageProtocol> const)dataBaseStorage
{
    if(_dataBaseStorage == nil)
    {
        _dataBaseStorage = [[STDataBaseStorage alloc] initWithFileManager:[self fileManager]];
    }
    
    return _dataBaseStorage;
}

- (id<STImageDownloaderProtocol> const)imageDownloader
{
    return [self p_requestManager];
}

- (id<STFileManagerProtocol> const)fileManager
{
    if(_fileManager == nil)
    {
        _fileManager = [[STFileManager alloc] init];
    }
    return _fileManager;
}

- (id<STAvtorizationManagerProtocol> const)avtorizationManager
{
    return [self p_requestManager];
}

- (id<STTweetsAPIProtocol> const)tweetsAPI
{
   return [self p_requestManager];
}

- (id<STAvatarManagerProtocol> const)avatarManager
{
    if(_avatarManager == nil)
    {
        _avatarManager = [[STAvatarManager alloc] initWithImageDownloader:[self imageDownloader] fileManager:[self fileManager]];
    }
    return _avatarManager;
}

- (id<STSettingsManagerProtocol> const)settingsManager
{
    if(_settingsManager == nil)
    {
        _settingsManager = [[STSettingsManager alloc] init];
    }
    return _settingsManager;
}

#pragma mark - private methods
- (STRequestManager *)p_requestManager
{
    if(_requestManager == nil)
    {
        _requestManager = [[STRequestManager alloc] init];
    }
    return _requestManager;
}

@end
