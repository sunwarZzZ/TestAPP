//
//  STTweetListViewController_iPhone.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTapeTweetsViewController_iPhone.h"
#import "STTapeTweetsTableCell_iPhone.h"

@interface STTapeTweetsViewController(Protected)

- (STTapeTweetsTableCell *)loadCell;

@end

@interface STTapeTweetsViewController_iPhone ()

@property (nonatomic, weak) IBOutlet STTapeTweetsTableCell_iPhone *nibCell;

@end

@implementation STTapeTweetsViewController_iPhone

#pragma mark - protected methods
- (STTapeTweetsTableCell *)loadCell
{
    [Bundle loadNibNamed:@"STTapeTweetsTableCell_iPhone" owner:self options:nil];
    return self.nibCell;
}

@end
