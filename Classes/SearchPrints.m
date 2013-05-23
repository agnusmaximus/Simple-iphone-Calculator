//
//  SearchPrints.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/4/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "SearchPrints.h"


@implementation SearchPrints

-(id)initWithFrame:(CGRect)frame andSuperView:(UIScrollView *)superView 
{
	[super initWithFrame:frame andSuperView:superView];
	arrayOfArrays = [[NSMutableArray alloc]initWithCapacity:10];
	track = 0;
	return self;
}

-(void)addArray:(id)sarray
{
	[arrayOfArrays addObject:sarray];
}

-(void)searchWithinArray
{	
	//Search for the string within the scrollview
	NSString *searchstring = searchTextField.text;
	
	if (searchstring == nil)
		return;
	
		
	//Create array with all objects that contain substring
	NSMutableArray *subarray = [NSMutableArray array];
	
	for (int i = 0; i < [arrayOfArrays count]; i++) {
		for (int x = 0; x < [[arrayOfArrays objectAtIndex:i] count]; x++) {
			MyButton *button = [[arrayOfArrays objectAtIndex:i] objectAtIndex:x];
			NSRange range = [button.titleLabel.text rangeOfString:searchstring];
			if (range.location != NSNotFound) {
				//Found a match
				//Add to array
				[subarray addObject:button];
			}
		}
	}
	
	//Nothing to switch
	if ([subarray count] == 0)
		return;
	
	//Keep track of which button we are viewing
	//dont go beyond total
	if (track >= [subarray count])
		track = 0;

	MyButton *button = [subarray objectAtIndex:track];
	
	//Scroll to this button
	CGPoint bottomOffset = CGPointMake(0,
									   button.frame.origin.y);
	[scrollView setContentOffset: bottomOffset animated: YES];
}

-(void)nextButton:(id)sender
{
	track++;
	[self searchWithinArray];
}

-(void)dealloc
{
	[arrayOfArrays release];
	[super dealloc];
}

@end
