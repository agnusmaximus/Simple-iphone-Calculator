//
//  MyMenu.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MyMenu.h"


@implementation MyMenu

-(id)initWithFrame:(CGRect)frame
{
	[super initWithFrame:frame];
	stateSelect = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Digits",@"Equation",nil]];
	stateSelect.center = CGPointMake(160, 100);
	stateSelect.frame = CGRectMake(stateSelect.frame.origin.x,
								   stateSelect.frame.origin.y,
								   190, 50);
	
	stateSelect.segmentedControlStyle = UISegmentedControlStyleBezeled;
	stateSelect.tintColor = [UIColor colorWithRed:.26 green:.32 blue:.42 alpha:1];
	
	[stateSelect setSelectedSegmentIndex:[CalcState sharedState].CALCULATOR_MODE-1];
	[stateSelect addTarget:self action:@selector(changeCalcState) forControlEvents:UIControlEventValueChanged];
	
	[self addSubview:stateSelect];
	return self;
}

-(void)appear:(id)sender;
{	
	if (![timer isValid]) {
		if (self.hidden == YES) {
			timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(Opaquify) userInfo:nil repeats:YES];
			self.hidden = NO;
		}
		else if (self.hidden == NO) {
			timer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f target:self selector:@selector(Translucify) userInfo:nil repeats:YES];
		}
	}
}

-(void)Opaquify
{
	self.alpha += .05;
	if (self.alpha >= 1) {
		[timer invalidate];
		timer = nil;
	}
}

-(void)Translucify
{
	self.alpha -= .05;
	if (self.alpha <= 0) {
		[timer invalidate];
		timer = nil;
		self.hidden = YES;
	}
}

-(void)changeCalcState
{
	if (stateSelect.selectedSegmentIndex == DIGITS_MODE-1) {
		[CalcState sharedState].CALCULATOR_MODE = DIGITS_MODE;
	}
	else {
		[CalcState sharedState].CALCULATOR_MODE = EQUATION_MODE;
	}
	if ([CalcState sharedState].CALCULATOR_MODE == DIGITS_MODE) {
		RightPar.hidden = YES;
		LeftPar.hidden = YES;
	}
	else {
		//Enable parenthases
		RightPar.hidden = NO;
		LeftPar.hidden = NO;
	}
}

@synthesize RightPar;
@synthesize LeftPar;
@end
