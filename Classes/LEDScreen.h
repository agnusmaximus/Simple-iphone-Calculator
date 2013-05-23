//
//  LEDScreen.h
//  Calculator2
//
//  Created by Max Lam on 5/16/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This object acts as the screen of the calculator
//	Should be self explanatory

#import <UIKit/UIKit.h>
#import "string.h"
#import "CalcState.h"

#define DEBUG_LED 0

//Font for the output

#define CALC_FONT "orbitron"
#define CALC_FONT_SIZE 25
#define CALC_OPERATOR_SIZE 16

@interface LEDScreen : NSObject {
	IBOutlet UITextField *LEDscreen;
	IBOutlet UITextField *LEDoperator;
	IBOutlet UILabel *degOrRad;
	BOOL clearOnNextInput;
	BOOL clearOpOnNextInput;
	
	int num_concats;
}

-(void)setScreenString:(NSString *)stringValue;
-(NSString *)screenString;
-(void)setOperatorString:(NSString *)stringvalue;
-(NSString *)operatorString;
-(void)addToScreenString:(NSString *)addon;
-(void)deleteFromScreenString;
-(void)blink;
-(void)unblink;

//For equation mode
-(void)concatenateToString:(NSString *)string;
-(void)deleteLastFromString;

@property (readwrite,assign) BOOL clearOnNextInput;
@property (readwrite, assign) BOOL clearOpOnNextInput;
@property (nonatomic, retain) UITextField * LEDscreen;
@property (nonatomic, retain) UILabel * degOrRad;

@end
