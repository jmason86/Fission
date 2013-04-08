//
//  AddNewEventViewController.h
//  iGotThis
//
//  Created by James Mason on 3/29/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddNewEventViewController;

@interface AddNewEventViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *personNameField;
@property (strong, nonatomic) IBOutlet UITextField *totalBillField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *iPayYouPaySwitch;
@property (strong, nonatomic) IBOutlet UISlider *splitBillSlider;
@property (strong, nonatomic) IBOutlet UILabel *totalToBeAddedToTabLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UITextField *notesField;
@property (strong, nonatomic) NSMutableArray *allPersonNames;

@end
