//
//  STRequestManager.h
//  SearchTweets
//
//  Created by aleksei on 10.02.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STImageDownloaderProtocol.h"
#import "STAvtorizationManagerProtocol.h"
#import "STTweetsAPIProtocol.h"

@interface STRequestManager : NSObject <STImageDownloaderProtocol, STAvtorizationManagerProtocol, STTweetsAPIProtocol>


@end
