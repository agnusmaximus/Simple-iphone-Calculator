//
//  FunctionBrain.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/8/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "FunctionBrain.h"


@implementation FunctionBrain

-(id)init
{
	hero = [[SpinalCord alloc]init];
	return self;
}

-(double)functionWithFunction:(NSString *)function andNumber:(double)number
{
	//Remember these:
	//@"!",@"LOGTWO",@"%",@"LOGTEN",@"SQRT",
	//@"Sin",@"Cos",@"Tan",@"Sinh",@"Cosh",@"Tanh",@"CUBERT",@"SININV",@"COSINV",@"TANINV"
	double result = NAN;
	
	if ([function isEqualToString:@"!"]) {
		result = [hero unaryOperation:FACT andOp:number];
	}
	else if ([function isEqualToString:@"LOGTWO"]) {
		result = [hero unaryOperation:LOG2 andOp:number];
	}
	else if ([function isEqualToString:@"%"]) {
		result = [hero unaryOperation:PERC andOp:number];
	}
	else if ([function isEqualToString:@"LOGTEN"]) {
		result = [hero unaryOperation:LOG10 andOp:number];
	}
	else if ([function isEqualToString:@"SQRT"]) {
		result = [hero unaryOperation:SQRRT andOp:number];
	}
	else if ([function isEqualToString:@"Sin"]) {
		result = [hero unaryOperation:SIN andOp:number];
	}
	else if ([function isEqualToString:@"Cos"]) {
		result = [hero unaryOperation:COS andOp:number];
	}
	else if ([function isEqualToString:@"Tan"]) {
		result = [hero unaryOperation:TAN andOp:number];
	}
	else if ([function isEqualToString:@"Sinh"]) {
		result = [hero unaryOperation:SINH andOp:number];
	}
	else if ([function isEqualToString:@"Cosh"]) {
		result = [hero unaryOperation:COSH andOp:number];
	}
	else if ([function isEqualToString:@"Tanh"]) {
		result = [hero unaryOperation:TANH andOp:number];
	}
	else if ([function isEqualToString:@"CUBERT"]) {
		result = [hero unaryOperation:CUBERT andOp:number];
	}
	else if ([function isEqualToString:@"SININV"]) {
		result = [hero unaryOperation:SININV andOp:number];
	}
	else if ([function isEqualToString:@"COSINV"]) {
		result = [hero unaryOperation:COSINV andOp:number];
	}
	else if ([function isEqualToString:@"TANINV"]) {
		result = [hero unaryOperation:TANINV andOp:number];
	}
	return result;
}

-(void)dealloc
{
	[hero release];
	[super dealloc];
}

@end
