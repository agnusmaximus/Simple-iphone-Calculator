//
//  Computations.m
//  EquationsCalculator
//
//  Created by Max Lam on 11/28/10.
//  Copyright 2010 Max Lam. All rights reserved.
//

#import "Computations.h"
#import "ValidFunctions.h"
#import "Macros.h"

@implementation Computations

-(id)init
{
	[super init];
	equation=@"";
	answer=[[NSNumber alloc]init];
	numberArray=[[NSMutableArray alloc]init];
	operatorArray=[[NSMutableArray alloc]init];
	validate=[[ValidFunctions alloc]init];
	notANumber=NO;
	return self;
}

#pragma mark TRANSITIONS
-(NSString *)passEquationToComputer:(NSString *)passedEquation
{
	equation=passedEquation;
	[self ridSpaces];
	[self addMultSymbolBeforeParenthesesIfNeeded];
	equation=[self appendEqualsIfInexistant:equation];
	NSLog(@"%@",equation);
	[self splitEquation:equation into:numberArray and:operatorArray];
	NSString *holder;
	holder=[self compute:numberArray and:operatorArray];
	NSLog(@"Final Answer:%@",holder);
	[numberArray removeAllObjects];
	[operatorArray removeAllObjects];
	return holder;
}

#pragma mark COMPUTATIONS
-(NSString *)compute:(NSMutableArray *)numbers and:(NSMutableArray *)operators
{
	//Condense all expressions into plain numbers
	NSMutableArray *condensedNumbers=[[NSMutableArray alloc]init];
	for (int x = 0; x < [numbers count]; x++) {
		[condensedNumbers addObject:[self condense:[numbers objectAtIndex:x]]];
	}
	for (int x = 0; x < [condensedNumbers count]; x++ ) {
		NSLog(@"%@",[condensedNumbers objectAtIndex:x]);
	}
	//check for nan or inf values
	for (int y = 0; y < [condensedNumbers count]; y++){
		if ([[condensedNumbers objectAtIndex:y]isEqualToString:@"nan"]) {
			[condensedNumbers release];
			return @"nan";
		}
		else if([[condensedNumbers objectAtIndex:y]isEqualToString:@"inf"]){
			[condensedNumbers release];
			return @"inf";
		}
		else if([[condensedNumbers objectAtIndex:y]isEqualToString:@"-inf"]) {
			[condensedNumbers release];
			return @"-inf";
		}
	}
	for (int y = 0; y <= [condensedNumbers count]*[condensedNumbers count]*[condensedNumbers count]; y++){
		for (int x = 0; x < [condensedNumbers count]; x++) {
			if ([[operators objectAtIndex:x]isEqualToString:@"+"] &&[[operators objectAtIndex:x+1]isEqualToString:@"="] ||
				[[operators objectAtIndex:x]isEqualToString:@"+"] &&[[operators objectAtIndex:x+1]isEqualToString:@"+"] ||
				[[operators objectAtIndex:x]isEqualToString:@"+"] &&[[operators objectAtIndex:x+1]isEqualToString:@"-"] &&
				x != [condensedNumbers count]-1) {
				[condensedNumbers replaceObjectAtIndex:x withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x]]];
				[condensedNumbers replaceObjectAtIndex:x+1 withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x+1]]];
				NSNumber *value=[NSNumber numberWithDouble:[[condensedNumbers objectAtIndex:x]doubleValue]+[[condensedNumbers objectAtIndex:x+1]doubleValue]];
				[operators removeObjectAtIndex:x];
				[condensedNumbers removeObjectAtIndex:x];
				[condensedNumbers removeObjectAtIndex:x];
				[condensedNumbers insertObject:[value stringValue] atIndex:x];
				//[condensedNumbers addObject:[value stringValue]];
				//check for nan or inf values
				if ([[condensedNumbers objectAtIndex:x]isEqualToString:@"nan"]) {
					[condensedNumbers release];
					return @"nan";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"inf"]){
					[condensedNumbers release];
					return @"inf";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"-inf"]) {
					[condensedNumbers release];
					return @"-inf";
				}
				NSLog(@"%@",[value stringValue]);
				x--;
			}
			else if ([[operators objectAtIndex:x]isEqualToString:@"-"] &&[[operators objectAtIndex:x+1]isEqualToString:@"="] ||
				     [[operators objectAtIndex:x]isEqualToString:@"-"] &&[[operators objectAtIndex:x+1]isEqualToString:@"+"] ||
					 [[operators objectAtIndex:x]isEqualToString:@"-"] &&[[operators objectAtIndex:x+1]isEqualToString:@"-"] && 
					 x != [condensedNumbers count]-1) {
				[condensedNumbers replaceObjectAtIndex:x withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x]]];
				[condensedNumbers replaceObjectAtIndex:x+1 withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x+1]]];
				NSNumber *value=[NSNumber numberWithDouble:[[condensedNumbers objectAtIndex:x]doubleValue]-[[condensedNumbers objectAtIndex:x+1]doubleValue]];
				[operators removeObjectAtIndex:x];
				[condensedNumbers removeObjectAtIndex:x];
				[condensedNumbers removeObjectAtIndex:x];
				[condensedNumbers insertObject:[value stringValue] atIndex:x];
				NSLog(@"string:%@",[value stringValue]);
				//check for nan or inf values
				if ([[condensedNumbers objectAtIndex:x]isEqualToString:@"nan"]) {
					[condensedNumbers release];
					return @"nan";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"inf"]){
					[condensedNumbers release];
					return @"inf";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"-inf"]) {
					[condensedNumbers release];
					return @"-inf";
				}
				x--;
			}
			else if ([[operators objectAtIndex:x]isEqualToString:@"*"] && ![[operators objectAtIndex:x+1]isEqualToString:@"^"] &&
				x != [condensedNumbers count]-1) {
				[condensedNumbers replaceObjectAtIndex:x withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x]]];
				[condensedNumbers replaceObjectAtIndex:x+1 withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x+1]]];
				NSNumber *value=[NSNumber numberWithDouble:[[condensedNumbers objectAtIndex:x]doubleValue]*[[condensedNumbers objectAtIndex:x+1]doubleValue]];
				[operators removeObjectAtIndex:x];
				[condensedNumbers insertObject:[value stringValue] atIndex:x];
				[condensedNumbers removeObjectAtIndex:x+1];
				[condensedNumbers removeObjectAtIndex:x+1];
				//check for nan or inf values
				if ([[condensedNumbers objectAtIndex:x]isEqualToString:@"nan"]) {
					[condensedNumbers release];
					return @"nan";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"inf"]){
					[condensedNumbers release];
					return @"inf";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"-inf"]) {
					[condensedNumbers release];
					return @"-inf";
				}
				x--;
			}
			else if ([[operators objectAtIndex:x]isEqualToString:@"/"] && ![[operators objectAtIndex:x+1]isEqualToString:@"^"] &&
				x != [condensedNumbers count]-1) {
				[condensedNumbers replaceObjectAtIndex:x withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x]]];
				[condensedNumbers replaceObjectAtIndex:x+1 withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x+1]]];
				NSNumber *value=[NSNumber numberWithDouble:[[condensedNumbers objectAtIndex:x]doubleValue]/[[condensedNumbers objectAtIndex:x+1]doubleValue]];
				[operators removeObjectAtIndex:x];
				[condensedNumbers insertObject:[value stringValue] atIndex:x];
				[condensedNumbers removeObjectAtIndex:x+1];
				[condensedNumbers removeObjectAtIndex:x+1];
				//check for nan or inf values
				if ([[condensedNumbers objectAtIndex:x]isEqualToString:@"nan"]) {
					[condensedNumbers release];
					return @"nan";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"inf"]){
					[condensedNumbers release];
					return @"inf";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"-inf"]) {
					[condensedNumbers release];
					return @"-inf";
				}
				x--;
			}
			else if ([[operators objectAtIndex:x]isEqualToString:@"^"] && x != [condensedNumbers count]-1) {
				[condensedNumbers replaceObjectAtIndex:x withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x]]];
				[condensedNumbers replaceObjectAtIndex:x+1 withObject:[self ifNegConvertToNeg:[condensedNumbers objectAtIndex:x+1]]];
				NSNumber *value=[NSNumber numberWithDouble:pow([[condensedNumbers objectAtIndex:x]doubleValue],[[condensedNumbers objectAtIndex:x+1]doubleValue])];
				[operators removeObjectAtIndex:x];
				[condensedNumbers insertObject:[value stringValue] atIndex:x];
				[condensedNumbers removeObjectAtIndex:x+1];
				[condensedNumbers removeObjectAtIndex:x+1];
				//check for nan or inf values
				if ([[condensedNumbers objectAtIndex:x]isEqualToString:@"nan"]) {
					[condensedNumbers release];
					return @"nan";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"inf"]){
					[condensedNumbers release];
					return @"inf";
				}
				else if([[condensedNumbers objectAtIndex:x]isEqualToString:@"-inf"]) {
					[condensedNumbers release];
					return @"-inf";
				}
				x--;
			}
		}
	}
	NSString *value=[condensedNumbers objectAtIndex:0];
	NSLog(@"%@",[condensedNumbers objectAtIndex:0]);
	[condensedNumbers release];
	return value;
}

-(NSString *)condense:(NSString *)expression
{
	int x;
	if ([self isFunction:expression]) {
		//First get the function name
		NSString *functionName=@"";
		for (x = 0; x < [expression length]; x++) {
			if ([expression characterAtIndex:x]=='[') {
				x++;
				break;
			}
			functionName=[functionName stringByAppendingFormat:@"%c",[expression characterAtIndex:x]];
		}
		int inAnotherFunction=0;
		BOOL foundComma=NO;
		//Check if the functions has 1 or 2 parameters
		if ([validate numFunctionParameter:functionName]==2) {
			//Recursively check within function parameters 
			NSString *subEquation1=@"", *subEquation2=@"";
			//First get the two parameters
			for (x; x < [expression length]-1; x++) {
				if ([expression characterAtIndex:x]=='[') {
					inAnotherFunction++;
				}
				else if([expression characterAtIndex:x]==']' && x != [expression length]-1) {
					inAnotherFunction--;
				}
				
				if (!foundComma)
					subEquation1=[subEquation1 stringByAppendingFormat:@"%c",[expression characterAtIndex:x]];
				else if(foundComma)
					subEquation2=[subEquation2 stringByAppendingFormat:@"%c",[expression characterAtIndex:x]];
				
				if(inAnotherFunction==0 && [expression characterAtIndex:x]==',')
					foundComma=YES;
			}
			//Get rid of comma
			subEquation1=[subEquation1 substringToIndex:[subEquation1 length]-1];
			//Append equals if needed
			subEquation1=[self appendEqualsIfInexistant:subEquation1];
			subEquation2=[self appendEqualsIfInexistant:subEquation2];
			//split these two sub expressions
			NSMutableArray *number1, *number2;
			NSMutableArray *operator1, *operator2;
			number1=[[NSMutableArray alloc]init];
			number2=[[NSMutableArray alloc]init];
			operator1=[[NSMutableArray alloc]init];
			operator2=[[NSMutableArray alloc]init];
			[self splitEquation:subEquation1 into:number1 and:operator1];
			[self splitEquation:subEquation2 into:number2 and:operator2];
			//Compute these two subEquations
			NSString *value1, *value2;
			
			value1=[self compute:number1 and:operator1];
			value2=[self compute:number2 and:operator2];
			
			value1=[self ifNegConvertToNeg:value1];
			value2=[self ifNegConvertToNeg:value2];
			
			//Now depending on the function get the resulting number and return it
			expression=[[validate evaluatePolynaryFunction:functionName numbers:[value1 doubleValue] numbers:[value2 doubleValue]]stringValue];			
		}
		if ([validate numFunctionParameter:functionName]==1) {
			//1 param
			int inAnotherFunction=0;
			//Recursively check within function parameters 
			NSString *subEquation=@"";
			//First get the two parameters
			for (x; x < [expression length]-1; x++) {
				if ([expression characterAtIndex:x]=='[') {
					inAnotherFunction++;
				}
				else if([expression characterAtIndex:x]==']' && x != [expression length]-1) {
					inAnotherFunction--;
				}
				subEquation=[subEquation stringByAppendingFormat:@"%c",[expression characterAtIndex:x]];
			}
			//append equals
			subEquation=[self appendEqualsIfInexistant:subEquation];
			//Split this equation
			NSMutableArray *number, *operator;
			number=[[NSMutableArray alloc]init];
			operator=[[NSMutableArray alloc]init];
			[self splitEquation:subEquation into:number and:operator];
			NSString *value;
			value=[self compute:number and:operator];
			value=[self ifNegConvertToNeg:value];
			expression=[[validate evaluateUnaryFunction:functionName numbers:[value doubleValue]]stringValue];
		}
		return expression;
	}

	else if([self isParameterized:expression]) {
		//Split equation
		NSString *subEquation=@"";
		for (int x = 1; x < [expression length]-1; x++){
			subEquation=[subEquation stringByAppendingFormat:@"%c",[expression characterAtIndex:x]];
		}
		subEquation=[self appendEqualsIfInexistant:subEquation];
		NSLog(@"Sub:%@",subEquation);
		NSMutableArray *numbers, *operators;
		numbers=[[NSMutableArray alloc]init];
		operators=[[NSMutableArray alloc]init];
		[self splitEquation:subEquation into:numbers and:operators];
		NSString *value;
		value = [self compute:numbers and:operators];
		NSLog(@"Value:%@",value);
		expression=value;
		return expression;
	}
	else {
		return expression;
	}
}

#pragma mark MODIFYING_EQUATION
-(void)ridSpaces
{
	equation = [equation stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void)addMultSymbolBeforeParenthesesIfNeeded
{
	char previousChar=0, currentChar=0;
	NSString *newEquation=@"";
	for (int x = 0; x < [equation length]; x++){
		currentChar=[equation characterAtIndex:x];
		if (previousChar != '*' && previousChar != '-' && 
			previousChar != '/' && previousChar != '+' &&
			previousChar != '^' && previousChar != '(' &&
			currentChar == '(' &&  previousChar != '[' && 
			previousChar != ',' && x != 0) {
			newEquation=[newEquation stringByAppendingFormat:@"*"];
		}
		else if(currentChar != '*' && currentChar != '-' &&
				currentChar != '/' && currentChar != '+' &&
				currentChar != '^' && currentChar !=')' &&
				currentChar != ',' && currentChar != ']' &&
				currentChar != '=' && previousChar == ')'){
			newEquation=[newEquation stringByAppendingFormat:@"*"];
		}
		newEquation=[newEquation stringByAppendingFormat:@"%c",[equation characterAtIndex:x]];
		previousChar=currentChar;
	}
	equation=newEquation;
}

-(NSString *)appendEqualsIfInexistant:(NSString *)passedEquation
{
	if ([passedEquation characterAtIndex:[passedEquation length]-1]!='=') {
		passedEquation=[passedEquation stringByAppendingFormat:@"="];
	}
	return passedEquation;
}

#pragma mark SPLITTING_EQUATION

-(void)splitEquation:(NSString *)subEquation into:(NSMutableArray *)numbers and:(NSMutableArray *)operators
{
	int WithinBrackOrParenth=0;
	NSString *numberString=@"";
	for (int x = 0; x < [subEquation length]; x++){
		if ([subEquation characterAtIndex:x]=='(' || [subEquation characterAtIndex:x]=='[') {
			WithinBrackOrParenth++;
		}
		if ([subEquation characterAtIndex:x]==')' || [subEquation characterAtIndex:x]==']') {
			WithinBrackOrParenth--;
		}
		if (WithinBrackOrParenth==0 && [subEquation characterAtIndex:x]=='*' ||
			WithinBrackOrParenth==0 && [subEquation characterAtIndex:x]=='/' ||
			WithinBrackOrParenth==0 && [subEquation characterAtIndex:x]=='+' ||
			WithinBrackOrParenth==0 && [subEquation characterAtIndex:x]=='-' ||
			WithinBrackOrParenth==0 && [subEquation characterAtIndex:x]=='^' ||
			WithinBrackOrParenth==0 && [subEquation characterAtIndex:x]=='=') {
			[operators addObject:[NSString stringWithFormat:@"%c",[subEquation characterAtIndex:x]]];
			if ([numberString length]!=0) {
				[numbers addObject:numberString];
				numberString=@"";
			}
		}
		else {
			numberString=[numberString stringByAppendingFormat:@"%c",[subEquation characterAtIndex:x]];
		}
	}
}

#pragma mark TYPE_CHECKING
-(BOOL)isFunction:(NSString *)number
{
	if ([number characterAtIndex:0]>=65 &&
		[number characterAtIndex:0]<=90)
		//Check if first character is a cap letter
		//Cap letters are functions
		return YES;
	return NO;
}
-(BOOL)isParameterized:(NSString *)number
{
	if ([number characterAtIndex:0]=='(')
		return YES;
	return NO;
}
-(BOOL)isPlainNumber:(NSString *)number
{
	if ([number characterAtIndex:0]>=48 && 
		[number characterAtIndex:0]<=57 ||
		[number characterAtIndex:0]==POSNEG ||
		[number characterAtIndex:0]=='.') 
		return YES;
	return NO;
}

-(NSString *)ifNegConvertToNeg:(NSString *)number
{
	return [number stringByReplacingOccurrencesOfString:@"c" withString:@"-"];
}

-(void)dealloc
{
	[numberArray release];
	[operatorArray release];
	[super dealloc];
}

@end
