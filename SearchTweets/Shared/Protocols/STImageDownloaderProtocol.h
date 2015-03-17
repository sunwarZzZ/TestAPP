//
//  STImageDownloaderProtocol.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STImageDownloaderProtocol <NSObject>

- (void)requestAvatarWithStringURL:(NSString *)stringURL
                        completion:(void(^)(UIImage *avatar, NSError *error))completion;

@end
