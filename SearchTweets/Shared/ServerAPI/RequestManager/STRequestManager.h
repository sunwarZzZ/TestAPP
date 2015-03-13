//
//  STRequestManager.h
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STRequestManager : NSObject

- (void)requestTweets:(void(^)(void))completion;

@end
