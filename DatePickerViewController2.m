//
//  DatePickerViewController2.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DatePickerViewController2.h"

@implementation DatePickerViewController2

@synthesize dateNameList, resultList, datePicker, typeList, dateFormatter, placeholderStringList, delegateToDatePicker, tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDateNameList: (NSArray *) nameArray withTypeList:(NSArray *) ptypeList; 
{
    self = [self initWithNibName:@"DatePickerViewController2" bundle:nil];
    self.dateNameList = nameArray;
    self.typeList = ptypeList;
    
    self.resultList = [[NSMutableArray alloc] init];
    for (int i = 0; i < nameArray.count; i++) {
        NSString *a = [NSString string];
        [resultList addObject:a];
    }
    
    return self;
}

- (void) cancelBarButtonClicked 
{
    [self.delegateToDatePicker DatePickerController:self finishDatePicker:NO withResults:nil withAlert:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doneBarButtonClicked
{
    UIAlertView *alert = [UIAlertView alloc];
    
    if ([self.delegateToDatePicker DatePickerController:self finishDatePicker:YES withResults:self.resultList withAlert:alert] == NO) {
            // result is not acceptable
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (NSDateFormatter *) dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return dateFormatter;
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
    
//    CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
//    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
//    CGRect pickerRect = CGRectMake(0.0,
//                                   screenRect.origin.y - 216,
//                                   pickerSize.width,
//                                   pickerSize.height);
//    self.datePicker.frame = pickerRect;
//    CGRect newFrame = screenRect;
//    newFrame.size.height -= pickerSize.height;
//    self.tableView.frame = newFrame;
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.datePicker];
//    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonClicked)];
    
    [self.navigationController setToolbarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
        //    [self.datePicker removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dateNameList.count;
}


- (UITableViewCell *)tableView:(UITableView *)ptableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DateCell";
    
    UITableViewCell *cell = [ptableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
        // Configure the cell...
    cell.textLabel.text = [dateNameList objectAtIndex:indexPath.row];
    NSDate *d;
    if (self.resultList.count > indexPath.row && [[self.resultList objectAtIndex:indexPath.row] isKindOfClass:[NSDate class]])  {
            // here we use a string as place holder.
        d = [resultList objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:d];
        cell.detailTextLabel.alpha = 1;
    } else {
        if (self.placeholderStringList.count > indexPath.row) {
            cell.detailTextLabel.text = [self.placeholderStringList objectAtIndex:indexPath.row];
            cell.detailTextLabel.alpha = 0.3;
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.resultList objectAtIndex:indexPath.row] != nil && [[self.resultList objectAtIndex:indexPath.row] class] == [NSDate class])
        [self.datePicker setDate:[self.resultList objectAtIndex:indexPath.row] animated:YES];
}

- (IBAction)datePickerValueChanged:(id)sender
{
    UIDatePicker *picker = sender;
    NSDate *d = picker.date;
    
    [self.resultList replaceObjectAtIndex:[self.tableView indexPathForSelectedRow].row withObject:d];
    NSArray *ar = [NSArray arrayWithObjects:[self.tableView indexPathForSelectedRow], nil];
    [self.tableView reloadRowsAtIndexPaths:ar
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL) DatePickerController: (DatePickerViewController2 *)sender finishDatePicker: (BOOL) save withResults:(NSArray *)results withAlert: (UIAlertView *)alert
{
    return YES;
}


@end
