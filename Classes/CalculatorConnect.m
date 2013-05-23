//
//  CalculatorFrontObj.m
//  Calculator2
//
//  Created by Max Lam on 5/16/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This class is the connective tissue of the calculator 
//	-- the main control center.
//
//	Button clicks are processed here and commands are sent 
//	in response to areas of calculations, such as the brain and
//	Spinal cord. 
//
//	The Brain and the Spinal cord classes do the calculations.
//	Both center around queues as the main algorithm
//
//	The Spinal cord computes unary operations and the highest
//	precedence operators (such as pow(x,y) or sqrrt(x))
//
//	The Brain computes low-level to mid-level precedence
//	operators such as addition, subtraction, division and multiplication.
//	The brain handles most of the normal stuff.
//
//	Other classes are self-explanatory -- there is a LEDScreen class
//	to represent what the user sees -- this in and of itself is pretty
//	much a stack.
//	
//	The CalcButtons class is almost useless. All it does is transfer button
//	clicks to our class here.
//
//	The MyWindow and MyButton class are for user-interface customization
//	I know the color scheme looks horrible, but I can't stand the dreary grey look
//	of most mac-applications.

#import "CalculatorConnect.h"
#import "FootPrints.h"

@implementation CalculatorConnect

-(id)init {
	//Create the brain
	brain = [[Brain alloc]init];
	
	//Create the spinal cord
	spinalCord = [[SpinalCord alloc]init];
	
	//Create sounds
	mysounds = [[Sound alloc]init];
	
	//User has not pressed anything yet
	lastOperator = AC;
	lastButton = AC;
	
	return self;
}

-(void)update:(id)sender {		
	//Make a clicking sound
	//[mysounds click];
	
	if ([sender tag] == MORPHBUTTONS) {
		//Change calculator state
		[[CalcState sharedState] chngSci];
		[self morphButtons];
	}
	
	if ([sender tag] == AC) {
		//Reset everything
		[screenObj setScreenString:@"0"];
		[screenObj setOperatorString:@""];
		[brain emptyQueue];
		lastOperator = AC;
		[[CalcState sharedState] setStateOK:YES];
		[footprints addToInput:[NSNumber numberWithInt:AC]];
	}
	
	
	//Check if the calculator state is ok
	if ([[CalcState sharedState] stateOK] == NO) {
		//Make error sound
		[mysounds error];
		[screenObj setScreenString:@"nan"];
		return;
	}
	
	//Make clicking sound 
	[mysounds click];
	
	//Update is delegated by buttonsObj whenever it detects that a button is pressed
	switch ([sender tag]) {
		//Numbers
		case ZERO:
		case ONE:
		case TWO:
		case THREE:
		case FOUR:
		case FIVE:
		case SIX:
		case SEVEN:
		case EIGHT:
		case NINE:
			//For numbers, just concatenate them onto the display
			[screenObj addToScreenString:[NSString stringWithFormat:@"%d",[sender tag]]];
			break;
		case PT:
			//Decimals
			[screenObj addToScreenString:@"."];
			break;
		case SCIE:
			[screenObj addToScreenString:@"e+"];
			break;
		//Calculator tasks
		case DEL:
			//Delete from the screen string
			[screenObj deleteFromScreenString];
			break;
		//Operations
		case ADD:
		case SUB:
		case MULT:
		case DIV:
			//Make screen blink
			[screenObj blink];
				
			BOOL isExprExp = NO;
			
			//If last button was not an operator
			if ([self isLastButtonNormalPrecedence]) {
				//If user wants to change his sign:
				//Pop the number and the sign
				[brain popQueue];
				[brain popQueue];
				
				//Pop from footprints as well
				[footprints popFromInput];
				[footprints popFromInput];
				
				//And now add it again
			}
			if ([self isLastButtonHigherPrecedence]) {
				//Transfer
				[spinalCord popbinaryQueue];
				[spinalCord popbinaryQueue];
				
				[footprints popFromInput];
				[footprints popFromInput];
			}
			
			//First check for XRTY and XPOWY
			if ([self isLastOperatorHigherPrecedence] && ![spinalCord isQueueEmpty]) {
				//Push values
				[spinalCord	pushbinaryQueue:[screenObj screenString]];
				//This operator is xrty or xpowy
				[footprints addToInput:[screenObj screenString]];
				isExprExp = YES;
				
				//Compute these values first
				double result = [spinalCord binaryOperation];
				[screenObj setScreenString:[NSString stringWithFormat:@"%.8lf",result]];
			}
			
			//If last move was All Clear, user wants a negative sign
			if (lastButton != AC) {
				//Push value stored in LED onto stack
				[brain pushQueue:[screenObj screenString]];
				//Also add it to the footprints
				if (!isExprExp) //Dont double add
					[footprints addToInput:[screenObj screenString]];
			}
			//Check value again and set screen operator sign to the tag's operator
			switch ([sender tag]) {
				case ADD:
					[screenObj setOperatorString:@"+"];
					break;
				case SUB:
					[screenObj setOperatorString:@"-"];
					break;
				case DIV:
					[screenObj setOperatorString:@"÷"];
					break;
				case MULT:
					[screenObj setOperatorString:@"×"];
					break;
			}	
			
			//Push the operator onto the stack
			[brain pushQueue:[NSNumber numberWithInt:[sender tag]]];
			[footprints addToInput:[NSNumber numberWithInt:[sender tag]]];
				
			id update =	[brain update];
			
			[screenObj setScreenString:[update stringValue]];
			
			//Clear the screen on the next input
			[screenObj setClearOnNextInput:YES];
				
			//User has pressed an operator
			lastOperator = [sender tag];
			break;
		case EQU:
			//Make screen blink
			[screenObj blink];
			
			BOOL isExpPushedToFootprints = NO;
			
			//First check for XRTY and XPOWY
			if ([self isLastOperatorHigherPrecedence] && ![spinalCord isQueueEmpty]) {
				//Push value
				[spinalCord	pushbinaryQueue:[screenObj screenString]];
				
				//Push also to footprints
				[footprints addToInput:[screenObj screenString]];
				//This is an exponent that we have pushed already to footprints
				isExpPushedToFootprints = YES;
			
					
				//Compute these values first
				double result = [spinalCord binaryOperation];
				[screenObj setScreenString:[NSString stringWithFormat:@"%.8lf",result]];
			}
						
			//Push original string into brain
			[brain pushQueue:[screenObj screenString]];
			if (!isExpPushedToFootprints) {		//Dont double push a string
				//Push it to to footprints as well
				//if (lastOperator < 18 || lastOperator > 33 &&
				//	lastOperator < 37 || lastOperator > 41)
					[footprints addToInput:[screenObj screenString]];
			}
			
			[brain pushQueue:@"="];
			
			//Return the result to the screen
			
			//Brain, compute the result
			[brain update];
			id result = [brain computeQueue];
			
			//Set the LED to be the result
			[screenObj setScreenString:[result stringValue]];
			
			//Also record it in history
			[footprints addToOutput:[result stringValue]];
			
			//Set screen operator sign
			[screenObj setOperatorString:@"="];
			
			//Last operator now equals
			lastOperator = [sender tag];
			
			[screenObj setClearOnNextInput:YES];
			[screenObj setClearOpOnNextInput:YES];
			break;
		case INV:
		case SQRRT:
		case SQR:
		case CUBE:
		case SIN:
		case COS:
		case TAN:
		case LOG2:
		case LOG10:
		case PI:
		case E:
		case SINH:
		case COSH:
		case TANH:
		case FACT:
		case POSNEG:
		case CUBERT:
		case SININV:
		case COSINV:
		case TANINV:
		case TWOEXP:
		case PERC:
			//Make screen blink
			[screenObj blink];
			
			//Push screen string into footprints
			//[footprints addToInput:[screenObj screenString]];
			
			//Push the unary operator into footprints
			//[footprints addToInput:[NSNumber numberWithInt:[sender tag]]];
			
			double unary_result = [spinalCord unaryOperation:[sender tag] andOp:[[screenObj screenString]doubleValue]];
			
			//Unary operations
			//Set the screen string to result
			[screenObj setScreenString:[NSString stringWithFormat:@"%.8lf", unary_result]];
			//Add to output as well
			//[footprints addToOutput:[NSString stringWithFormat:@"%lf",unary_result]];
			
			//Clear next input
			[screenObj setClearOnNextInput:YES];
			
			//lastOperator = [sender tag];		//Dont put this here -- it messes things up!
			
			//Dont save this as an operator performed -- it doesnt matter
			break;
		case XRTY:
		case XPOWY:
			//Make screen blink
			[screenObj blink];
			
			switch ([sender tag]) {
				case XPOWY:
					[screenObj setOperatorString:@"yˣ"];
					break;
				case XRTY:
					[screenObj setOperatorString:@"x√y"];
					break;
			}
			
			//Special operations
			if ([self isLastButtonHigherPrecedence]) {
				[spinalCord popbinaryQueue];
				[spinalCord popbinaryQueue];
				
				//Pop from footprints
				[footprints popFromInput];
				[footprints popFromInput];
			}
			if ([self isLastButtonNormalPrecedence]) {
				//Get pop two from other queue -- in a way a transfer
				[brain popQueue];
				[brain popQueue];
				
				//Pop from footprints
				[footprints popFromInput];
				[footprints popFromInput];
			}
			[spinalCord	pushbinaryQueue:[screenObj screenString]];
			//Push into footprints
			[footprints addToInput:[screenObj screenString]];
			//Add operator to footprints
			[footprints addToInput:[NSNumber numberWithInt:[sender tag]]];
			[spinalCord pushbinaryQueue:[NSNumber numberWithInt:[sender tag]]];
			[screenObj setClearOnNextInput:YES];
			
			lastOperator = [sender tag];
			break;
		case DEGTORAD:
			if ([[CalcState sharedState] DEGOrRad] == DEG) {
				[[CalcState sharedState] setDEGOrRad:RAD];
				screenObj.degOrRad.text = @"rad";
			}
			else {
				[[CalcState sharedState] setDEGOrRad:DEG];
				screenObj.degOrRad.text = @"deg";
			}
			
			break;
	}
	if ([[screenObj screenString]isEqualToString:@"inf"] ||
		[[screenObj screenString]isEqualToString:@"-inf"] ||
		[[screenObj screenString]isEqualToString:@"nan"]) {
		[[CalcState sharedState]setStateOK:NO];
	}
	
	//User has pressed a button
	lastButton = [sender tag];
}

-(BOOL)isLastButtonNormalPrecedence
{
	//Return yes if last button was either of these: +,/,-,*
	if (lastButton == ADD ||
		lastButton == SUB ||
		lastButton == DIV ||
		lastButton == MULT)
		return YES;
	return NO;
}

-(BOOL)isLastOperatorHigherPrecedence
{
	//return yes if last operator is either XRT, XPOWY, or another user defined function
	if (lastOperator == XRTY ||
		lastOperator == XPOWY)
		return YES;
	return NO;
}

-(BOOL)isLastButtonHigherPrecedence
{
	//return yes if last button is either XRT...
	if (lastButton == XRTY ||
		lastButton == XPOWY)
		return YES;
	return NO;
}

-(void)morphButtons
{
	if ([delegate respondsToSelector:@selector(morphAll:)]) {
		[delegate morphAll:[[CalcState sharedState] scientificChng]];
	}
}

-(void)dealloc {
	[brain release];
	[spinalCord	release];
	[mysounds release];
	[super dealloc];
}

@synthesize footprints;
@synthesize delegate;

@end
