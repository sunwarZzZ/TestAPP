//
//  STFileManager.m
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STFileManager.h"

static NSString * const kNameWorkingDirectory = @"MTT";
static NSString * const kNameDataBaseDirectory = @"DataBase";
static NSString * const kNameAvatarDirectory = @"Avatars";

@interface STFileManager()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation STFileManager

- (instancetype)init
{
    if(self = [super init])
    {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)libaryDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)cashDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)tempDirectory
{
    return NSTemporaryDirectory();
}

- (NSString *)workingDirectory
{
    NSString *workingDirectory =[[self libaryDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@/",kNameWorkingDirectory]];
    if([self fileExistsAtPath:workingDirectory] == NO)
    {
        [self createDirectoryPath:workingDirectory];
    }
    return workingDirectory;
}


- (NSString *)dataBaseDirectory
{
    NSString *dataBasePathFolder = [[self workingDirectory] stringByAppendingString:[NSString stringWithFormat:@"%@/",kNameDataBaseDirectory]];
    if([self fileExistsAtPath:dataBasePathFolder] == NO)
    {
        [self createDirectoryPath:dataBasePathFolder];
    }
    return dataBasePathFolder;
}

- (NSString *)avatarsDirectory
{
    NSString *avatarsDirectory = [[self cashDirectory] stringByAppendingString:[NSString stringWithFormat:@"%@/",kNameAvatarDirectory]];
    if([self fileExistsAtPath:avatarsDirectory] == NO)
    {
        [self createDirectoryPath:avatarsDirectory];
    }
    return avatarsDirectory;
}

- (BOOL)fileExistsAtPath:(NSString *)path
{
    return [_fileManager fileExistsAtPath: path];
}

- (void)createDirectoryPath:(NSString *)path
{
    if ([_fileManager fileExistsAtPath: path ] == NO)
    {
        [_fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


- (void)clearDirectoryPath:(NSString *)path
{
    NSError *error = nil;
    NSArray *filesPath = [_fileManager contentsOfDirectoryAtPath:path error:&error];
    if(!error && filesPath.count > 0)
    {
        for(NSString *path in filesPath)
        {
            [_fileManager removeItemAtPath:path error:&error];
        }
    }
}

- (NSArray *)filesInDirectoryPath:(NSString *)path
{
    NSArray *fileArray = nil;
    
    if ([_fileManager fileExistsAtPath:path])
        fileArray = [_fileManager contentsOfDirectoryAtPath:path error:nil];
    
    return fileArray;
}

- (void)copyItemWithPath:(NSString *)srcPath toPath:(NSString *)toPath
{
    [_fileManager copyItemAtPath:srcPath toPath:toPath error:nil];
}


@end
