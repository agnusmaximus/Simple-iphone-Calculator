//
//  Brain.m
//  Calculator2
//
//  Created by Max Lam on 5/16/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This part is complicated

#import "Brain.h"


@implementation Brain

-(id)init
{
	//Initialize
	[super init];
	queue = [[NSMutableArray alloc]init];
	return self;
}

//This part is the queue

-(void)pushQueue:(id)sender
{
	if (BRAIN_DEBUG) {
		NSLog(@"Brain: pushing %@",sender);
	}
	
	[queue addObject:sender];
}

-(id)popQueue
{
	//Implements the pop of queue -- self explanatory
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	if ([queue count] > 0) {
		id value = [[queue objectAtIndex:0] retain];
		[queue removeObjectAtIndex:0];
	
		if (BRAIN_DEBUG) {
			NSLog(@"Brain: popping %@",value);
		}
		
		if ([value isKindOfClass:[NSString class]]) {
			if ([value isEqualToString:@"inf"] ||
				[value isEqualToString:@"-inf"] ||
				[value isEqualToString:@"nan"]) {
				//Check if values exceed infinite
				[[CalcState sharedState] setStateOK:NO];
				[value release];
				[pool release];
				
				return [NSNumber numberWithDouble:INFINITY];
			}
		}
		[pool release];
		return [value autorelease];
	}
	return 0;
}

-(id)firstQueue
{
	if (BRAIN_DEBUG) {
		NSLog(@"Brain: first %@",[queue objectAtIndex:0]);
	}
	return [queue objectAtIndex:0];
}

-(id)lastQueue
{
	if (BRAIN_DEBUG) {
		NSLog(@"Brain: last %@",[queue objectAtIndex:[queue count]-1]);
	}
	return [queue objectAtIndex:[queue count]-1];
}

-(void)emptyQueue
{
	if (BRAIN_DEBUG) {
		NSLog(@"Brain: emptying queue");
	}
	[queue removeAllObjects];
}

//Computation area

-(id)computeQueue
{
	//Compute everything in the queue
	
	//First determine if first number is negative
	double initial_value;
	id initial_id;
	
	//Check class type and make sure its not user input
	initial_id = [self popQueue];
	
	if ([initial_id isKindOfClass:[NSNumber class]]) {
		if ((initial_value = [initial_id doubleValue]) == SUB) {
			//The first number is negative because class is NSNumber
			initial_value = [[self popQueue]doubleValue] * -1;
		}
		else {
			//Garbage op from malicious user
			[self popQueue];
		}
	}
	else {
		//
		initial_value = [initial_id doubleValue];
	}
	
	double result = [self computeStarting:0 withSum:initial_value];
	return [NSNumber numberWithDouble:result];
}

-(double)computeStarting:(int)index withSum:(double)result
{
	//Recursive computation function
	if ([queue count] == 0)
		return result;
		
	//Get the operator
	int operator = [[self popQueue] intValue];
		
	//Get the amount variable
	double amount = [[self popQueue] doubleValue];

	[self segwayOperate:&result withOp:operator andAmount:amount];
	
	return [self computeStarting:0 withSum:result];
}

-(double)segwayOperate:(double *)result withOp:(int)op andAmount:(double)amount
{
	switch (op) {
		case ADD:
			*result+=amount;
			break;
		case SUB:
			*result-=amount;
			break;
		case DIV:
			*result/=amount;
			break;
		case MULT:
			*result*=amount;
			break;
	}
	return -1;
}

-(id)update
{
	//Update the queue
	
	id result_id;
	double result;
	
	if ([queue count] < 2)
		return [NSNumber numberWithDouble:0];
	
	//Check for negatives
	result_id = [self firstQueue];
	if ([result_id isKindOfClass:[NSNumber class]]) {
		if ((result = [result_id doubleValue]) == SUB) {
			//Get rid of negative sign
			[self popQueue];
			//Multiply the next number by -1
			id number = [queue objectAtIndex:0];
			//Get rid of first number
			[self popQueue];
			//Insert the negative value back
			[queue insertObject:[NSString stringWithFormat:@"%lf",[number doubleValue]*-1]
						atIndex:0];
			
			result = [number doubleValue]*-1;
		}
		else {
			//Garbage op
			[self popQueue];
		}
	}
	else {
		result = [result_id doubleValue];
	}	

	//More than one number then condense
	if ([queue count] >= 4) {
		result = [self condense:0 initial:0];
	}
	return [NSNumber numberWithDouble:result];
}

-(double)condense:(int)index initial:(double)result
{
	if ([queue count] < index+3)
		return result;
	
	//Compare operators
	int operator1 = [[queue objectAtIndex:index+1]intValue];
	int operator2 = [[queue objectAtIndex:index+3]intValue];
	
	if ([self isOpGreaterOrEqualTo:operator1 and:operator2]) {
		//First operator is greater than second -- do computations
		double total = [[queue objectAtIndex:index]doubleValue];
		double amount = [[queue objectAtIndex:index+2]doubleValue];
		[self segwayOperate:&total withOp:operator1 andAmount:amount];
		result = total;
		//Pop the three from the stack that have been used
		[queue removeObjectAtIndex:index];
		[queue removeObjectAtIndex:index];
		[queue removeObjectAtIndex:index];
		
		//Now insert the new value in their place
		[queue insertObject:[NSString stringWithFormat:@"%lf",result] atIndex:index];
		return [self condense:0 initial:result];
	}
	else {
		if ([queue count] >= 6) {
			//Second operator is greater than first
			result = [self condense:index+2 initial:result];
			result = [self condense:0 initial:result];
		}
		else {
			//Next value is not available yet.. Return the last number user entered
			return [[queue objectAtIndex:[queue count]-2] doubleValue];
		}
	}
	return result;
}

-(BOOL)isOpGreaterOrEqualTo:(int)op1 and:(int)op2
{
	if (op1 == MULT || op1 == DIV)
		return YES;

	if (op2 == MULT || op2 == DIV)
		return NO;
	
	//Both operations are either add or subtract
	return YES;
}

-(void)dealloc
{
	[queue release];
	[super dealloc];
}

@end
