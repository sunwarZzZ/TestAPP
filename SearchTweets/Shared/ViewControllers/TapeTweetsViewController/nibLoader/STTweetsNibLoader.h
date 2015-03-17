//
//  STTweetsNibLoader.h
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STTapeTweetsTableCell;

@interface STTweetsNibLoader : NSObject


/* virtual methods */
- (STTapeTweetsTableCell *)loadTweetCell;

@end
