//
//  STLocator.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDataBaseStrorageProtocol.h"
#import "STImageDownloaderProtocol.h"
#import "STFileManagerProtocol.h"
#import "STAvtorizationManagerProtocol.h"
#import "STTweetsAPIProtocol.h"

@interface STLocator : NSObject

- (id<STDataBaseStrorageProtocol> const)dataBaseStorage;
- (id<STImageDownloaderProtocol> const)imageDownloader;
- (id<STFileManagerProtocol> const)fileManager;
- (id<STAvtorizationManagerProtocol> const)avtorizationManager;
- (id<STTweetsAPIProtocol> const)tweetsAPI;

@end
