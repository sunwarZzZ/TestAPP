//
//  AvtorizationViewController.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STViewController.h"
#import "STAvtorizationManagerProtocol.h"

@interface STAvtorizationViewController : STViewController

- (void)setupAvtorizationManager:(id<STAvtorizationManagerProtocol>)avtorizationManager;

@end
