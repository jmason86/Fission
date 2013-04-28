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
    [transactionsTableView reloadData]; // TODO: Find out how to get the table to actually show my data
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
