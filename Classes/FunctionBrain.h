//
//  FunctionBrain.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/8/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	Computes correct function given string

#import <UIKit/UIKit.h>
#import "SpinalCord.h"
#import "Macros.h"

@interface FunctionBrain : NSObject {
	SpinalCord *hero;
}

-(double)functionWithFunction:(NSString *)function andNumber:(double)number;

@end
