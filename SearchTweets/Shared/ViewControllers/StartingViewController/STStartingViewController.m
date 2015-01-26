//
//  StartingViewController.m
//  SearchTweets
//
//  Created by Aleksei Ivankov on 19.01.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STStartingViewController.h"
#import "STSegueIdentifierConstant.h"

@interface STStartingViewController()

@property (nonatomic, weak) IBOutlet UIButton *logInButton;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@end

@implementation STStartingViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.title = STLocalizedString(@"Avtorization");
    }
    return self;
}

#pragma mark - ViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupUI];
}

#pragma mark - IBActions

#pragma mark - private methods
- (void)p_setupUI
{
    [self.logInButton setTitle:STLocalizedString(@"LogIn") forState:UIControlStateNormal];
    
    [[self.logInButton layer] setBorderWidth:1.5f];
    [[self.logInButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"backgroung_girl"];
    
    UIImage *clearImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:clearImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = clearImage;
    self.navigationController.navigationBar.translucent = YES;
}

@end
