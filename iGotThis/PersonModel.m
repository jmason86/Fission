//
//  PersonModel.m
//  iGotThis
//
//  Created by James Mason on 4/10/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

@synthesize personName, personBalance, allTotalBills, allIOUs, allSplitFractions, allWhoPaidIndices, allCategories, allNotes;

- (id)init
{
    self = [super init];
    allTotalBills =  [[NSMutableArray alloc] init];
    allIOUs = [[NSMutableArray alloc] init];
    allSplitFractions = [[NSMutableArray alloc] init];
    allWhoPaidIndices = [[NSMutableArray alloc] init];
    allCategories = [[NSMutableArray alloc] init];
    allNotes = [[NSMutableArray alloc] init];
    
    return self;
}

// Method for saving all variables to NSUserDefaults for persistence

// Method for adding a new set of values to totalbills, IOUs, splitFractions, whopaidindices, cateogires, and notes, updating to a new balance, for a particular person

// Method for changing an individual value in bills, IOus, splitfractions, whopaidindices, categories, notes

@end