//
//  SpinalCord.h
//  Calculator2
//
//  Created by Max Lam on 5/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This Class is called the spinal cord because it
//	does some calculations that are returned immediately
//  and does not require the brain to calculate it
//	E.G: Sqr, Sqrrt, +/-, etc ... all are return immediately to
//	the screen
//	In fact, most of the calculations are unary operations --
//	they don't require a second operand

#import <UIKit/UIKit.h>
#import <math.h>
#import "Macros.h"
#import "CalcState.h"

#define SPINE_DEBUG 0

@interface SpinalCord : NSObject {
	NSMutableArray *binaryQueue;
}

//Calculate Unary Operations
-(double)unaryOperation:(int)signal andOp:(double)operand;
-(double)factorial:(double)index :(double)result;

//Calculate Binary Operation from the binaryQueue
-(double)binaryOperation;

//binaryQueue operations
-(void)pushbinaryQueue:(id)sender;
-(id)popbinaryQueue;
-(id)firstbinaryQueue;
-(id)lastbinaryQueue;
-(void)emptybinaryQueue;
-(BOOL)isQueueEmpty;

-(double)compute:(int)index initial:(double)initial;
-(double)grind:(int)index;

@end
