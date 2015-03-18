//
//  STTweetsAPIProtocol.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STTweetsAPIProtocol <NSObject>

- (void)requestTweetsCount:(int)count
                completion:(void(^)(NSArray *array, NSError *error))completion;


- (void)requestSearchTweetsWithText:(NSString *)text
                         completion:(void(^)(NSArray *tweets, NSError *error))completion;

@end
