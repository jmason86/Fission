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
{
    UIColor *green;
    UIColor *red;
    UIColor *gray;
}

@synthesize personModel, transactionsTableView, themTotalLabel, youTotalLabel, totalLabel, whoOwesWhoLabel;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    green = [UIColor colorWithRed:0.29 green:0.68 blue:0.24 alpha:1.0];
    red = [UIColor colorWithRed:0.87 green:0.24 blue:0.22 alpha:1.0];
    gray = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Put the person's name in the navigation controller
    self.navigationItem.title = personModel.personName;
    
    // Total up all them balances and all you balances
    float themSum = 0.0;
    float meSum = 0.0;
    for (int i = 0; i < [personModel.allIOUs count]; i++) {
        if ([[personModel.allIOUs objectAtIndex:i] floatValue] < 0.0) {
            themSum += [[personModel.allIOUs objectAtIndex:i] floatValue];
        } else {
            meSum += [[personModel.allIOUs objectAtIndex:i] floatValue];
        }
    }
    int themTotal = round(abs(themSum));
    int meTotal = round(meSum);
    
    // Fill in totals on screen
    themTotalLabel.text = [NSString stringWithFormat:@"%@%i", @"$", themTotal];
    youTotalLabel.text = [NSString stringWithFormat:@"%@%i", @"$", meTotal];
    totalLabel.text = [NSString stringWithFormat:@"%@%@", @"$", [NSNumber numberWithInteger:abs(round([personModel.personBalance floatValue]))]];
    if ([personModel.personBalance floatValue] > 0) {
        whoOwesWhoLabel.text = @"They owe me";
    } else {
        whoOwesWhoLabel.text = @"I owe them";
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
    
    if ([[segue identifier] isEqualToString:@"addNewEventToUserSegue"]) {
        // Pass the addNewEventViewController the full personModel
        AddNewEventViewController *addNewEventViewController = segue.destinationViewController;
        addNewEventViewController.personModel = personModel;
        addNewEventViewController.transactionIndex = -1;
    }
}

// Returning (unwinding) from AddNewEventViewController to DetailViewController
- (IBAction)addNewEventDone:(UIStoryboardSegue *)segue
{
    AddNewEventViewController *addNewEventViewController = [segue sourceViewController];

    // Tell addNewViewController to update it's personModel
    [addNewEventViewController updatePersonModel];
    
    // Replace whole person model with updated version
    personModel = nil;
    PersonModel *updatedPersonModel = [addNewEventViewController personModel];
    personModel = updatedPersonModel;
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
    UIImageView *categoryImageView = (UIImageView *)[cell viewWithTag:1];
    if ([category isEqualToString:@"Bill"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Bill.png"]];
    } else if ([category isEqualToString:@"Electric"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Electric.png"]];
    } else if ([category isEqualToString:@"Event"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Event.png"]];
    } else if ([category isEqualToString:@"Grocery"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Grocery.png"]];
    } else if ([category isEqualToString:@"Misc"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Misc.png"]];
    } else if ([category isEqualToString:@"Movie"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Movie.png"]];
    } else if ([category isEqualToString:@"Rent"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Rent.png"]];
    } else if ([category isEqualToString:@"Restaurant"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Restaurant.png"]];
    } else if ([category isEqualToString:@"TV"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"TV.png"]];
    } else if ([category isEqualToString:@"Water"]) {
        [categoryImageView setImage:[UIImage imageNamed:@"Water.png"]];
    }
    
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *notesLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *iouLabel = (UILabel *)[cell viewWithTag:4];
    categoryLabel.text = category;
    notesLabel.text = notes;
    iouLabel.text = iou;
    
    // Determine coloring of text
    if ([iouNumber floatValue] < 0) {
        iouLabel.textColor = green;
    } else {
        iouLabel.textColor = red;
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
