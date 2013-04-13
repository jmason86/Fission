//
//  AddNewEventViewController.m
//  iGotThis
//
//  Created by James Mason on 3/29/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import "AddNewEventViewController.h"

@interface AddNewEventViewController ()
{
    NSArray *categoryChoices;
}
@end

@implementation AddNewEventViewController

@synthesize personNameField, allPersonModels, totalBillField, iPayYouPaySwitch, splitBillSlider, totalToBeAddedToTabLabel, categoryPicker, notesField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    categoryChoices = [[NSArray alloc] initWithObjects:@"Restaurant", @"Groceries", @"Movies", @"Bar Tab", @"Miscellaneous", nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueDidChange:(UISlider *)sender
{
    float totalBillValue = [totalBillField.text floatValue];
    float totalToBeAddedToTabValue = totalBillValue * sender.value;
    NSInteger iPayYouPay = iPayYouPaySwitch.selectedSegmentIndex;
    if (iPayYouPay == 0) {
        totalToBeAddedToTabLabel.text = [NSString stringWithFormat:@"%.2f", totalToBeAddedToTabValue];
    }
    else {
        totalToBeAddedToTabLabel.text = [NSString stringWithFormat:@"%.2f", (totalToBeAddedToTabValue * -1)];
    }
}

- (IBAction)iPayYouPaySwitchChanged:(UISegmentedControl *)sender
{
    float totalBillValue = [totalBillField.text floatValue];
    float totalToBeAddedToTabValue = totalBillValue * splitBillSlider.value;
    NSInteger iPayYouPay = sender.selectedSegmentIndex;
    if (iPayYouPay == 0) {
        totalToBeAddedToTabLabel.text = [NSString stringWithFormat:@"%.2f", totalToBeAddedToTabValue];
    }
    else {
        totalToBeAddedToTabLabel.text = [NSString stringWithFormat:@"%.2f", (totalToBeAddedToTabValue * -1)];
    }
}

- (IBAction)dismissPersonNameFieldKeyboard:(UITextField *)sender
{
    [personNameField resignFirstResponder];
}

- (IBAction)dismissNotesFieldKeyboard:(UITextField *)sender
{
    [notesField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard
    [personNameField resignFirstResponder];
    [totalBillField resignFirstResponder];
    [notesField resignFirstResponder];
    
    // Update total to be added to tab field
    float totalBillValue = [totalBillField.text floatValue];
    float totalToBeAddedToTabValue = totalBillValue * splitBillSlider.value;
    NSInteger iPayYouPay = iPayYouPaySwitch.selectedSegmentIndex;
    if (iPayYouPay == 0) {
        totalToBeAddedToTabLabel.text = [NSString stringWithFormat:@"%.2f", totalToBeAddedToTabValue];
    }
    else {
        totalToBeAddedToTabLabel.text = [NSString stringWithFormat:@"%.2f", (totalToBeAddedToTabValue * -1)];
    }
}

#pragma mark - UIPickerViewDataSource and Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // Just one column
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return categoryChoices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [categoryChoices objectAtIndex:row];
}

@end
