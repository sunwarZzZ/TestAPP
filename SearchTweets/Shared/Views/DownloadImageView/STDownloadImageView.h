//
//  STDownloadImageView.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STImageDownloaderProtocol.h"

@interface STDownloadImageView : UIImageView

- (void)setupImageDownloader:(id<STImageDownloaderProtocol>)imageDownloader;
- (void)requestImageWithURLString:(NSString *)URLString;

@end
