//
//  STAvatarManager.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/18/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STAvatarManager.h"
#import "STUser.h"

@interface STAvatarManager()

@property (nonatomic, strong) NSCache *avatars;
@property (nonatomic, weak) id<STImageDownloaderProtocol>imageDownloader;
@property (nonatomic, weak) id<STFileManagerProtocol>fileManager;
@property (nonatomic, assign) BOOL enableCache;


@end

@implementation STAvatarManager

- (instancetype)initWithImageDownloader:(id<STImageDownloaderProtocol>)imageDownloader
                            fileManager:(id<STFileManagerProtocol>)fileManager
{
    if(self = [super init])
    {
        _imageDownloader = imageDownloader;
        _fileManager = fileManager;
        _avatars = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - public methods
- (void)avatarWithUser:(STUser *)user
            completion:(void(^)(UIImage *avatar))completion;
{
    [self p_avatarForUserId:user.userId completion:^(UIImage *avatar) {
        if(avatar)
        {
            completion(avatar);
        }
        else
        {
            [self.imageDownloader requestAvatarWithStringURL:user.avatarURLString completion:^(UIImage *avatar, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self p_setAvatar:avatar userId:user.userId];
                    if(error)
                    {
                        NSLog(@"load avatar error!!");
                    }
                    completion(avatar);
                });
            }];
        }
    }];
}

- (void)setupEnableCache:(BOOL)enable
{
    self.enableCache = enable;
}

#pragma mark - private methods
- (void)p_avatarForUserId:(long long)userId completion:(void(^)(UIImage *avatar))completion
{
    __block UIImage *avatar = [self.avatars objectForKey:[NSNumber numberWithLongLong:userId]];
    if(avatar == nil && self.enableCache)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            avatar = [UIImage imageWithContentsOfFile:[self p_avatarPathForUserId:userId]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(avatar)
                {
                    [self.avatars setObject:avatar forKey:[NSNumber numberWithLongLong:userId]];
                }
                completion(avatar);
            });
        });
    }
    else
    {
        completion(avatar);
    }
}

- (void)p_setAvatar:(UIImage *)image userId:(long long)userId
{
    [self.avatars setObject:image forKey:[NSNumber numberWithLongLong:userId]];
    
    if(self.enableCache)
    {
        NSString *avatarPath = [self p_avatarPathForUserId:userId];
        if([self.fileManager fileExistsAtPath: avatarPath] == NO)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [UIImagePNGRepresentation(image) writeToFile:avatarPath atomically:YES];
            });
        }
    }
}

-(NSString*)p_avatarPathForUserId:(long long)userId
{
    NSString *avatarName = [self p_avatarNameForUserId:userId];
    return [[self.fileManager avatarsDirectory] stringByAppendingPathComponent:avatarName];
}

-(NSString *)p_avatarNameForUserId:(long long)userId
{
    return [NSString stringWithFormat:@"user_%lld.png", userId];
}



@end
