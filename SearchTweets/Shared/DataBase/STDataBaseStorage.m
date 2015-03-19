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
#import "STUser.h"

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

#pragma mark - public methods
- (void)addTweets:(NSArray *)tweets completion:(void(^)(void))completion
{
    [self.fmdataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for(STTweet *tweet in tweets)
        {
            FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT ID FROM %@ WHERE ID='%@'",kNameUsersTable, [NSNumber numberWithLongLong:tweet.user.userId]]];
        
            if([result next] == NO)
            {
                [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(ID,NAME,DESCRIPTION,AVATAR_URL) VALUES(?,?,?,?)",kNameUsersTable],[NSNumber numberWithLongLong:tweet.user.userId],tweet.user.name,tweet.user.descriptionText,tweet.user.avatarURLString];
            }
            
            result = [db executeQuery:[NSString stringWithFormat:@"SELECT TWEET_ID FROM %@ WHERE TWEET_ID='%@'",kNameTweetsTable, [NSNumber numberWithLongLong:tweet.tweetId]]];
            
            if([result next] == NO)
            {
                [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(TWEET_ID,USER_ID,DATE_CREATED,TEXT) VALUES(?,?,?,?)",kNameTweetsTable],[NSNumber numberWithLongLong:tweet.tweetId],[NSNumber numberWithLongLong:tweet.user.userId], [NSNumber numberWithInt:tweet.dateCreated], tweet.text];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
}

- (void)tweets:(void(^)(NSArray *tweets))completion
{
     [self.fmdataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
      {
          NSMutableArray *tweets = [NSMutableArray new];
          FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ LEFT JOIN %@  ON %@.USER_ID=%@.ID ORDER BY TWEET_ID DESC",kNameTweetsTable,kNameUsersTable,kNameTweetsTable,kNameUsersTable ]];
          while ([result next])
          {
              STTweet *tweet = [STTweet new];
              tweet.tweetId = [[result objectForColumnName:@"TWEET_ID"] longLongValue];
              tweet.text = [result objectForColumnName:@"TEXT"];
              tweet.dateCreated = [[result objectForColumnName:@"DATE_CREATED"] intValue];
            
              NSNumber *userId = [result objectForColumnName:@"ID"];
              if(userId)
              {
                  STUser *user = [STUser new];
                  user.userId = [userId longLongValue];
                  user.name = [result objectForColumnName:@"NAME"];
                  user.descriptionText = [result objectForColumnName:@"DESCRIPTION"];
                  user.avatarURLString = [result objectForColumnName:@"AVATAR_URL"];
                  tweet.user = user;
              }
              
              if(tweet.user)
              {
                  [tweets addObject:tweet];
              }
              else
              {
                  NSLog(@"get tweet error!!User not found!!!");
              }
              
          }
          
          dispatch_async(dispatch_get_main_queue(), ^{
              completion(tweets);
          });
     }];
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
    
    [self.fmdataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        
        FMResultSet *result = [db executeQuery:[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",kNameUsersTable]];
        
        if([result next] == NO)
        {
            [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@(ID INTEGER PRIMARY_KEY, NAME text, DESCRIPTION text, AVATAR_URL text)", kNameUsersTable]];
        }
        
        result = [db executeQuery:[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'", kNameTweetsTable]];
        
        if([result next] == NO)
        {
             [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@(TWEET_ID INTEGER PRIMARY KEY, USER_ID INTEGER, DATE_CREATED INTEGER, TEXT text, FOREIGN KEY (USER_ID) REFERENCES %@(ID))", kNameTweetsTable, kNameUsersTable]];
        }
    }];
}


@end
