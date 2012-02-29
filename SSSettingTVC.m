//
//  SSSettingTVC.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SSSettingTVC.h"

@implementation SSSettingTVC

#define TELL_OTHER_ITEM_STRING NSLocalizedString(@"Tell a friend", "tell a friend item")
#define EMAIL_SUPPORT_ITEM_STRING NSLocalizedString(@"Email support", "eMail support item")
#define RATING_ITEM_STRING    NSLocalizedString(@"Rating me!", "Rating me item")

#define ENABLE_ALARM_SOUND NSLocalizedString(@"Alert Sound", "enable Alert")
#define ENABLE_SYSTEM_ALERT_SOUND NSLocalizedString(@"System Alert Sound", "system alert")

@synthesize iTunesURL;

- (NSArray *) alarmSettingsArray
{
    if (!alarmSettingsArray) {
        alarmSettingsArray = [[NSArray alloc] initWithObjects:
                              ENABLE_ALARM_SOUND,
                              ENABLE_SYSTEM_ALERT_SOUND,
                              nil];
    }
    return alarmSettingsArray;
}

- (NSArray *) itemsArray
{
    if (!itemsArray) {
        itemsArray = [[NSArray alloc] initWithObjects:
                      TELL_OTHER_ITEM_STRING,
				      EMAIL_SUPPORT_ITEM_STRING,
				      RATING_ITEM_STRING,
				      nil];
    }
    return itemsArray;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    if (section == 1)
        return NSLocalizedString(@"__SYSTEM_ALERT_DETAIL__", "");
    return Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return 1;
    if (section == 2)
        return self.itemsArray.count;
    if (section == 1)
        return self.alarmSettingsArray.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return tableView.rowHeight * 1.5;
    else 
        return tableView.rowHeight;
}

- (void) switchChanged: (id) sender
{
    UISwitch *s = sender;
    
    if (s.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"enableAlertSound"];
    } else if (s.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:s.on forKey:@"systemDefalutAlertSound"];
    }
        
}

- (UISwitch *) newSwitch:(NSIndexPath *)indexPath
{
    
    UISwitch *theSwitch;
    CGRect frame = CGRectMake(200, 8.0, 120.0, 27.0);
    theSwitch = [[UISwitch alloc] initWithFrame:frame];
    [theSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    theSwitch.backgroundColor = [UIColor clearColor];
    theSwitch.tag = indexPath.row;
    return theSwitch;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.textLabel.text = NSLocalizedString(@"Job Scheduer", "");
        cell.textLabel.font = [UIFont systemFontOfSize:24];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    } else if (indexPath.section == 2) {
            cell.textLabel.text = [self.itemsArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [self.alarmSettingsArray objectAtIndex:indexPath.row];
        
        UISwitch *s = [self newSwitch:indexPath];
        
        
        if (indexPath.row == 0) { // enable sound.
            s.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"enableAlertSound"];
        } else if (indexPath.row == 1) {
            s.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemDefalutAlertSound"];
        }
        [cell.contentView addSubview:s];
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (void) sendEMailTo: (NSString *)to WithSubject: (NSString *) subject withBody:(NSString *)body {
    NSString *mailString =  [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                             [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                             [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                             [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];

}

#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *supprt_mail = @"zhangjeef@gmail.com";
    NSString *support_title = NSLocalizedString(@"[SSS] ShiftSheduler support", "shift sheduler support");
    
    NSString *tel_other_title = NSLocalizedString(@"Check this app: Shift Sheduler", "");
    NSString *tel_other_body  = NSLocalizedString(@"__TELL_OTHER_BODY__", "");
    
    
    if (indexPath.section == 0) return;
    
    if ( [TELL_OTHER_ITEM_STRING isEqualToString:[self.itemsArray objectAtIndex:indexPath.row]])
        [self sendEMailTo:@"" WithSubject:tel_other_title withBody:tel_other_body];
    
    if ( [EMAIL_SUPPORT_ITEM_STRING isEqualToString:[self.itemsArray objectAtIndex:indexPath.row]])
    {
        [self sendEMailTo:supprt_mail WithSubject:support_title withBody:@""];
    }
    
    if ( [RATING_ITEM_STRING isEqualToString: [self.itemsArray objectAtIndex:indexPath.row]])
    {
        NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=482061308"; 

        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
     
}

@end
