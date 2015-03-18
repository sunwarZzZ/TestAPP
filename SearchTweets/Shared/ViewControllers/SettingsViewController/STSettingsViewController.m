//
//  STSettingsViewController.m
//  SearchTweets
//
//  Created by aleksei on 12.03.15.
//  Copyright (c) 2015 Aleksei Ivankov. All rights reserved.
//

#import "STSettingsViewController.h"
#import "STSettingsItem.h"

@interface STSettingsViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableSettings;

@property (nonatomic, strong) NSArray *settingsItems;
@property (nonatomic, weak) id<STSettingsManagerProtocol> settingsManager;

@end

@implementation STSettingsViewController

#pragma mark - ViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self p_setupDataSource];
    [self p_setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableSettings reloadData];
}

#pragma mark - public methods
- (void)setupSettingsManager:(id<STSettingsManagerProtocol>)settingsManager
{
    self.settingsManager = settingsManager;
}

#pragma mark - UITableView methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"STSettingsTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    }
    
    if([self.settingsManager avatarsVisible])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    STSettingsItem *item = [self.settingsItems objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingsItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    STSettingsItem *item = [self.settingsItems objectAtIndex:indexPath.row];
    if(item.type ==  STSettingsItemTypeAvatarVisible)
    {
        [self.settingsManager setupAvatarsVisible:![self.settingsManager avatarsVisible]];
        [self.tableSettings reloadData];
    }
}


#pragma mark - private methods
- (void)p_setupUI
{
    self.title = STLocalizedString(@"Settings");
    self.tableSettings.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)p_setupDataSource
{
    STSettingsItem *avatarsVisibleItem = [STSettingsItem new];
    avatarsVisibleItem.title = STLocalizedString(@"AvatarVisible");
    avatarsVisibleItem.settingsId = 1;
    
    self.settingsItems = [NSArray arrayWithObject:avatarsVisibleItem];
    
    self.tableSettings.delegate = self;
    self.tableSettings.dataSource = self;
}


@end
