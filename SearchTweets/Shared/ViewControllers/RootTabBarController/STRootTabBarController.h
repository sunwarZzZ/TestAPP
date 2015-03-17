//
//  RootTabBarController.h
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STLocator;

@interface STRootTabBarController : UITabBarController

- (void)setupWithLocator:(STLocator *)locator;

@end
