//
//  STQueueTask.m
//  SearchTweets
//
//  Created by aleksei on 19.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STQueueTask.h"

@interface STQueueTask()
{
    dispatch_queue_t _queue;
}

@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation STQueueTask

- (instancetype)init
{
    if(self = [super init])
    {
        _tasks = [[NSMutableArray alloc] initWithCapacity:1000];
        _queue  = dispatch_queue_create("sunvar.app.searchTweets.stQueueTask", nil);
    }
    return self;
}

#pragma mark - public methods
- (void)addTask:(NSURLSessionDataTask *)task
{
    dispatch_async(_queue, ^{
        [self.tasks addObject:task];
        [task resume];
    });
}

- (void)cancelALlTasks
{
    dispatch_sync(_queue, ^{
        for(NSURLSessionDataTask *task in self.tasks)
        {
            [task cancel];
        }
        [self.tasks removeAllObjects];
    });
}

@end
