//
//  STQueueTask.h
//  SearchTweets
//
//  Created by aleksei on 19.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STQueueTask : NSObject

- (void)addTask:(NSURLSessionDataTask *)task;
- (void)cancelALlTasks;

@end
