//
//  STDataBaseStrorageProtocol.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STFileManagerProtocol.h"

@class STTweet;

@protocol STDataBaseStrorageProtocol <NSObject>

- (instancetype)initWithFileManager:(id<STFileManagerProtocol>)fileManager;
- (void)addTweets:(NSArray *)tweets;

@end
