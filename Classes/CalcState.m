//
//  CalcState.m
//  Calculator2
//
//  Created by Max Lam on 5/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "CalcState.h"

static CalcState *calcState = nil;

@implementation CalcState

-(id)init
{
	[super init];
	stateOK = YES;
	scientificChng = NO;
	DEGOrRad = RAD;
	CALCULATOR_MODE = DIGITS_MODE;
	numFunctionBar = 0;
	return self;
}

+(CalcState *)sharedState
{
	@synchronized(self) {
		if (calcState == nil) {
			calcState = [[CalcState alloc]init];
		}
	}
	return calcState;
}

-(void)chngSci
{
	if (scientificChng == YES)
		scientificChng = NO;
	else 
		scientificChng = YES;
}

-(void)dealloc
{
	[super dealloc];
}

@synthesize stateOK;
@synthesize scientificChng;
@synthesize DEGOrRad;
@synthesize	CALCULATOR_MODE;
@synthesize numFunctionBar;

@end
