//
//  STTweetsNibLoader_iPhone.m
//  SearchTweets
//
//  Created by aleksei on 17.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTweetsNibLoader_iPhone.h"
#import "STTapeTweetsTableCell_iPhone.h"

@interface STTweetsNibLoader_iPhone()

@property (nonatomic, weak) IBOutlet STTapeTweetsTableCell_iPhone *nibCell;

@end

@implementation STTweetsNibLoader_iPhone

- (STTapeTweetsTableCell *)loadTweetCell
{
    [Bundle loadNibNamed:@"STTapeTweetsTableCell_iPhone" owner:self options:nil];
    return self.nibCell;
}


@end
