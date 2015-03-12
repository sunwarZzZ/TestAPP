//
//  STSettingsViewController.m
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSettingsViewController.h"

@interface STSettingsViewController ()

@end

@implementation STSettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.title = STLocalizedString(@"Settings");
    }
    return self;
}


@end
