//
//  PersonModel.h
//  iGotThis
//
//  Created by James Mason on 4/10/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (strong, nonatomic) NSString *personName;
@property (strong, nonatomic) NSNumber *personBalance;
@property (strong, nonatomic) NSMutableArray *allTotalBills;
@property (strong, nonatomic) NSMutableArray *allIOUs;
@property (strong, nonatomic) NSMutableArray *allSplitFractions;
@property (strong, nonatomic) NSMutableArray *allWhoPaidIndices;
@property (strong, nonatomic) NSMutableArray *allCategories;
@property (strong, nonatomic) NSMutableArray *allNotes;

@end