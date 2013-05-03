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

@synthesize allPersonModels, personModel, transactionIndex, personNameField, totalBillField, iPayYouPaySwitch, splitBillSlider, totalToBeAddedToTabLabel, categoryPicker, notesField;

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
    categoryPicker.delegate = self;
    
    // If coming from MasterViewController then won't have a PersonModel object alloc init'ed, if coming from DetailViewController then will need to autofill all UI
    if (!personModel) {
        personModel = [[PersonModel alloc] init];
    } else {
        personNameField.text = personModel.personName;
        totalBillField.text = [[personModel.allTotalBills objectAtIndex:0] stringValue];
        iPayYouPaySwitch.selectedSegmentIndex = [[personModel.allWhoPaidIndices objectAtIndex:0] intValue];
        splitBillSlider.value = [[personModel.allSplitFractions objectAtIndex:0] floatValue];
        totalToBeAddedToTabLabel.text = [[personModel.allIOUs objectAtIndex:0] stringValue];
        NSInteger selectedRow = [categoryChoices indexOfObject:[personModel.allCategories objectAtIndex:0]];
        [categoryPicker selectRow:selectedRow inComponent:0 animated:YES];
        notesField.text = [personModel.allNotes objectAtIndex:0];
    }
    
}

// If coming from MasterViewController then add new objects, 
- (void)updateAllPersonModels
{
    [self dismissKeyboardAndUpdateValues];
    
    personModel.personName = personNameField.text;
    personModel.personBalance = [NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]];
    [personModel.allTotalBills addObject:[NSNumber numberWithFloat:[totalBillField.text floatValue]]];
    [personModel.allIOUs addObject:[NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]]];
    [personModel.allSplitFractions addObject:[NSNumber numberWithFloat:splitBillSlider.value]];
    [personModel.allWhoPaidIndices addObject:[NSNumber numberWithInteger:iPayYouPaySwitch.selectedSegmentIndex]];
    [personModel.allCategories addObject:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0]];
    [personModel.allNotes addObject:notesField.text];
    [allPersonModels addObject:personModel];
}

// If coming from DetailViewController then replace objects
- (void)updatePersonModel
{
    
    personModel.personName = personNameField.text;
    personModel.personBalance = [NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]];
    [personModel.allTotalBills replaceObjectAtIndex:[transactionIndex integerValue] withObject:[NSNumber numberWithFloat:[totalBillField.text floatValue]]];
    [personModel.allIOUs replaceObjectAtIndex:[transactionIndex integerValue] withObject:[NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]]];
    [personModel.allSplitFractions replaceObjectAtIndex:[transactionIndex integerValue] withObject:[NSNumber numberWithFloat:splitBillSlider.value]];
    [personModel.allWhoPaidIndices replaceObjectAtIndex:[transactionIndex integerValue] withObject:[NSNumber numberWithInteger:iPayYouPaySwitch.selectedSegmentIndex]];
    [personModel.allCategories replaceObjectAtIndex:[transactionIndex integerValue] withObject:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0]];
    [personModel.allNotes replaceObjectAtIndex:[transactionIndex integerValue] withObject:notesField.text];
    [allPersonModels replaceObjectAtIndex:[transactionIndex integerValue] withObject:personModel];
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
    [self dismissKeyboardAndUpdateValues];
}

- (void)dismissKeyboardAndUpdateValues
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
