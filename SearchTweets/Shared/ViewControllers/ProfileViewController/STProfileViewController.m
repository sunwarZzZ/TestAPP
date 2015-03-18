//
//  STProfileViewController.m
//  SearchTweets
//
//  Created by aleksei on 13.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STProfileViewController.h"
#import "STProfileItem.h"
#import "STSegueID.h"
#import "STSettingsViewController.h"

@interface STProfileViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UITableView *tableProfile;
@property (nonatomic, strong) NSArray *profileItems;


@end

@implementation STProfileViewController


#pragma mark - ViewController methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.title = STLocalizedString(@"Profile");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupDataSource];
    [self p_setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableProfile reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destination = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:kPresentSettingsControllerSegue])
    {
        if([destination isKindOfClass:[STSettingsViewController class]])
        {
            STSettingsViewController *settingsViewController = destination;
            settingsViewController.hidesBottomBarWhenPushed = YES;
        }
    }
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"STProfileTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    STProfileItem *item = [self.profileItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.profileItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    STProfileItem *item = [self.profileItems objectAtIndex:indexPath.row];
    if(item.type ==  STProfileItemTypeSettings)
    {
        [self performSegueWithIdentifier:kPresentSettingsControllerSegue sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private methods
- (void)p_setupUI
{
    self.tableProfile.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)p_setupDataSource
{
    STProfileItem *settingsItem = [STProfileItem new];
    settingsItem.title = STLocalizedString(@"Settings");
    settingsItem.profileId = 1;
    
    self.profileItems = [NSArray arrayWithObject:settingsItem];
    
    self.tableProfile.delegate = self;
    self.tableProfile.dataSource = self;
}



@end
