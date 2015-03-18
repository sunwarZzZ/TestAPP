//
//  STAvatarManagerProtocol.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/18/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STImageDownloaderProtocol.h"
#import "STFileManagerProtocol.h"

@class STUser;

@protocol STAvatarManagerProtocol <NSObject>

- (instancetype)initWithImageDownloader:(id<STImageDownloaderProtocol>)imageDownloader
                            fileManager:(id<STFileManagerProtocol>)fileManager;

- (void)avatarWithUser:(STUser *)user
              completion:(void(^)(UIImage *avatar))completion;
- (void)setupEnableCache:(BOOL)enable;

@end
