//
//  AddNewEventViewController.h
//  iGotThis
//
//  Created by James Mason on 3/29/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"

@class AddNewEventViewController;

@interface AddNewEventViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

// Input to class
@property (strong, nonatomic) NSMutableArray *allPersonModels; // From MasterViewController
@property (strong, nonatomic) PersonModel *personModel; // From DetailViewController
@property (nonatomic) int transactionIndex;
@property (strong, nonatomic) IBOutlet UISearchBar *personNameField;

// Output determined by user in class 
@property (strong, nonatomic) IBOutlet UITextField *totalBillField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *iPayYouPaySwitch;
@property (strong, nonatomic) IBOutlet UISlider *splitBillSlider;
@property (strong, nonatomic) IBOutlet UILabel *totalToBeAddedToTabLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UITextField *notesField;
@property (strong, nonatomic) IBOutlet UITableView *filteredNameListTable;

- (IBAction)sliderValueDidChange:(UISlider *)sender;
- (IBAction)iPayYouPaySwitchChanged:(UISegmentedControl *)sender;

- (void)updateAllPersonModels;
- (void)updatePersonModel;

@end
