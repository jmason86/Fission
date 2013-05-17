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
    NSMutableArray *personNames;
    NSInteger indexOfExistingPerson;
}
@end

@implementation AddNewEventViewController
{
    NSMutableArray *filteredNames;
    UISearchDisplayController *searchController;
    BOOL isSearching;
}

@synthesize allPersonModels, personModel, transactionIndex, personNameField, totalBillField, iPayYouPaySwitch, splitBillSlider, totalToBeAddedToTabLabel, categoryPicker, notesField, filteredNameListTable;

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
    
    // Prepare pre-defined category choices
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
    
    // Setup searchable list of names to provide to user
    personNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < [allPersonModels count]; i++) {
        PersonModel *temporaryPerson = [allPersonModels objectAtIndex:i];
        [personNames addObject:[temporaryPerson personName]];
    }
    filteredNames = [NSMutableArray arrayWithArray:personNames]; // Start with all available names
    isSearching = NO; 
    
    // Setup filteredNameListTable
    filteredNameListTable.delegate = self;
    filteredNameListTable.dataSource = self;
    indexOfExistingPerson = -1;
}

// If coming from MasterViewController then add new objects, 
- (void)updateAllPersonModels
{
    [self dismissKeyboardAndUpdateValues];
    
    personModel.personName = personNameField.placeholder;
    [personModel.allTotalBills addObject:[NSNumber numberWithFloat:[totalBillField.text floatValue]]];
    [personModel.allIOUs addObject:[NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]]];
    [personModel.allSplitFractions addObject:[NSNumber numberWithFloat:splitBillSlider.value]];
    [personModel.allWhoPaidIndices addObject:[NSNumber numberWithInteger:iPayYouPaySwitch.selectedSegmentIndex]];
    [personModel.allCategories addObject:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0]];
    [personModel.allNotes addObject:notesField.text];
    
    if (indexOfExistingPerson < 0) {
        personModel.personBalance = [NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]];
        [allPersonModels addObject:personModel];
    } else {
        float sum = 0.0;
        for (int i = 0; i < [personModel.allIOUs count]; i++) {
            sum += [[personModel.allIOUs objectAtIndex:i] floatValue];
        }
        personModel.personBalance = [NSNumber numberWithFloat:sum];
        [allPersonModels replaceObjectAtIndex:indexOfExistingPerson withObject:personModel];
    }
}

// If coming from DetailViewController then replace objects
- (void)updatePersonModel
{
    personModel.personName = personNameField.placeholder;
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


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching) {
        return [filteredNames count];
    } else {
        return [allPersonModels count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tempCellID"];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    NSString *nameForRow;
    if (isSearching && [filteredNames count]) {
        nameForRow = [filteredNames objectAtIndex:indexPath.row];
    } else {
        nameForRow = [personNames objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = nameForRow;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [personModel.allIOUs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [filteredNames objectAtIndex:indexPath.row];
    personNameField.text = name;
    indexOfExistingPerson = [personNames indexOfObject:name];
    
    personModel = [allPersonModels objectAtIndex:indexOfExistingPerson];
    [self searchDisplayControllerWillEndSearch:nil];
}

#pragma mark - Filtering the name list

- (void)filterListForSearchText:(NSString *)searchText
{
    [filteredNames removeAllObjects]; // Clears the array from all the string objects it might contain from the previous searches
    
    for (NSString *title in personNames) {
        NSRange nameRange = [title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [filteredNames addObject:title];
        }
    }
}

#pragma mark - UISearchDisplayControllerDelegate

//When the user taps the search bar, this means that the controller will begin searching.
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    isSearching = YES;
}

// When the user taps the Cancel Button, or anywhere aside from the view.
// TODO: Customize  the cancel button to instead say "Add", or ideally the Search button to "Add"
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    personNameField.placeholder = personNameField.text;
    
    isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString]; 
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]]; 
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
