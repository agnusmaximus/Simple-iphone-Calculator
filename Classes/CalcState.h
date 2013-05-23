//
//  CalcState.h
//  Calculator2
//
//  Created by Max Lam on 5/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	Monitors the states of the calculator

#import <UIKit/UIKit.h>
#import "Macros.h"

@interface CalcState : NSObject {
	int CALCULATOR_MODE;
	
	BOOL stateOK;
	BOOL scientificChng;
	
	int DEGOrRad;
	
	int numFunctionBar;
}

+(CalcState *)sharedState;
-(void)chngSci;

@property (nonatomic, readwrite) BOOL stateOK;
@property (nonatomic, readwrite) BOOL scientificChng;
@property (nonatomic, readwrite) int DEGOrRad;
@property (nonatomic, readwrite) int CALCULATOR_MODE;
@property (nonatomic, readwrite) int numFunctionBar;

@end
