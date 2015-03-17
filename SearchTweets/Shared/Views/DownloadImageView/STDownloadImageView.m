//
//  STDownloadImageView.m
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STDownloadImageView.h"

@interface STDownloadImageView()

@property (nonatomic, weak) id<STImageDownloaderProtocol> imageDownloader;

@end

@implementation STDownloadImageView


#pragma mark - public methods
- (void)setupImageDownloader:(id<STImageDownloaderProtocol>)imageDownloader
{
    self.imageDownloader = imageDownloader;
}

- (void)requestImageWithURLString:(NSString *)URLString completion:(void(^)(UIImage *image))completion
{
    if(self.imageDownloader && URLString)
    {
        self.alpha = 0;
        [self.imageDownloader requestAvatarWithStringURL:URLString completion:^(UIImage *avatar, NSError *error) {
            if(avatar && error == nil)
            {
                completion(avatar);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = avatar;
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        self.alpha = 1;
                    }];
                });
            }
        }];
    }
}

@end
