//
//  SpinalCord.m
//  Calculator2
//
//  Created by Max Lam on 5/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "SpinalCord.h"

#define CONVDEGTORAD(x) (x/180*PI_VALUE)

@implementation SpinalCord

-(id)init
{
	[super init];
	binaryQueue = [[NSMutableArray alloc]init];
	return self;
}

-(void)pushbinaryQueue:(id)sender
{
	if (SPINE_DEBUG) {
		NSLog(@"Spine: pushing %@",sender);
	}
	
	[binaryQueue addObject:sender];
}

-(id)popbinaryQueue
{
	if ([binaryQueue count] > 0) {
		//id value = [[binaryQueue objectAtIndex:0] retain];
		id value = [binaryQueue objectAtIndex:0];
		[binaryQueue removeObjectAtIndex:0];
		
		if (SPINE_DEBUG) {
			NSLog(@"Spine: popping %@",value);
		}
		return value;
	}
	return 0;
}

-(id)firstbinaryQueue
{
	if (SPINE_DEBUG) {
		NSLog(@"Spine: first %@",[binaryQueue objectAtIndex:0]);
	}
	return [binaryQueue objectAtIndex:0];
}

-(id)lastbinaryQueue
{
	if (SPINE_DEBUG) {
		NSLog(@"Spine: last %@",[binaryQueue objectAtIndex:[binaryQueue count]-1]);
	}
	return [binaryQueue objectAtIndex:[binaryQueue count]-1];
}

-(void)emptybinaryQueue
{
	if (SPINE_DEBUG) {
		NSLog(@"Spine: emptying binaryQueue");
	}
	[binaryQueue removeAllObjects];
}

-(BOOL)isQueueEmpty
{
	if ([binaryQueue count] <= 0)
		return YES;
	return NO;
}

-(double)unaryOperation:(int)signal andOp:(double)operand
{
	//Calculate unary operation...
	if (SPINE_DEBUG) {
		NSLog(@"Spine: signal %d with operand %lf",signal, operand);
	}
	
	
	if ([[CalcState sharedState] DEGOrRad] == DEG) {
		switch (signal) {
			case SIN:
			case COS:
			case TAN:
			
				if (signal == TAN && ceil(operand)-operand == 0) {
					//Return infinity if 90..270....
					if ((int)operand % 90 == 0) {
						if ((int)operand % 180 != 0 &&
							operand != 0) {
							return INFINITY;
						}
					}
				}
				operand = CONVDEGTORAD(operand);
				break;
		}
	}
	
	
	long  double result = 0;
	
	//Determine which unary operation to perform on operand... self explanatory
	switch (signal) {
		case INV:
			result = 1/operand;
			break;
		case SQRRT:
			result = sqrt(operand);
			break;
		case SQR:
			result = operand * operand;
			break;
		case CUBE:
			result = operand * operand * operand;
			break;
		case SIN:
			result = sin(operand);
			break;
		case COS:
			result = cos(operand);
			break;
		case TAN:
			result = tan(operand);
			break;
		case LOG2:
			result = log10(operand)/log10(2);
			break;
		case LOG10:
			result = log10(operand);
			break;
		case PI:
			result = PI_VALUE;
			break;
		case E:
			result = E_VALUE;
			break;
		case SINH:
			result = sinh(operand);
			break;
		case COSH:
			result = cosh(operand);
			break;
		case TANH:
			result = tanh(operand);
			break;
		case FACT:
			if (operand > 100 ||
				operand < 0) {
				result = NAN;
			}
			else {
				result = [self factorial:operand :operand];
			}
			break;
		case POSNEG:
			result = operand*-1;
			break;
		case CUBERT:
			result = pow(operand, ((double)1/3));
			break;
		case SININV:
			result = asin(operand);
			break;
		case COSINV:
			result = acos(operand);
			break;
		case TANINV:
			result = atan(operand);
			break;
		case TWOEXP:
			result = pow(2, operand);
			break;
		case PERC:
			result = operand * .01;
			break;
	}
	
	if ([[CalcState sharedState] DEGOrRad] == DEG) {
		switch (signal) {
			case SININV:
			case COSINV:
			case TANINV:
				result = result * 180 / PI_VALUE;
				break;
		}
	}
	
	return result;
}

-(double)factorial:(double)index :(double)result
{
	//Recursive function that calculates the factorial
	if (ceil(result) != result) {
		return NAN;
	}
	if (index - 1 <= 1) {
		return result;
	}
	result *= index-1;
	return [self factorial:index-1 :result];	
}

-(double)binaryOperation
{
	//Calculate binary operation from the queue
	//Check

	double result = [self compute:0 initial:0];
	return result;
}

-(double)compute:(int)index initial:(double)initial
{
	//Recursive computation for spinal cord
	
	if ([binaryQueue count] == 1) {
		//Last number left is the answer
		double result = [[binaryQueue objectAtIndex:0] doubleValue];
		[self emptybinaryQueue];
		return result;
	}
	
	double replacement;
	
	//Find out which index to calculate first:
	//E.g: 4^5		[binaryQueue count] - 1 is 5
	//Therefore [binaryQueue count] - 3 is 4
	int indexToCalculate = [binaryQueue count]-3;
	replacement = [self grind:indexToCalculate];
	//Get rid of these three
	[binaryQueue removeLastObject];
	[binaryQueue removeLastObject];
	[binaryQueue removeLastObject];
	
	if (isinf(replacement)) {
		//Infinite value reached
		return INFINITY;
	}
	
	//Now add the replacement to the end
	[self pushbinaryQueue:[NSString stringWithFormat:@"%lf",replacement]];
	return [self compute:0 initial:0];
}

-(double)grind:(int)index
{
	//Grind it up!
	double result;
	
	//What is the operation
	switch ([[binaryQueue objectAtIndex:index+1]intValue]) {
		case XPOWY:
			result = pow([[binaryQueue objectAtIndex:index]doubleValue], 
						 [[binaryQueue objectAtIndex:index+2]doubleValue]);
			break;
		case XRTY:
			result = pow([[binaryQueue objectAtIndex:index]doubleValue],
						 1/[[binaryQueue objectAtIndex:index+2]doubleValue]);
			break;
			result = [[binaryQueue objectAtIndex:index]doubleValue] * pow(10, [[binaryQueue objectAtIndex:index+2]doubleValue]);
			break;
		default:
			result = 0;
			break;
	}
	return result;
}

-(void)dealloc
{
	[binaryQueue release];
	[super dealloc];
}

@end
