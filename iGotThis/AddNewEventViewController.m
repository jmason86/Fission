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
    UIColor *green;
    UIColor *red;
    UIColor *gray;
    CGPoint notesOriginalCenter;
}

@synthesize allPersonModels, personModel, transactionIndex, personNameField, totalBillField, iPayYouPaySwitch, splitBillSlider, totalToBeAddedToTabLabel, categoryPicker, notesField, filteredNameListTable, categoryView, categoryButton, percentSplitLabel, meSplitValueLabel, themSplitValueLabel;

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
    notesField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillLayoutSubviews];
    
    notesOriginalCenter = notesField.center;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    // Define standard colors
    green = [UIColor colorWithRed:0.29 green:0.68 blue:0.24 alpha:1.0]; // green
    red = [UIColor colorWithRed:0.87 green:0.24 blue:0.22 alpha:1.0]; // red
    gray = [UIColor grayColor];
    
    // Prepare pre-defined category choices
    categoryChoices = [[NSArray alloc] initWithObjects:@"Restaurant", @"Bill", @"Electric", @"Event", @"Grocery", @"Misc", @"Movie", @"Rent", @"TV", @"Water", nil];
    categoryPicker.delegate = self;
    categoryView.hidden = YES;
    
    // If coming from MasterViewController then won't have a PersonModel object alloc init'ed, if coming from DetailViewController then will need to autofill all UI
    if (!personModel) {
        personModel = [[PersonModel alloc] init];
        
        // Setup searchable list of names to provide to user
        personNames = [[NSMutableArray alloc] init];
        for (int i = 0; i < [allPersonModels count]; i++) {
            PersonModel *temporaryPerson = [allPersonModels objectAtIndex:i];
            [personNames addObject:[temporaryPerson personName]];
        }
        [self addContactsFromAddressBook];
        filteredNames = [NSMutableArray arrayWithArray:personNames]; // Start with all available names
        isSearching = NO;
        
        // Setup filteredNameListTable
        filteredNameListTable.delegate = self;
        filteredNameListTable.dataSource = self;
        indexOfExistingPerson = -1;
        self.navigationItem.title = @"New Event";
    } else {
        personNameField.placeholder = personModel.personName;
        if (transactionIndex != -1) {
            totalBillField.text = [[personModel.allTotalBills objectAtIndex:transactionIndex] stringValue];
            iPayYouPaySwitch.selectedSegmentIndex = [[personModel.allWhoPaidIndices objectAtIndex:transactionIndex] intValue];
            splitBillSlider.value = [[personModel.allSplitFractions objectAtIndex:transactionIndex] floatValue];
            totalToBeAddedToTabLabel.text = [[personModel.allIOUs objectAtIndex:transactionIndex] stringValue];
            NSInteger selectedRow = [categoryChoices indexOfObject:[personModel.allCategories objectAtIndex:transactionIndex]];
            [categoryPicker selectRow:selectedRow inComponent:0 animated:YES];
            [categoryButton setTitle:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0] forState:UIControlStateNormal];
            notesField.text = [personModel.allNotes objectAtIndex:transactionIndex];
        }
        filteredNameListTable.userInteractionEnabled = NO;
        self.navigationItem.title = @"Edit Event";
        [self dismissKeyboardAndUpdateValues];
    }
    
    // Customize the look of the slider
    /*UIImage *sliderThumb = [UIImage imageNamed:@"UISlider_triangle.png"];
    [splitBillSlider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [splitBillSlider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
    */
}

// If coming from MasterViewController then add new objects
- (void)updateAllPersonModels
{
    [self dismissKeyboardAndUpdateValues];
    
    personModel.personName = personNameField.placeholder;
    [personModel.allTotalBills addObject:[NSNumber numberWithFloat:[totalBillField.text floatValue]]];
    [personModel.allIOUs addObject:[NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]]];
    [personModel.allSplitFractions addObject:[NSNumber numberWithFloat:splitBillSlider.value]];
    [personModel.allWhoPaidIndices addObject:[NSNumber numberWithInteger:iPayYouPaySwitch.selectedSegmentIndex]];
    [personModel.allCategories addObject:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0]];
    if (!notesField.text) {
        notesField.text = @" ";
    }
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

// If going back to DetailViewController then replace objects
- (void)updatePersonModel
{
    [self dismissKeyboardAndUpdateValues];
    personModel.personName = personNameField.placeholder;
    
    if (transactionIndex != -1) {
        [personModel.allTotalBills replaceObjectAtIndex:transactionIndex withObject:[NSNumber numberWithFloat:[totalBillField.text floatValue]]];
        [personModel.allIOUs replaceObjectAtIndex:transactionIndex withObject:[NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]]];
        [personModel.allSplitFractions replaceObjectAtIndex:transactionIndex withObject:[NSNumber numberWithFloat:splitBillSlider.value]];
        [personModel.allWhoPaidIndices replaceObjectAtIndex:transactionIndex withObject:[NSNumber numberWithInteger:iPayYouPaySwitch.selectedSegmentIndex]];
        [personModel.allCategories replaceObjectAtIndex:transactionIndex withObject:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0]];
        [personModel.allNotes replaceObjectAtIndex:transactionIndex withObject:notesField.text];
    } else {
        [personModel.allTotalBills addObject:[NSNumber numberWithFloat:[totalBillField.text floatValue]]];
        [personModel.allIOUs addObject:[NSNumber numberWithFloat:[totalToBeAddedToTabLabel.text floatValue]]];
        [personModel.allSplitFractions addObject:[NSNumber numberWithFloat:splitBillSlider.value]];
        [personModel.allWhoPaidIndices addObject:[NSNumber numberWithInteger:iPayYouPaySwitch.selectedSegmentIndex]];
        [personModel.allCategories addObject:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0]];
        [personModel.allNotes addObject:notesField.text];
    }

    [personModel totalUpIOUsForBalance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueDidChange:(UISlider *)sender
{
    [self dismissKeyboardAndUpdateValues];
    
    // Update the label
    percentSplitLabel.text = [NSString stringWithFormat:@"%.0f%@", sender.value * 100, @"%"];
    
    // Reposition the numbers below
    /*CGRect sliderFrame = splitBillSlider.frame;
    percentSplitLabel.center = CGPointMake(sliderFrame.origin.x - sliderFrame.size.width/2.0 + sliderFrame.size.width * sliderValue + 150, percentSplitLabel.center.y);
    themSplitValueLabel.center = CGPointMake(percentSplitLabel.center.x + percentSplitLabel.frame.size.width + 10, percentSplitLabel.center.y);
    meSplitValueLabel.center = CGPointMake(percentSplitLabel.center.x - percentSplitLabel.frame.size.width, percentSplitLabel.center.y);
    */
}

- (IBAction)iPayYouPaySwitchChanged:(UISegmentedControl *)sender
{
    [self dismissKeyboardAndUpdateValues];
    [self updateSplitLabelColors];
    [iPayYouPaySwitch drawRect:[sender frame]];
}

- (IBAction)categoryButtonClicked:(UIButton *)sender {
    if (categoryView.hidden) {
        categoryView.hidden = NO;
    } else {
        categoryView.hidden = YES;
        [categoryButton setTitle:[self pickerView:categoryPicker titleForRow:[categoryPicker selectedRowInComponent:0] forComponent:0] forState:UIControlStateNormal];
    }
}

- (IBAction)dismissNotesFieldKeyboard:(UITextField *)sender
{
    [self dismissKeyboardAndUpdateValues];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyboardAndUpdateValues];
}


#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [self slideForNotesEdit:self.view up:YES];
        
        //notesField.center = CGPointMake(notesOriginalCenter.x, notesOriginalCenter.y - 200.0);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [self slideForNotesEdit:self.view up:NO];
        notesField.center = notesOriginalCenter;
    }
}

- (void)slideForNotesEdit:(UIView *)view up:(BOOL)up
{
    const int movementDistance = 200;
    const float animationDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations:@"notesSlideAnimation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)dismissKeyboardAndUpdateValues
{
    // Dismiss the keyboard
    [personNameField resignFirstResponder];
    [totalBillField resignFirstResponder];
    [notesField resignFirstResponder];
    
    float totalBillValue = [totalBillField.text floatValue];
    float totalToBeAddedToTabValue;
    float remainder;
    if (iPayYouPaySwitch.selectedSegmentIndex == 0) {
        totalToBeAddedToTabValue = totalBillValue * splitBillSlider.value;
        remainder = totalBillValue - totalToBeAddedToTabValue;
        themSplitValueLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", remainder];
        meSplitValueLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", totalToBeAddedToTabValue];
    } else {
        totalToBeAddedToTabValue = totalBillValue * splitBillSlider.value * -1;
        remainder = totalBillValue + totalToBeAddedToTabValue;
        themSplitValueLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", totalToBeAddedToTabValue * -1];
        meSplitValueLabel.text = [NSString stringWithFormat:@"%@%.2f", @"$", remainder];
    }
    totalToBeAddedToTabLabel.text = [NSString stringWithFormat:@"%.2f", totalToBeAddedToTabValue];
    
    // Update the labels
    percentSplitLabel.text = [NSString stringWithFormat:@"%.0f%@", splitBillSlider.value * 100, @"%"];
    
    [self updateSplitLabelColors];
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
    
    NSString *nameForRow;
    if (isSearching && [filteredNames count]) {
        nameForRow = [filteredNames objectAtIndex:indexPath.row];
    } else {
        //nameForRow = [personNames objectAtIndex:indexPath.row]; // TODO: Figure out why I ever did this in the first place. Causes first name in address book to pop up after selection has been made. 
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
    NSMutableArray *allPersonModelNames = [[NSMutableArray alloc] init];
    for (int i = 0; i < [allPersonModels count]; i++) {
        [allPersonModelNames addObject:[[allPersonModels objectAtIndex:i] personName]];
    }
    indexOfExistingPerson = [allPersonModelNames indexOfObject:name];
    if (indexOfExistingPerson == NSNotFound) {
        PersonModel *newPerson = [[PersonModel alloc] init];
        newPerson.personName = name;
        [allPersonModels addObject:newPerson];
        personModel = newPerson;
        indexOfExistingPerson = [allPersonModels count] - 1;
    } else {
       personModel = [allPersonModels objectAtIndex:indexOfExistingPerson]; 
    }
    
    [filteredNames removeAllObjects];
    //[self searchDisplayControllerWillEndSearch:nil];
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

// When the user taps the search bar, this means that the controller will begin searching.
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [personNameField setShowsCancelButton:YES animated:NO];
    for (UIView *subView in personNameField.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            [(UIButton*)subView setTitle:@"Done" forState:UIControlStateNormal];
        }
    }
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version hasPrefix:@"7."]) {
        for (UIView *subView in [[personNameField.subviews objectAtIndex:0] subviews]){
            if([subView isKindOfClass:[UIButton class]]){
                [(UIButton*)subView setTitle:@"Done" forState:UIControlStateNormal];
            }
        }

    }
    
    isSearching = YES;
}

// When the user taps the Done button, or anywhere aside from the view.
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

#pragma mark - Address book

- (void)addContactsFromAddressBook
{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            for (int i = 0; i < [allContacts count]; i++) {
                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                [personNames addObject:fullName];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        for (int i = 0; i < [allContacts count]; i++) {
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            [personNames addObject:fullName];
        }

    }
    else {
        // The user has previously denied access
        NSLog(@"User has denied access to contacts so can't include in the search");
    }
    
    // Remove duplicates
    NSSet *uniqueSet = [[NSSet setWithArray:personNames] allObjects];
    personNames = [[uniqueSet allObjects] mutableCopy];
}

# pragma mark - Convenience code

- (void)updateSplitLabelColors
{
    if (iPayYouPaySwitch.selectedSegmentIndex == 0) {
        meSplitValueLabel.textColor = red;
        themSplitValueLabel.textColor = gray;
    }
    if (iPayYouPaySwitch.selectedSegmentIndex == 1) {
        meSplitValueLabel.textColor = gray;
        themSplitValueLabel.textColor = green;
    }
}

@end
