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

@synthesize allPersonNames, allBalances;

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
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    allPersonNames = [NSMutableArray arrayWithObjects:@"Buffalo Bill", @"Donatello", @"Usher", nil];
    allBalances = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", nil];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
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

- (IBAction)addNewPersonDone:(UIStoryboardSegue *)segue
{
    NSLog(@"Popping back to Master view controller!");
    AddNewPersonViewController *addNewPersonViewController = [segue sourceViewController];
    UITextField *personNameField = [addNewPersonViewController personNameField];
    [allPersonNames addObject:personNameField.text];
    [allBalances addObject:@"0"];
}

- (IBAction)addNewPersonCancel:(UIStoryboardSegue *)segue
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
    return allPersonNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *personName = [allPersonNames objectAtIndex:indexPath.row];
    cell.textLabel.text = personName;
    NSString *balance = [allBalances objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = balance;
    
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
        [allPersonNames removeObjectAtIndex:indexPath.row];
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

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    
    if ([[segue identifier] isEqualToString:@"addNewPersonSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        //AddNewPersonViewController *addNewPersonViewController = [[navigationController viewControllers] objectAtIndex:0]; // TODO: Verify that this should be at object index 0 always
        //addNewPersonViewController.delegate = self;

    }
}
*/

# pragma mark - Custom Methods

- (IBAction)iPayTapped:(UIButton *)sender {
}

- (IBAction)uPayTapped:(UIButton *)sender {
}
@end
