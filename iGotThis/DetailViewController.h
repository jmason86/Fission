//
//  DetailViewController.h
//  iGotThis
//
//  Created by James Paul Mason on 3/28/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonModel.h"

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (strong, nonatomic) IBOutlet UITableView *transactionsTableView;
@property (strong, nonatomic) PersonModel *personModel;

@end
