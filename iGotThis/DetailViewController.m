//
//  DetailViewController.m
//  iGotThis
//
//  Created by James Paul Mason on 3/28/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@end

@implementation DetailViewController

@synthesize totalBalanceLabel, personModel, transactionsTableView;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set label at the top of the screen to indicate who owes who money
    if (personModel.personBalance <= 0) {
        totalBalanceLabel.text = [NSString stringWithFormat:@"%@%@%@%@", @"You owe ", personModel.personName, @" $", personModel.personBalance];
    }
    else {
        totalBalanceLabel.text = [NSString stringWithFormat:@"%@%@%@", personModel.personName, @" owes you $", personModel.personBalance];
    }
    self.navigationController.title = personModel.personName;
    
    transactionsTableView.delegate = self;
    transactionsTableView.dataSource = self;
    [transactionsTableView reloadData]; 
}

#pragma mark - Segues

// Going from Detail Person View to AddNewEvent view with prepopulated data
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"editOldEventSegue"]) {

        
        // Pass the addNewEventViewController the full personModel
        AddNewEventViewController *addNewEventViewController = segue.destinationViewController;
        PersonModel *temporaryPersonModel = [personModel copy]; // Pass a copy instead of pointer to original
        addNewEventViewController.personModel = temporaryPersonModel;
        
        // Get only the event information relevant to the user's selection and modify addNewEventViewController's personModel
        NSInteger row = [[self.transactionsTableView indexPathForSelectedRow] row];
        NSMutableArray *totalBill = [NSMutableArray arrayWithObject: [personModel.allTotalBills objectAtIndex:row]];
        NSMutableArray *iou = [NSMutableArray arrayWithObject:[personModel.allIOUs objectAtIndex:row]];
        NSMutableArray *splitFraction = [NSMutableArray arrayWithObject:[personModel.allSplitFractions objectAtIndex:row]];
        NSMutableArray *whoPaidIndex = [NSMutableArray arrayWithObject:[personModel.allWhoPaidIndices objectAtIndex:row]];
        NSMutableArray *category = [NSMutableArray arrayWithObject:[personModel.allCategories objectAtIndex:row]];
        NSMutableArray *notes = [NSMutableArray arrayWithObject:[personModel.allNotes objectAtIndex:row]];
        addNewEventViewController.personModel.allTotalBills = totalBill;
        addNewEventViewController.personModel.allIOUs = iou;
        addNewEventViewController.personModel.allSplitFractions = splitFraction;
        addNewEventViewController.personModel.allWhoPaidIndices = whoPaidIndex;
        addNewEventViewController.personModel.allCategories = category;
        addNewEventViewController.personModel.allNotes = notes;
        addNewEventViewController.transactionIndex = [NSNumber numberWithInteger:row];
    }
}

// Returning (unwinding) from Subviews to MasterViewController
- (IBAction)addNewEventDone:(UIStoryboardSegue *)segue
{
    AddNewEventViewController *addNewEventViewController = [segue sourceViewController];
    
    // Tell addNewViewController to update it's personModel
    [addNewEventViewController updatePersonModel];
    
    // Update personModel
    personModel = [addNewEventViewController personModel];
}

- (IBAction)addNewEventCancel:(UIStoryboardSegue *)segue
{
    NSLog(@"Popping back to Master view controller after cancel button clicked.");
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return personModel.allIOUs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IOUCell" forIndexPath:indexPath];
    
    NSString *category = [personModel.allCategories objectAtIndex:indexPath.row];
    NSString *iou = [[personModel.allIOUs objectAtIndex:indexPath.row] stringValue];
    NSString *categoryAndNote = [[category stringByAppendingString:@":"] stringByAppendingString:iou];
    cell.textLabel.text = categoryAndNote;
    
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
    
}

@end
