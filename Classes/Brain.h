//
//  Brain.h
//  Calculator2
//
//  Created by Max Lam on 5/16/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This portion of code does the calculations
//	It will also implement a queue in objective c to store actions
//	Remember: Operators are always NSNumbers 
//			  Normal numbers are always strings
//	This class does the main brunt of computation: +, -,/ ,*

#import <UIKit/UIKit.h>
#import <math.h>
#import "Macros.h"
#import "CalcState.h"

#define BRAIN_DEBUG 0

@interface Brain : NSObject {
	NSMutableArray *queue;
}

//Queue operations
-(void)pushQueue:(id)sender;
-(id)popQueue;
-(id)firstQueue;
-(id)lastQueue;
-(void)emptyQueue;

//Computation operations
-(id)computeQueue;
-(double)computeStarting:(int)index withSum:(double)result;
-(double)segwayOperate:(double *)result withOp:(int)op andAmount:(double)amount;
-(id)update;
-(BOOL)isOpGreaterOrEqualTo:(int)op1 and:(int)op2;
-(double)condense:(int)index initial:(double)result;

@end
