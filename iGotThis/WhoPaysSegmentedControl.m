//
//  WhoPaysSegmentedControl.m
//  Fission
//
//  Created by James Mason on 8/6/13.
//  Copyright (c) 2013 Trinary. All rights reserved.
//

#import "WhoPaysSegmentedControl.h"

@implementation WhoPaysSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor *green = [UIColor colorWithRed:0.29 green:0.68 blue:0.24 alpha:1.0]; // green
    UIColor *red = [UIColor colorWithRed:0.87 green:0.24 blue:0.22 alpha:1.0]; // red
    UIColor *gray = [UIColor grayColor];
    
    for (int i=0; i<[self.subviews count]; i++)
    {
        if ([[self.subviews objectAtIndex:i] isSelected] && i == 0)
        {
            [[self.subviews objectAtIndex:i] setTintColor:green];
        } else if ([[self.subviews objectAtIndex:i] isSelected] && i == 1)
        {
            [[self.subviews objectAtIndex:i] setTintColor:red];
        } else {
            [[self.subviews objectAtIndex:i] setTintColor:gray];
        }
    }
}


@end
