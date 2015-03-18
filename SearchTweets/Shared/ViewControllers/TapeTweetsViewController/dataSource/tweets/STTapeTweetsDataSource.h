//
//  STTapeTweetsDataSource.h
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STTweetsAPIProtocol.h"
#import "STImageDownloaderProtocol.h"
#import "STDataBaseStrorageProtocol.h"
#import "STAvatarManager.h"

@class STRequestManager;
@class STTweetsNibLoader;
@protocol STTapeTweetsDataSourceDelegate;


@interface STTapeTweetsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    STTweetsNibLoader *_nibLoader;
}

- (instancetype)initWithAvatarManager :(STAvatarManager *)avatarManager;
- (void)setupWithTweets:(NSArray *)tweets;

@end