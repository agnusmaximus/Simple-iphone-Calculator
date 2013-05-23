//
//  ValidFunctions.m
//  Equations Calculator
//
//  Created by Max Lam on 11/27/10.
//  Copyright 2010 Max Lam. All rights reserved.
//

#import "ValidFunctions.h"
#import "Macros.h"

@implementation ValidFunctions

-(id)init
{
	[super init];
	validFunctions=[[NSMutableArray alloc]init];
	functionParameters=[[NSMutableArray alloc]init];
	mnemonic=[[NSMutableArray alloc]init];
	
	//Scan from the functions list
	[self scanFunctionsList];
	
	//Register self as an observer
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(handleUserFunctionResult:) name:@"computeUserFunction" object:nil];
	[nc addObserver:self selector:@selector(handleToggleChanges:) name:@"toggle" object:nil];
	
	goodToGo=NO;
	
	return self;
}

-(void)scanFunctionsList
{
	//FILE *file=fopen("FunctionsList.txt", "r");
	NSBundle *main=[NSBundle mainBundle];
	NSString *path=[main bundlePath];
	path=[path stringByAppendingString:@"/Contents/Resources/FunctionsList.txt"];
	NSFileHandle *file;
	
	file=[NSFileHandle fileHandleForReadingAtPath:path];
	NSString *fileContents=[[NSString alloc]initWithData:[file readDataToEndOfFile] encoding:NSASCIIStringEncoding];
	NSArray *split=[fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[fileContents release];
	for (int x = 0; x < [split	count]; x+=3) {
		[validFunctions addObject:[split objectAtIndex:x]];
	}
	for (int x = 1; x < [split	count]; x+=3) {
		[functionParameters addObject:[split objectAtIndex:x]];
	}
	for (int x = 2; x < [split	count]; x+=3) {
		[mnemonic addObject:[split objectAtIndex:x]];
	}
}

-(BOOL)findFunction:(NSString *)functionToFind
{
	//Yes if function exists, No if inexistant
	for (int x = 0; x < [validFunctions count]; x++){
		if ([functionToFind isEqualToString:[validFunctions objectAtIndex:x]]) {
			return YES;
		}
	}
	return NO;
}
-(int)numFunctionParameter:(NSString *)function
{
	//This function assumes findFunction was called
	int place=0;
	for (int x = 0; x < [validFunctions count]; x++){
		if ([function isEqualToString:[validFunctions objectAtIndex:x]]) {
			place=x;
		}
	}
	return [[functionParameters objectAtIndex:place]intValue];
}

-(int)lookupMnemonic:(NSString *)function
{
	int place=0;
	for (int x = 0; x < [validFunctions count]; x++){
		if ([function isEqualToString:[validFunctions objectAtIndex:x]]) {
			place=x;
		}
	}
	return [[mnemonic objectAtIndex:place]intValue];
}

-(NSNumber *)evaluateUnaryFunction:(NSString *)function numbers:(double)number
{
	//get Mnemonic
	int num=[self lookupMnemonic:function];
	switch (num) {
		case TAN:
			return [NSNumber numberWithDouble:tan(number)];
		case COS:
			return [NSNumber numberWithDouble:cos(number)];
		case SIN:
			return [NSNumber numberWithDouble:sin(number)];
		case SININV:
			return [NSNumber numberWithDouble:asin(number)];
		case COSINV:
			return [NSNumber numberWithDouble:acos(number)];
		case TANINV:
			return [NSNumber numberWithDouble:atan(number)];
		case SINH:
			return [NSNumber numberWithDouble:sinh(number)];
		case TANH:
			return [NSNumber numberWithDouble:tanh(number)];
		case COSH:
			return [NSNumber numberWithDouble:cosh(number)];
		case INV:
			return [NSNumber numberWithDouble:(1/number)];
		case LOG2:
			return [NSNumber numberWithDouble:log2(number)];
		case LOG10:
			return [NSNumber numberWithDouble:log10(number)];
		case CUBERT:
			return [NSNumber numberWithDouble:cbrt(number)];
		case SQRRT:
			return [NSNumber numberWithDouble:sqrt(number)];
		default:
			return [NSNumber numberWithDouble:0];
			break;
	}
}
-(NSNumber *)evaluatePolynaryFunction:(NSString *)function numbers:(double)number1 numbers:(double)number2
{
	int num=[self lookupMnemonic:function];
	NSLog(@"num:%lf %lf",number1, number2);
	switch (num) {
		case XPOWY:
			//NSLog(@"Func:%@",[NSNumber numberWithDouble:pow(number1, number2)]);
			return [NSNumber numberWithDouble:pow(number1, number2)];
		case XRTY:
			return [NSNumber numberWithDouble:pow(number1, 1/number2)];
		default:
			return [NSNumber numberWithDouble:0];
			break;
	}
}

-(NSMutableArray *)returnAllFunctionsInArray
{
	NSMutableArray *returnArray=[[[NSMutableArray alloc]init]autorelease];
	for (int x = 0; x < [validFunctions count]; x++)
		[returnArray addObject:[validFunctions objectAtIndex:x]];
	return returnArray;
}

-(void)handleUserFunctionResult:(NSNotification *)note
{
	userFunctionResult=[[note userInfo]objectForKey:@"result"];
}
				
-(void)handleToggleChanges:(NSNotification *)note
{
	if ([[[note userInfo]objectForKey:@"whichSign"]isEqualToString:@"checkmark"])
		goodToGo=YES;
	else 
		goodToGo=NO;
}


-(void)dealloc
{
	NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}

@end
