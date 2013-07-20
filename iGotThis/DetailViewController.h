//
//  DetailViewController.h
//  iGotThis
//
//  Created by James Paul Mason on 3/28/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"
#import "AddNewEventViewController.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UITableView *transactionsTableView;
@property (strong, nonatomic) PersonModel *personModel;
@property (strong, nonatomic) IBOutlet UILabel *themTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *youTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *whoOwesWhoLabel;


@end
