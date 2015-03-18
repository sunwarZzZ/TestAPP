//
//  STProfileViewController.h
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STViewController.h"
#import "STSettingsManagerProtocol.h"

@interface STProfileViewController : STViewController

- (void)setupSettingsManager:(id<STSettingsManagerProtocol>)settingsManager;

@end
