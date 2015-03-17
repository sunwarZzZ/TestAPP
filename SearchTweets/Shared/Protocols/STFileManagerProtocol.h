//
//  STFileManagerProtocol.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STFileManagerProtocol <NSObject>

- (NSString *)documentDirectory;
- (NSString *)libaryDirectory;
- (NSString *)cashDirectory;
- (NSString *)tempDirectory;
- (NSString *)workingDirectory;
- (NSString *)dataBaseDirectory;
- (NSString *)avatarsDirectory;

- (NSArray *)filesInDirectoryPath:(NSString *)path;
- (BOOL)fileExistsAtPath:(NSString *)path;

- (void)createDirectoryPath:(NSString *)path;
- (void)clearDirectoryPath:(NSString *)path;
- (void)copyItemWithPath:(NSString *)srcPath toPath:(NSString *)toPath;


@end
