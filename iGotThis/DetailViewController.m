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

@synthesize personModel, transactionsTableView, themTotalLabel, youTotalLabel, totalLabel;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Put the person's name in the navigation controller
    self.navigationItem.title = personModel.personName;
    
    // Total up all them balances and all you balances
    float themSum = 0.0;
    float youSum = 0.0;
    for (int i = 0; i < [personModel.allIOUs count]; i++) {
        if ([[personModel.allIOUs objectAtIndex:i] floatValue] < 0.0) {
            themSum += [[personModel.allIOUs objectAtIndex:i] floatValue];
        } else {
            youSum += [[personModel.allIOUs objectAtIndex:i] floatValue];
        }
    }
    int themTotal = round(abs(themSum));
    int youTotal = round(youSum);
    
    // Fill in totals on screen
    themTotalLabel.text = [NSString stringWithFormat:@"%@%i", @"$", themTotal];
    youTotalLabel.text = [NSString stringWithFormat:@"%@%i", @"$", youTotal];
    totalLabel.text = [NSString stringWithFormat:@"%@%@", @"$", [NSNumber numberWithInteger:round([personModel.personBalance floatValue])]];
    
    // Color the total label (difference) accordingly
    if ([personModel.personBalance floatValue] > 0) {
        totalLabel.textColor = [UIColor colorWithRed:0.87 green:0.24 blue:0.22 alpha:1.0];
    } else {
        totalLabel.textColor = [UIColor colorWithRed:0.29 green:0.68 blue:0.24 alpha:1.0];
    }

    
    // Setup tableview delegage/datasource and reload table
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
        addNewEventViewController.personModel = personModel;
        
        // Get only the event information relevant to the user's selection and modify addNewEventViewController's personModel
        NSInteger row = [[self.transactionsTableView indexPathForSelectedRow] row];
        addNewEventViewController.transactionIndex = row;
    }
}

// Returning (unwinding) from Subviews to MasterViewController
- (IBAction)addNewEventDone:(UIStoryboardSegue *)segue
{
    AddNewEventViewController *addNewEventViewController = [segue sourceViewController];
    
    // Tell addNewViewController to update the personModel
    [addNewEventViewController updatePersonModel];
}

- (IBAction)addNewEventCancel:(UIStoryboardSegue *)segue
{
    
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
    
    // Obtain values from personModel
    NSString *category = [[personModel allCategories] objectAtIndex:indexPath.row];
    NSString *notes = [[personModel allNotes] objectAtIndex:indexPath.row];
    NSNumber *iouNumber = [[personModel allIOUs] objectAtIndex:indexPath.row];
    NSString *iou = [NSString stringWithFormat:@"%@%@", @"$", [[NSNumber numberWithInteger:round(abs([iouNumber floatValue]))] stringValue]];
    
    // Put values into the UILabels
    UIImageView *categoryImageView = (UIImageView *)[cell viewWithTag:1]; // TODO: Set this to the image corresponding to the category
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *notesLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *iouLabel = (UILabel *)[cell viewWithTag:4];
    categoryLabel.text = category;
    notesLabel.text = notes;
    iouLabel.text = iou;
    
    // Determine coloring of text
    if ([iouNumber floatValue] < 0) {
        iouLabel.textColor = [UIColor colorWithRed:0.87 green:0.24 blue:0.22 alpha:1.0];
    } else {
        iouLabel.textColor = [UIColor colorWithRed:0.29 green:0.68 blue:0.24 alpha:1.0];
    }
    
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
