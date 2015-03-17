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
#import "STTweet.h"

static NSString *const kDataBaseName = @"STDataBase.sqlite";
static NSString *const kNameUsersTable = @"ST_USERS";
static NSString *const kNameTweetsTable = @"ST_TWEETS";

@interface STDataBaseStorage()

@property (nonatomic, weak) id<STFileManagerProtocol> fileManager;
@property (nonatomic, strong) FMDatabaseQueue *fmdataBaseQueue;

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
    for(STTweet *tweet in tweets)
    {
    
    }
}

#pragma mark - private methods
- (void)p_createDataBaseStack
{
    NSString *dataBasePath = [[self.fileManager dataBaseDirectory] stringByAppendingString:kDataBaseName];
    self.fmdataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
    
    if(self.fmdataBaseQueue == nil)
    {
        @throw [NSException exceptionWithName:@"" reason:@"Open data base failed" userInfo:nil];
    }
    
    [self.fmdataBaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",kNameUsersTable]];
        
        if([result next] == NO)
        {
            [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@(USER_ID INTEGER PRIMARY_KEY, NAME text, DESCRIPTION text, AVATAR_URL text)", kNameUsersTable]];
        }
        
        result = [db executeQuery:[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'", kNameTweetsTable]];
        
        if([result next] == NO)
        {
             [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@(TWEET_ID INTEGER  AUTO_INCREMENT PRIMARY KEY, USER_ID INTEGER, TEXT text, FOREIGN KEY (USER_ID) REFERENCES %@(USER_ID))", kNameTweetsTable, kNameUsersTable]];
        }
    }];
}


@end
