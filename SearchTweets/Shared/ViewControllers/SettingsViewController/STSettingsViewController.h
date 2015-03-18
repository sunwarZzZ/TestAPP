//
//  STSettingsViewController.h
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STViewController.h"
#import "STSettingsManagerProtocol.h"

@interface STSettingsViewController : STViewController

- (void)setupSettingsManager:(id<STSettingsManagerProtocol>)settingsManager;


@end
