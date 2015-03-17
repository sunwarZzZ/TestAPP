//
//  STDataBaseStorage.m
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STDataBaseStorage.h"
#import "STFileManagerProtocol.h"
#import <FMDB.h>

static NSString *const kDataBaseName = @"STDataBase.sqlite";

@interface STDataBaseStorage()

@property (nonatomic, weak) id<STFileManagerProtocol> fileManager;
@property (nonatomic, strong) FMDatabase *fmdataBase;

@end

@implementation STDataBaseStorage

- (instancetype)initWithFileManager:(id<STFileManagerProtocol>)fileManager
{
    NSParameterAssert(fileManager);
    if(self = [super init])
    {
        _fileManager = fileManager;
        [self p_createDataBaseStack];
    }
    return self;
}

- (void)addTweets:(NSArray *)tweets
{

}

#pragma mark - private methods
- (void)p_createDataBaseStack
{
    NSString *dataBasePath = [[self.fileManager dataBaseDirectory] stringByAppendingString:[NSString stringWithFormat:@"/%@", kDataBaseName]];
    self.fmdataBase = [FMDatabase databaseWithPath:dataBasePath];
}


@end
