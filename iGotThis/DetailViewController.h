//
//  DetailViewController.h
//  iGotThis
//
//  Created by James Paul Mason on 3/28/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
