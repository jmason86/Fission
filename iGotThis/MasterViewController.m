//
//  MasterViewController.m
//  iGotThis
//
//  Created by James Paul Mason on 3/28/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()
@end

@implementation MasterViewController

@synthesize allPersonModels;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Restore from disk if file has been saved before
    NSString *saveFilename = [self saveFilename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:saveFilename]) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:saveFilename];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        allPersonModels = [unarchiver decodeObjectForKey:@"allPersonModels"];
        [unarchiver finishDecoding];
    }
    
    // On app terminate or resign active, save data to disk
    UIApplication *myApp = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:myApp];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSString *saveFilename = [self saveFilename];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:allPersonModels forKey:@"allPersonModels"];
    [archiver finishEncoding];
    BOOL success = [data writeToFile:saveFilename atomically:YES];
    if (!success) {
        NSLog(@"Failed to write allPersonModels to disk");
    }
}

- (NSString *)saveFilename
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"savefile.plist"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

// Going from MasterViewController to Subviews
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.personModel = [allPersonModels objectAtIndex:indexPath.row];
    }
    
    if ([[segue identifier] isEqualToString:@"addNewEventSegue"]) {
        AddNewEventViewController *addNewEventViewController = segue.destinationViewController;
        [addNewEventViewController.allPersonModels removeAllObjects];
        addNewEventViewController.allPersonModels = [NSMutableArray arrayWithArray:allPersonModels];
    }
}

// Returning (unwinding) from DetailViewController to MasterViewController
- (IBAction)editOldEventDone:(UIStoryboardSegue *)segue
{
    DetailViewController *detailViewController = [segue sourceViewController];
    
    // Update allPersonModel
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [allPersonModels replaceObjectAtIndex:indexPath.row withObject:detailViewController.personModel];
}

// Returning (unwinding) from DetailViewController to MasterViewController
- (IBAction)editOldEventCancel:(UIStoryboardSegue *)segue
{
    
}

// Returning (unwinding) from AddNewEventViewController to MasterViewController
- (IBAction)addNewEventDone:(UIStoryboardSegue *)segue
{
    AddNewEventViewController *addNewEventViewController = [segue sourceViewController];
    
    // Tell addNewViewController to update it's personModel
    [addNewEventViewController updateAllPersonModels];
    
    // Update allPersonModel
    [allPersonModels removeAllObjects]; // TODO: This may be a bug in the case of editing an existing transaction from DetailViewController
    NSMutableArray *updatedAllPersonModels = [addNewEventViewController allPersonModels];
    allPersonModels = updatedAllPersonModels;
}
 

// Returning (unwinding) from AddNewEventViewController
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
    return allPersonModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Obtain values from allPersonModels
    NSString *personName = [[allPersonModels objectAtIndex:indexPath.row] personName];
    NSNumber *personBalance = [[allPersonModels objectAtIndex:indexPath.row] personBalance];
    NSString *personBalanceAbsolute = [NSString stringWithFormat:@"%@%@", @"$", [NSNumber numberWithInteger:abs(round([personBalance floatValue]))]];
    NSNumber *personLatestTransaction = [[[allPersonModels objectAtIndex:indexPath.row] allIOUs] lastObject];
    NSNumber *personLatestTransactionAbsolute = [NSNumber numberWithInteger:abs([personLatestTransaction integerValue])];
    NSString *personLatestTransactionString = [NSString stringWithFormat:@"%@%@", @"$" , personLatestTransactionAbsolute];
    NSString *personLatestCategory = [[[allPersonModels objectAtIndex:indexPath.row] allCategories] lastObject];
    
    // Put values into the UILabels
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *latestTransactionLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *balanceLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *whoOwesWhoLabel = (UILabel *)[cell viewWithTag:4];
    UIImageView *upOrDownArrowImage = (UIImageView *)[cell viewWithTag:5];
    UILabel *latestCategoryLabel = (UILabel *)[cell viewWithTag:6];
    nameLabel.text = personName;
    latestTransactionLabel.text = personLatestTransactionString;
    balanceLabel.text = personBalanceAbsolute;
    latestCategoryLabel.text = personLatestCategory;
    
    // Determine coloring of text for latest transaction
    if ([personLatestTransaction floatValue] < 0) {
        latestTransactionLabel.textColor = [UIColor colorWithRed:0.29 green:0.68 blue:0.24 alpha:1.0]; // green
        UIImage *arrowImage = [UIImage imageNamed:@"icon_arrowdown.png"];
        upOrDownArrowImage.image = arrowImage;
    } else {
        latestTransactionLabel.textColor = [UIColor colorWithRed:0.87 green:0.24 blue:0.22 alpha:1.0]; // red
        UIImage *arrowImage = [UIImage imageNamed:@"icon_arrowup.png"];
        upOrDownArrowImage.image = arrowImage;
    }
    
    // Determine whether you owe or they owe
    if ([personBalance floatValue] > 0) {
        whoOwesWhoLabel.text = @"They owe me";
    } else {
        whoOwesWhoLabel.text = @"I owe them";
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
        [allPersonModels removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table View Delegate 

// TODO: Use this gesture to bring the user to an individual's balance sheet
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    } */
}

# pragma mark - Custom Methods

- (IBAction)iPayTapped:(UIButton *)sender {
}

- (IBAction)uPayTapped:(UIButton *)sender {
}
@end
