//
//  STTapeTweetsDataSource_iPhone.m
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsDataSource_iPhone.h"
#import "STTapeTweetsTableCell_iPhone.h"

@interface STTapeTweetsDataSource(Protected)

- (STTapeTweetsTableCell *)loadCell;

@end

@interface STTapeTweetsDataSource_iPhone()

@property (nonatomic, weak) IBOutlet STTapeTweetsTableCell_iPhone *nibCell;

@end

@implementation STTapeTweetsDataSource_iPhone

#pragma mark - protected methods
- (STTapeTweetsTableCell *)loadCell
{
    [Bundle loadNibNamed:@"STTapeTweetsTableCell_iPhone" owner:self options:nil];
    return self.nibCell;
}

@end
