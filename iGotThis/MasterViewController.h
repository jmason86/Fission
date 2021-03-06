//
//  MasterViewController.h
//  iGotThis
//
//  Created by James Paul Mason on 3/28/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewEventViewController.h"
#import "PersonModel.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <UIApplicationDelegate>

- (IBAction)iPayTapped:(UIButton *)sender;
- (IBAction)uPayTapped:(UIButton *)sender;

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *allPersonModels;

@end
