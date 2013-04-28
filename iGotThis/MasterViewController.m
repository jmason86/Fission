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

@synthesize allPersonNames, allBalances, allPersonModels;

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
    
    // TODO: Remove the filler here and just instantiate the array
    allPersonNames = [NSMutableArray arrayWithObjects:@"Buffalo Bill", @"Donatello", @"Usher", nil];
    allBalances = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", nil];
    allPersonModels = [[NSMutableArray alloc] init];
    
    // On app launch, go to next method
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialPersonModelsUpdate) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)initialPersonModelsUpdate
{
    // Make allPersonModel contain a bunch of PersonModels with updated properties
    for (int i = 0; i < allPersonNames.count; i++) {
        PersonModel *personModel = [[PersonModel alloc] init];
        personModel.personName = [allPersonNames objectAtIndex:i];
        personModel.personBalance = [allBalances objectAtIndex:i];
        // TODO: Figure out how to add total bills, IOUs, etc
        [allPersonModels addObject:personModel];
    }
}

- (void)saveData
{
    [allPersonModels writeToFile:[self saveFilename] atomically:YES];
    
}

- (void)loadData
{
    [allPersonModels removeAllObjects];
    allPersonModels = [NSMutableArray arrayWithContentsOfFile:[self saveFilename]];
}

- (NSString *)saveFilename
{
    NSString *filename = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"allPersonModels"];
    NSLog(filename);
    return filename;
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
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
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

// Returning from Subviews to MasterViewController
- (IBAction)addNewEventDone:(UIStoryboardSegue *)segue
{
    AddNewEventViewController *addNewEventViewController = [segue sourceViewController];
    
    // Tell addNewViewController to update it's personModel
    [addNewEventViewController updatePersonModel];
    
    // Get data set for updating table
    UITextField *personNameField = [addNewEventViewController personNameField];
    [allPersonNames addObject:personNameField.text];
    [allBalances addObject:@"0"];
    
    // Update allPersonModel
    [allPersonModels removeAllObjects];
    NSMutableArray *updatedAllPersonModels = [addNewEventViewController allPersonModels];
    allPersonModels = updatedAllPersonModels;
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

# pragma mark - Custom Methods

- (IBAction)iPayTapped:(UIButton *)sender {
}

- (IBAction)uPayTapped:(UIButton *)sender {
}
@end
