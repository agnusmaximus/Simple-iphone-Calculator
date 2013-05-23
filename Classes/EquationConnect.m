//
//  EquationConnect.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "EquationConnect.h"


@implementation EquationConnect

-(id)initWithLEDScreen:(LEDScreen *)screen
{
	[super init];
	ledscreen = screen;
	brain = [[EquationBrain alloc]init];
	effects = [[Sound alloc]init];
	return self;
}	

-(void)receive:(id)sender
{	
	[effects click];
	
	UIButton *buttonPressed = sender;
	switch (buttonPressed.tag) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
			[ledscreen concatenateToString:[NSString stringWithFormat:@"%d",buttonPressed.tag]];
			break;
		case DEL:
			[ledscreen deleteLastFromString];
			break;
		case AC:
			[ledscreen setScreenString:@"0"];
			[ledscreen setOperatorString:@""];
			break;
		case PT:
			[ledscreen concatenateToString:@"."];
			break;
		case POSNEG:
			[ledscreen concatenateToString:@"﹣"];
			break;
		case MULT:
			[ledscreen concatenateToString:@"×"];
			break;
		case DIV:
			[ledscreen concatenateToString:@"/"];
			break;
		case SUB:
			[ledscreen concatenateToString:@"-"];
			break; 
		case ADD:
			[ledscreen concatenateToString:@"+"];
			break;
		case EQU:
			if ([brain errors:[brain replaceMultiplyWithStar:[ledscreen screenString]]]) {
				BOOL isNeg = NO;
					
				//Error free -- compute;
				
				[footprints addToInput:[ledscreen screenString]];
				
				double result = [brain compute:[brain replaceMultiplyWithStar:[ledscreen screenString]] andSum:0];
				
				if (result < 0) {
					isNeg = YES;
				}
				
				NSString *stringResult = [NSString stringWithFormat:@"%g",result];
				
				if (isNeg) {
					stringResult = [stringResult stringByReplacingOccurrencesOfString:@"-" withString:@"﹣"];
				}
				
				[footprints addToOutput:stringResult];
				
				[ledscreen setScreenString:stringResult];
				[ledscreen setOperatorString:@""];
				[brain setRes:0];
				[ledscreen setClearOnNextInput:YES];
			}
			else {
				[effects error];
				[ledscreen setOperatorString:@"err"];
			}
			break;
		case SCIE:
			[ledscreen concatenateToString:@"e+"];
			break;
		case INV:
			[ledscreen concatenateToString:@"1/"];
			break;
		case PI:
			[ledscreen concatenateToString:@"3.141592654"];
			break;
		case DEGTORAD:
			if ([CalcState sharedState].DEGOrRad == RAD) {
				[[CalcState sharedState] setDEGOrRad:DEG];
				ledscreen.degOrRad.text = @"deg";
			}
			else {
				[[CalcState sharedState] setDEGOrRad:RAD];
				ledscreen.degOrRad.text = @"rad";
			}
			break;
		case MORPHBUTTONS:
			[self morphButtons];
			break;
		case FACT:
			[ledscreen concatenateToString:@"!("];
			break;
		case CUBE:
			[ledscreen concatenateToString:@"^3"];
			break;
		case SQR:
			[ledscreen concatenateToString:@"^2"];
			break;
		case LOG2:
			[ledscreen concatenateToString:@"Log₂("];
			break;
		case PERC:
			[ledscreen concatenateToString:@"%("];
			break;
		case LOG10:
			[ledscreen concatenateToString:@"Log₁₀("];
			break;
		case SQRRT:
			[ledscreen concatenateToString:@"2√"];
			break;
		case SIN:
			[ledscreen concatenateToString:@"Sin("];
			break;
		case COS:
			[ledscreen concatenateToString:@"Cos("];
			break;
		case TAN:
			[ledscreen concatenateToString:@"Tan("];
			break;
		case SINH:
			[ledscreen concatenateToString:@"Sinh("];
			break;
		case COSH:
			[ledscreen concatenateToString:@"Cosh("];
			break;
		case TANH:
			[ledscreen concatenateToString:@"Tanh("];
			break;
		case CUBERT:
			[ledscreen concatenateToString:@"3√"];
			break;
		case TWOEXP:
			[ledscreen concatenateToString:@"2^"];
			break;
		case E:
			[ledscreen	concatenateToString:@"2.718281"];
			break;
		case SININV:
			[ledscreen concatenateToString:@"Sin⁻¹("];
			break;
		case COSINV:
			[ledscreen concatenateToString:@"Cos⁻¹("];
			break;
		case TANINV:
			[ledscreen concatenateToString:@"Tan⁻¹("];
			break;
			
		case RIGHT_PAR:
			[ledscreen concatenateToString:@")"];
			break;
		case XRTY:
			[ledscreen concatenateToString:@"√"];
			break;
		case XPOWY:
			[ledscreen concatenateToString:@"^"];
			break;
		case LEFT_PAR:
			[ledscreen concatenateToString:@"("];
			break;
	}
}

-(void)morphButtons
{
	static BOOL morphed = YES;
	if ([delegate respondsToSelector:@selector(morphAll:)])
		[delegate morphAll:morphed];
	morphed = !morphed;
}

-(void)dealloc
{
	[brain release];
	[effects release];
	[super dealloc];
}

@synthesize delegate;
@synthesize footprints;

@end
