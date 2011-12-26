//
//  ShiftChangeAddViewController.m
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShiftChangeAddViewController.h"
#import "ShfitChangeList.h"
    //#import "DatePickerViewController.h"
#import "DatePickerViewController2.h"

#define USE_VC_CHOOSE_DATE

@implementation ShiftChangeAddViewController

@synthesize changeShiftSegmentControl, managedObjectContext,listDelegate, 
theShiftChange, notesTextFiled, shiftPicker, datePicker, dateFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (UITextField *)notesTextFiled
{
    if (notesTextFiled)
        return notesTextFiled;
    notesTextFiled =  [[UITextField alloc]                                                       initWithFrame:CGRectMake(10, 10, 600, 50)];
    notesTextFiled.placeholder = NSLocalizedString(@"Please input notes here (optional)", "please input notes here");
    notesTextFiled.delegate = self;
    return notesTextFiled;
}

- (UIDatePicker *)datePicker
{
#ifdef USE_VC_CHOOSE_DATE
    return nil;
#else
    if (datePicker)
        return datePicker;
    datePicker = [[UIDatePicker alloc] init];
    datePicker.date = [NSDate date];
    
    
    return  datePicker;
#endif

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

- (UIPickerView *)shiftPicker
{
    if (shiftPicker)
        return shiftPicker;
    
    shiftPicker = [[UIPickerView alloc] init];
    
    shiftPicker.dataSource = shiftPickerDataSource;
    shiftPicker.delegate = self;
    CGSize pickerSize = [self.shiftPicker sizeThatFits:CGSizeZero];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect pickerRect = CGRectMake(0, 
                                   screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    self.shiftPicker.frame = pickerRect;
    self.shiftPicker.showsSelectionIndicator = YES;
    return shiftPicker;
}

- (UISegmentedControl *)changeShiftSegmentControl
{
    if (changeShiftSegmentControl)
        return changeShiftSegmentControl;
    NSArray *changeShiftTypes = [[NSArray alloc] initWithObjects:
                                 [ShiftDay returnStringForType:[NSNumber numberWithInt:TYPE_EXCAHNGE]],
                                 [ShiftDay returnStringForType:[NSNumber numberWithInt:TYPE_OVERWORK]],
                                 [ShiftDay returnStringForType:[NSNumber numberWithInt:TYPE_VACATION]],nil ];
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:changeShiftTypes];
    control.selectedSegmentIndex = 0;
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    [control addTarget:self action:@selector(shiftTypeChanged:) 
      forControlEvents:UIControlEventValueChanged];
    changeShiftSegmentControl = control;
    return changeShiftSegmentControl;
}

- (void)shiftTypeChanged: (UISegmentedControl *) sender
{
        // shift change type changed.
    self.theShiftChange.type = [NSNumber numberWithInt:sender.selectedSegmentIndex];
    [self shiftPickerShow:NO];
    [self datePickerShow:NO];
    [self.tableView reloadData];
}


- (BOOL) isInputEnough
{
    if (self.theShiftChange.type == nil)
        return NO;
    if (self.theShiftChange.whatJob == nil)
        return  NO;
    if (self.theShiftChange.shiftFromDay == nil)
        return NO;
    if (self.theShiftChange.type.intValue != TYPE_EXCAHNGE
        && self.theShiftChange.shiftToDay == nil)
        return NO;
    return YES;
}

- (void)cancelButtonClicked
{
    [listDelegate didChangeShift:self didFinishWithSave:NO];
}



- (void)doneButtonClicked
{
    if ([self isInputEnough])
        [listDelegate didChangeShift:self didFinishWithSave:YES];
    else
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can't Save", "")
                                    message:@"Can't save due to not enough input" delegate:self cancelButtonTitle:NSLocalizedString(@"I Know", "") otherButtonTitles:nil, nil] show];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.prompt = NSLocalizedString(@"Choose a type of shift change", "");
    
    self.navigationItem.titleView = self.changeShiftSegmentControl;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
    NSArray *a = [NSArray arrayWithObjects:cancelButton, flexItem, saveButton,nil];
    [self setToolbarItems:a];
    
    self.theShiftChange = [NSEntityDescription insertNewObjectForEntityForName:@"ShiftDay" inManagedObjectContext:self.managedObjectContext];
    
    shiftPickerDataSource = [[ShiftPickerViewDataSource alloc] initWithContext:self.managedObjectContext];
    
    self.view.autoresizesSubviews = YES;
    self.tableView.allowsMultipleSelection = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        //#warning Potentially incomplete method implementation.
        // Return the number of sections.
    return 3;
}

    // 3 Sections, 
    //   - Which Shift ?
    //   - Which Date ?
    //   - Notes

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //#warning Incomplete method implementation.
        // Return the number of rows in the section.
    if (section == 0 && section == 2)
        return 1;
    if (section == 1 && theShiftChange.type.intValue == TYPE_EXCAHNGE)
        return 2;
    else
        return 1;
    
    NSLog(@"warnning, return in a no possible case");
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
        // Return a title or nil as appropriate for the section.
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Shift", "choose which shift");
            break;
        case 1:
            title = NSLocalizedString(@"Date", "choose date in shift change add");
            break;
        case 2:
            title = NSLocalizedString(@"Notes", "notes of shift change add view");
        default:
            break;
    }
    return title;;
}


- (UITableViewCell *)tableView:(UITableView *)ptableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [ptableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    int type = theShiftChange.type.intValue;
    
        //which shift
    if (indexPath.section == 0) {
        
            // 这里一开始显示提示选择，如果只有一种班，就直接选择那一种， 不提示。
            // 如果有两种， 就提示选择， 并且在选择以后就不加alpha了。
        cell.textLabel.text = NSLocalizedString(@"Shift", "shift in shift add view");
        if (shiftPickerDataSource.count > 1 && theShiftChange.whatJob == nil) {
            cell.detailTextLabel.text = NSLocalizedString(@"Choose shift", "choose shift");
            cell.detailTextLabel.alpha = .3;
        } else {
                // if only one job there, just show that shift's name
            OneJob *j = [shiftPickerDataSource retrunOneJob];
            cell.detailTextLabel.text = j.jobName;
            theShiftChange.whatJob = j;
        }
        
        if (theShiftChange.whatJob != nil) {
            cell.detailTextLabel.text = theShiftChange.whatJob.jobName;
            cell.detailTextLabel.alpha = 1;
        }
    }
        //date
    if (indexPath.section == 1) {
        
        if (type == TYPE_EXCAHNGE) // two date
        {
            if (indexPath.row == 0) // choose From
            {
                cell.textLabel.text = NSLocalizedString(@"From", "From in shift add view");
            } else {
                cell.textLabel.text = NSLocalizedString(@"To", "change to in shift change view");
            }
            cell.detailTextLabel.text = NSLocalizedString(@"choose date ", "choose data");
            cell.detailTextLabel.alpha = 0.3;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (type == TYPE_OVERWORK || type == TYPE_VACATION) 
        {
            cell.textLabel.text = NSLocalizedString(@"When", "when day of overwork or vacation");
            cell.detailTextLabel.text = NSLocalizedString(@"choose date", "choose data");
            cell.detailTextLabel.alpha = .3;
        }
            // fill in date if have some date;
        if (indexPath.row == 0 && self.theShiftChange.shiftFromDay != nil) {
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.theShiftChange.shiftFromDay];
            cell.detailTextLabel.alpha = 1;
        }
        
        if (indexPath.row == 1 && self.theShiftChange.shiftToDay != nil) {
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.theShiftChange.shiftToDay];
            cell.detailTextLabel.alpha = 1;
        }
    }
    
        // notes
    if (indexPath.section == 2) {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        [self.notesTextFiled removeFromSuperview];
        [cell.contentView addSubview:self.notesTextFiled];
        
    }
    return cell;
}



#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    choosenIndex = indexPath;
    if (indexPath.section != 2)
        return indexPath;
    else  {
        [self tableView:tv didSelectRowAtIndexPath:indexPath];
        return  nil;
    }
}

- (void) shiftPickerShow:(BOOL)show
{
    if (show) {
        self.shiftPicker.alpha = 0;
        [self.navigationController.view addSubview:self.shiftPicker];
        [self.navigationController setToolbarHidden:YES animated:YES];
        [UIView animateWithDuration:0.3 animations:^{self.shiftPicker.alpha = 1.0; self.datePicker.alpha = 0;}];
    } else {
        [UIView animateWithDuration:0.3 animations:^{self.shiftPicker.alpha = 0;}
                         completion:^(BOOL finish){
                             if (finish) {[self.shiftPicker removeFromSuperview];
                                 [self.navigationController setToolbarHidden:NO animated:YES];
                             }
                         }];
        
    }
}

- (void) datePickerShow:(BOOL) show
{
    if (show) {
#if 0
        self.datePicker.alpha = 0;
        [self.navigationController.view addSubview:self.datePicker];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.navigationController setToolbarHidden:YES];
        [UIView animateWithDuration:0.3 
                         animations:^{self.datePicker.alpha = 1; self.shiftPicker.alpha = 0;} completion:nil];
#else
        CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
            //CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
        CGRect screenRect = self.view.frame;
        CGRect startRect = CGRectMake(0.0,
                                      screenRect.origin.y + screenRect.size.height,
                                      pickerSize.width, pickerSize.height);
        CGRect pickerRect = CGRectMake(0.0,
                                       screenRect.origin.y + screenRect.size.height - (pickerSize.height) ,
                                       pickerSize.width,
                                       pickerSize.height);
        self.datePicker.frame = startRect;
            //    self.datePicker.alpha = 0;
            //            [self.view addSubview:self.datePicker];
            //        [self.navigationController.view addSubview:self.datePicker];
        

        [self.view addSubview:self.datePicker];
        
        NSLog(@"tableView:%@\n", self.tableView);
        [UIView animateWithDuration:0.3 delay:0 options:0 
                         animations:^{
                             self.datePicker.frame = pickerRect;
                                 //                             CGRect newFrame = self.tableView.frame;
                                 //                             newFrame.size.height -= pickerSize.height;
                                 //                             self.tableView.frame = newFrame;
                             self.datePicker.alpha = 1;
                         } completion:^(BOOL finish) {
                             CGRect newFrame = self.tableView.frame;
                             newFrame.size.height -= pickerSize.height;
                             
                                 //                             self.tableView.frame = newFrame;
                             [self.tableView setFrame:newFrame];
                             
                             
                             NSLog(@"frame:%@\n", NSStringFromCGRect(self.tableView.frame));
                             NSLog(@"bounds:%@\n", NSStringFromCGRect(self.tableView.bounds));
                             NSLog(@"tableView:%@\n", self.tableView);
                             NSLog(@"view:%@", self.view);
                             NSLog(@"view.frame:%@", NSStringFromCGRect(self.view.frame));
                             [self.tableView setNeedsDisplay];
                             [self.tableView setNeedsLayout];
                              [self.tableView scrollToRowAtIndexPath:self.tableView.indexPathForSelectedRow atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                         }];
        
#endif
    } else {
        [UIView animateWithDuration:0.3 animations:^{
                //    self.datePicker.alpha = 0;
        } 
                         completion:^(BOOL finish) {
                             if (finish) {
                                 CGRect newFrame = self.tableView.frame;
                                 newFrame.size.height += self.datePicker.bounds.size.height;
                                 self.tableView.frame = newFrame;
                                 [self.datePicker removeFromSuperview];
                                 [self.navigationController setToolbarHidden:NO animated:YES];
                             }
                         }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.notesTextFiled resignFirstResponder];
    if (indexPath.section == 0) // shift
    {
        [self.datePicker removeFromSuperview];
            // if only one shift, don't show
        if (shiftPickerDataSource.count == 1)
            return;
        else {
            if (self.shiftPicker.superview != nil)
                [self shiftPickerShow:NO];
            else
                [self shiftPickerShow:YES];
        }
    }
    
    if (indexPath.section == 1) // date
    {
#ifdef USE_VC_CHOOSE_DATE
        int type = theShiftChange.type.intValue;
        NSArray *namelist, *typeList, *placeholderList;
        if (type == TYPE_EXCAHNGE) {
            
            namelist = [NSArray arrayWithObjects:
                        NSLocalizedString(@"Origin Shift", "From in shift add view"),
                        NSLocalizedString(@"New Shift", "change to in shift change view"),
                        nil];
            typeList = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:UIDatePickerModeDate], [NSNumber numberWithInt:UIDatePickerModeDate], nil];
            placeholderList = [NSArray arrayWithObjects:
                               NSLocalizedString(@"Choose shift date", "choose data"),
                               NSLocalizedString(@"Choose shift date", "choose data"),
                               nil];
            
        }
        DatePickerViewController2 *dpvc = [[DatePickerViewController2 alloc] initWithDateNameList:namelist withTypeList:typeList];
        dpvc.placeholderStringList = placeholderList;
        dpvc.delegateToDatePicker = self;
        
        [self.navigationController pushViewController:dpvc animated:YES];
#else
        [self.shiftPicker removeFromSuperview];
        if (self.datePicker.superview != nil) {
            [self datePickerShow:NO];
        } else {
            
            CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
                //            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGRect screenRect = [self.view frame];
            
                //            CGRect screenRect = [self.tableView frame];
            CGRect pickerRect = CGRectMake(0.0,
                                           screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                           pickerSize.width,
                                           pickerSize.height);
            
            self.datePicker.frame = pickerRect;
            
            [self datePickerShow:YES];
            
        }
#endif
    }

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shiftPicker.superview != nil) {
        [self shiftPickerShow:NO];
    }
    if (self.datePicker.superview != nil) {
        [self datePickerShow:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    self.theShiftChange.notes = textField.text;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - "Date/Number Picker Save events"
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.theShiftChange.whatJob = [shiftPickerDataSource returnJobAt:row];
    
        // BUG: don't change when after shift change !!!
    [self.managedObjectContext save:nil];
    NSLog(@" change to %@", theShiftChange.whatJob.jobName);
    
    [self.tableView reloadData];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [shiftPickerDataSource returnJobAt:row].jobName;
}


- (IBAction)datePickerValueChanged:(id)sender
{
    NSInteger choosedRow = choosenIndex.row;
    
    UIDatePicker *picker = sender;
    
    if (choosedRow == 0) {
        self.theShiftChange.shiftFromDay = picker.date;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:choosenIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if (choosedRow == 1) {
        self.theShiftChange.shiftToDay = picker.date;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:choosenIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL) DatePickerController: (DatePickerViewController *)sender finishDatePicker: (BOOL) save withResults:(NSArray *)results withAlert: (UIAlertView *)alert
{
    
    if (!save)
        return YES;
        
        // need check whether this value is accept by me.
    if (self.theShiftChange.type == [NSNumber numberWithInt:TYPE_EXCAHNGE]) {
        NSAssert(results.count == 2, @"Result length should be 2 in exchange mode");
        if ([[results objectAtIndex:0] isKindOfClass:[NSDate class]]
            && [[results objectAtIndex:1] isKindOfClass:[NSDate class]]) {
            self.theShiftChange.shiftFromDay = [results objectAtIndex:0];
            self.theShiftChange.shiftToDay = [results objectAtIndex:1];
        }
    }
    
    if (self.theShiftChange.type == [NSNumber numberWithInt:TYPE_OVERWORK]) {
        NSAssert(results.count == 1, @"Result length should be 1 in exchange mode");
        if ([[results objectAtIndex:0] isKindOfClass:[NSDate class]])
            self.theShiftChange.shiftFromDay =  [results objectAtIndex:0];
    }
    
    if (self.theShiftChange.type == [NSNumber numberWithInt:TYPE_VACATION]) {
        NSAssert(results.count == 1, @"Results length should be 1 in exchange mode");
        if ([[results objectAtIndex:0] isKindOfClass:[NSDate class]])
            self.theShiftChange.shiftFromDay = [results objectAtIndex:0];
    }
    
    [self.tableView reloadData];
    
    return  YES;
}


@end
