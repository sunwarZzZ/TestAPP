//
//  STTableViewCell.m
//  SearchTweets
//
//  Created by aleksei on 16.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STTableViewCell.h"

@implementation STTableViewCell

+ (NSString *)reuseID
{
    return NSStringFromClass([self class]);
}

@end
