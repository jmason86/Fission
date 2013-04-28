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

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:personName forKey:@"personName"];
    [aCoder encodeObject:personBalance forKey:@"personBalance"];
    [aCoder encodeObject:allTotalBills forKey:@"allTotalBills"];
    [aCoder encodeObject:allIOUs forKey:@"allIOUs"];
    [aCoder encodeObject:allSplitFractions forKey:@"allSplitFractions"];
    [aCoder encodeObject:allWhoPaidIndices forKey:@"allWhoPaidIndices"];
    [aCoder encodeObject:allCategories forKey:@"allCategories"];
    [aCoder encodeObject:allNotes forKey:@"allNotes"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        personName = [aDecoder decodeObjectForKey:@"personName"];
        personBalance = [aDecoder decodeObjectForKey:@"personBalance"];
        allTotalBills = [aDecoder decodeObjectForKey:@"allTotalBills"];
        allIOUs = [aDecoder decodeObjectForKey:@"allIOUs"];
        allSplitFractions = [aDecoder decodeObjectForKey:@"allSplitFractions"];
        allWhoPaidIndices = [aDecoder decodeObjectForKey:@"allWhoPaidIndices"];
        allCategories = [aDecoder decodeObjectForKey:@"allCategories"];
        allNotes = [aDecoder decodeObjectForKey:@"allNotes"];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    PersonModel *copy = [[[self class] allocWithZone:zone] init];
    copy.personName = [self.personName copyWithZone:zone];
    copy.personBalance = [self.personBalance copyWithZone:zone];
    copy.allTotalBills = [self.allTotalBills copyWithZone:zone];
    copy.allIOUs = [self.allIOUs copyWithZone:zone];
    copy.allSplitFractions = [self.allSplitFractions copyWithZone:zone];
    copy.allWhoPaidIndices = [self.allWhoPaidIndices copyWithZone:zone];
    copy.allCategories = [self.allCategories copyWithZone:zone];
    copy.allNotes = [self.allNotes copyWithZone:zone];
    return copy;
}


// Method for adding a new set of values to totalbills, IOUs, splitFractions, whopaidindices, cateogires, and notes, updating to a new balance, for a particular person

// Method for changing an individual value in bills, IOus, splitfractions, whopaidindices, categories, notes

@end