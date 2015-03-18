//
//  STContact.h
//  SearchTweets
//
//  Created by Aleksei Ivankov on 3/15/15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STUser : NSObject

@property (nonatomic, assign) long long userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *avatarURLString;
@property (nonatomic, strong) UIImage *avatarImage;

@end
