//
//  LEDScreen.m
//  Calculator2
//
//  Created by Max Lam on 5/16/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	The LED screen portion of the calculator
//  Should act as a black box
//	Implements a stack to keep track of characters pushed and popped

#import "LEDScreen.h"


@implementation LEDScreen

-(id)init
{
	[super init];
	//Dont clear on next input
	clearOnNextInput = NO;
	num_concats = 0;
	return self;
}

-(void)awakeFromNib {
	//Customiz the LED Screen
	[LEDscreen setFont:[UIFont fontWithName:[NSString stringWithUTF8String:CALC_FONT] size:CALC_FONT_SIZE]];
	[LEDscreen setText:@"0"];
	
	[LEDoperator setFont:[UIFont fontWithName:[NSString stringWithUTF8String:CALC_FONT] size:CALC_OPERATOR_SIZE]];
	[LEDoperator setText:@""];
	
	[degOrRad setFont:[UIFont fontWithName:[NSString stringWithUTF8String:CALC_FONT] size:CALC_OPERATOR_SIZE]];
	[degOrRad setText:@"rad"];
}

-(void)setScreenString:(NSString *)text {
	//Set the screen string to a value
	[LEDscreen setText:text];
	if (DEBUG_LED) {
		NSLog(@"LED: String set to %@",text);
	}
}

-(NSString *)screenString {
	return [LEDscreen text];
}

-(void)setOperatorString:(NSString *)text {
	//Dont clear operator on next input
	clearOpOnNextInput = NO;
	[LEDoperator setText:text];
}

-(NSString *)operatorString {
	return [LEDoperator text];
}

-(void)addToScreenString:(NSString *)addon {
	//Concatenate existing screen string to addon	
	//If clear on next input, clear and set BOOL as NO
	if (clearOnNextInput == YES) {
		[self setScreenString:@"0"];
		clearOnNextInput = NO;
	}
	
	//Clear the operator as well
	if (clearOpOnNextInput == YES) {
		[self setOperatorString:@""];
		clearOpOnNextInput = NO;
	}
	
	//Check if the string is "0"
	char *string;
	string = (char *)[[LEDscreen text]UTF8String];
	if (string[0] != '0') {
		NSString *newString = [[LEDscreen text] stringByAppendingString:addon];
		[self setScreenString:newString];
	}
	else {
		[self setScreenString:addon];
	}
}

-(void)deleteFromScreenString {
	//Delete a character from screen string
	char *string = (char *)[[LEDscreen text]UTF8String];
	if (strlen(string) > 1) {
		string[strlen(string)-1]='\0';
		[self setScreenString:[NSString stringWithUTF8String:string]];
	}
	else {
		//No more numbers -- back to zero
		[self setScreenString:@"0"];
	}
}

-(void)blink {
	//Blink
	[LEDscreen setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
	[NSTimer scheduledTimerWithTimeInterval:.15 target:self selector:@selector(unblink) userInfo:NULL repeats:NO];
}

-(void)unblink {
	//Unblink
	[LEDscreen setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)concatenateToString:(NSString *)string
{	
	num_concats = [string length];
	
	if (clearOnNextInput == YES ) {
		if ([string characterAtIndex:0] >= '0' &&
			[string characterAtIndex:0] <= '9') 
			[self setScreenString:@"0"];
		clearOnNextInput = NO;
	}
	
	LEDoperator.text = @"";
	if ([LEDscreen.text length] <= 1 &&
		[LEDscreen.text characterAtIndex:0] == '0') {
		LEDscreen.text = @"";
	}
	[self setScreenString:[LEDscreen.text stringByAppendingString:string]];
}

-(void)deleteLastFromString
{	
	if (clearOnNextInput == YES) {
		[self setScreenString:@"0"];
		clearOnNextInput = NO;
	}	
	
	LEDoperator.text = @"";
	if ([LEDscreen.text length] <= 0) 
		return;
	if ([LEDscreen.text length] == 1) {
		LEDscreen.text = @"0";
	}
	else {
		[self setScreenString:[LEDscreen.text substringToIndex:[LEDscreen.text length]-1]];
	}
}

-(void)dealloc {
	[super dealloc];
}

@synthesize clearOnNextInput;
@synthesize clearOpOnNextInput;
@synthesize LEDscreen;
@synthesize degOrRad;

@end
