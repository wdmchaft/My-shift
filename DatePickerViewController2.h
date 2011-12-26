//
//  DatePickerViewController2.h
//  ShiftScheduler
//
//  Created by 洁靖 张 on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DatePickerViewController2;
@protocol DatePickerViewController2Delegate <NSObject>


    // the receiver should check the result value, if value is not ok, the caller will setup the alert and the receiver will be show this message.
- (BOOL) DatePickerController: (DatePickerViewController2 *)sender finishDatePicker: (BOOL) save withResults:(NSArray *)results withAlert: (UIAlertView *)alert;

@end


@interface DatePickerViewController2 : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray * dateNameList;
    NSMutableArray * resultList;
    NSArray * typeList;
    NSArray * placeholderStringList;
    NSDateFormatter *dateFormatter;
    IBOutlet UITableView *tableView;

    id <DatePickerViewController2Delegate> delegateToDatePicker;
    IBOutlet UIDatePicker *datePicker;
}

- (id)initWithDateNameList: (NSArray *) NameList withTypeList:(NSArray *) typeList; 
- (IBAction)datePickerValueChanged:(id)sender;


@property (copy, nonatomic) NSArray * dateNameList;
@property (copy, nonatomic) NSArray * typeList;
@property (copy, nonatomic) NSArray * placeholderStringList;
@property (strong, nonatomic) NSMutableArray *resultList;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong)      id <DatePickerViewController2Delegate> delegateToDatePicker;
    @property (nonatomic, strong) UITableView *tableView;



@end
