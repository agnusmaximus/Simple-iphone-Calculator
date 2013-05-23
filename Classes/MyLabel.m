//
//  MyLabel.m
//  SimpleCalculator
//
//  Created by Max Lam on 5/20/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MyLabel.h"


@implementation MyLabel

-(void)awakeFromNib
{
	[self setFont:[UIFont fontWithName:@"orbitron" size:self.font.pointSize]];
	[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
	self.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	self.textAlignment = UITextAlignmentCenter;
}

@synthesize index;

@end
