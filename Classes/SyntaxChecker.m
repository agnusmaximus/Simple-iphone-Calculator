//
//  SyntaxChecker.m
//  equas Calculator
//
//  Created by Max Lam on 11/27/10.
//  Copyright 2010 Max Lam. All rights reserved.
//

#import "SyntaxChecker.h"
#import "ValidFunctions.h"
#import "Macros.h"

@implementation SyntaxChecker

-(id)init
{
	[super init];
	errorMessages=[[NSMutableArray alloc]init];
	equation=nil;
	validate=[[ValidFunctions alloc]init];
	numberArray=[[NSMutableArray alloc]init];
	operatorArray=[[NSMutableArray alloc]init];
	userFunction=NO;
	return self;
}

#pragma mark TRANSITIONS
-(BOOL)checkEquation:(NSString *)passedequation
{
	equation=passedequation;
	[self ridSpaces];
	[self addMultSymbolBeforeParenthesesIfNeeded];
	equation=[self appendEqualsIfInexistant:equation];
	
	//Checking syntax errors 
	[numberArray removeAllObjects];
	[operatorArray removeAllObjects];
	[self splitEquation:equation into:numberArray and:operatorArray];
	[self syntaxCheck:numberArray and:operatorArray];

	//Yes if equa is correct, No if there are errors
	if ([errorMessages count]==0)
		//No errors
		return YES;
	else 
		//There are errors
		return NO;
}

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

-(void)setUserFunction:(BOOL)yesOrNO;
{
	userFunction=yesOrNO;
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
	[self printAllInArray:numbers and:operators];
}


#pragma mark SYNTAX_CHECKING
-(void)syntaxCheck:(NSMutableArray *)numbers and:(NSMutableArray *)operators
{
	if ([numbers count]<[operators count]) {
		//For each operator there must be an operand
		[errorMessages addObject:@"Missing operand for operator"];
	}
	if ([operators count]!=0) {
		//Check if anything went wrong in the equation; cause is unknown
		if (![[operators objectAtIndex:[operators count]-1]isEqualToString:@"="]) {
			[errorMessages addObject:@"Syntax error"];
			return;
		}
	}
	else if([operators count]==0 && [numbers count]==0) {
		//If there is nothing in the equation
		[errorMessages addObject:@"Syntax error"];
		return;
	}
	for (int x = 0; x < [numbers count]; x++) {
		//Check the number values first
		if([self isFunction:[numbers objectAtIndex:x]]){
			[self checkFunction:[numbers objectAtIndex:x]];
		}
		else if([self isParameterized:[numbers objectAtIndex:x]]){
			[self checkParameterized:[numbers objectAtIndex:x]];
		}
		else if([self isPlainNumber:[numbers objectAtIndex:x]]){
			if (!userFunction)
				[self checkPlainNumber:[numbers objectAtIndex:x]];
			if (userFunction)
				[self checkPlainVariable:[numbers objectAtIndex:x]];
		}
		else {
			[errorMessages addObject:@"Syntax error"];
			return;
		}
	}
}

-(BOOL)isFunction:(NSString *)number
{
	if ([number characterAtIndex:0]>=65 &&
		[number characterAtIndex:0]<=90 &&
		[number rangeOfString:@"]"].location != NSNotFound)
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
	if ([number characterAtIndex:0]==120||
		[number characterAtIndex:0]>=48 && 
		[number characterAtIndex:0]<=57 ||
		[number characterAtIndex:0]==POSNEG ||
		[number characterAtIndex:0]=='.') 
		return YES;
	return NO;
}
-(void)checkFunction:(NSString *)number
{
	int x;
	NSString *functionName=@"";
	for (x = 0;[number characterAtIndex:x]>=65 && [number characterAtIndex:x]<=90 ; x++){
		functionName=[functionName stringByAppendingFormat:@"%c",[number characterAtIndex:x]];
	}
	if(![validate findFunction:functionName]){
		//Does this function even exist?
		[errorMessages addObject:[NSString stringWithFormat:@"Unknown function %@",functionName]];
		return;
	}
	//Check if brackets exist
	if ([number characterAtIndex:x++]!='[') {
		[errorMessages addObject:[NSString stringWithFormat:@"Missing opening bracket for function %@",functionName]];
	}
	if ([number characterAtIndex:[number length]-1]!=']') {
		[errorMessages addObject:[NSString stringWithFormat:@"Missing closing bracket for function %@",functionName]];
		return;
	}
	int numCommaSeparator=0;
	int inAnotherFunction=-1; //-1 to make up for current function bracket occurance
	//Check for separator commas
	for (int y = 0; y < [number length]; y++) {
		if ([number characterAtIndex:y]=='[') {
			inAnotherFunction++;
		}
		else if([number characterAtIndex:y]==']') {
			inAnotherFunction--;
		}
		//Not in another function and found a comma
		if (inAnotherFunction==0 && [number characterAtIndex:y]==',') {
			numCommaSeparator++;
		}
	}
	if (inAnotherFunction < -1) {
		//Unknown error
		[errorMessages addObject:@"Syntax error"];
		return;
	}
	if ([validate numFunctionParameter:functionName] != numCommaSeparator+1) {
		[errorMessages addObject:[NSString stringWithFormat:@"There are too many/too little comma separators for function %@",functionName]];
		return;
	}
	//Check empty parameters
	inAnotherFunction=-1;
	char cur=0, prev=0;
	//For function with 2 parameters
	if ([validate numFunctionParameter:functionName]==2){
		//x is at the point after the function opening bracket
		for (int y = x-1; y < [number length]; y++) {
			//Ignore embedded functions
			if ([number characterAtIndex:y]=='[') {
				inAnotherFunction++;
			}
			else if([number characterAtIndex:y]==']' && y != [number length]-1) {
				inAnotherFunction--;
			}
			if (inAnotherFunction==0) {
				//If not in an embeded function
				cur=[number characterAtIndex:y];
			}
			if (cur==',' && prev=='[') {
				//empty parameter
				[errorMessages addObject:[NSString stringWithFormat:@"You are missing the first parameter for function %@",functionName]];
			}
			else if (cur==']' && prev==',') {
				//empty second parameter
				[errorMessages addObject:[NSString stringWithFormat:@"You are missing the second parameter for function %@",functionName]];
			}
			prev=cur;
		}
		//Still in function with 2 param
		inAnotherFunction=0;
		BOOL foundComma=NO;
		//Recursively check within function parameters 
		NSString *subEquation1=@"", *subEquation2=@"";
		//First get the two parameters
		for (x; x < [number length]-1; x++) {
			if ([number characterAtIndex:x]=='[') {
				inAnotherFunction++;
			}
			else if([number characterAtIndex:x]==']' && x != [number length]-1) {
				inAnotherFunction--;
			}
			
			if (!foundComma)
				subEquation1=[subEquation1 stringByAppendingFormat:@"%c",[number characterAtIndex:x]];
			else if(foundComma)
				subEquation2=[subEquation2 stringByAppendingFormat:@"%c",[number characterAtIndex:x]];
			
			if(inAnotherFunction==0 && [number characterAtIndex:x]==',')
				foundComma=YES;
		}
		//A comma is stuck on subequation1; get rid of it
		subEquation1=[subEquation1 substringToIndex:[subEquation1 length]-1];
		//Check these equations as well
		subEquation1=[self appendEqualsIfInexistant:subEquation1];
		subEquation2=[self appendEqualsIfInexistant:subEquation2];
		NSMutableArray *numbers1, *operators1;
		NSMutableArray *numbers2, *operators2;
		numbers1=[[NSMutableArray alloc]init];
		numbers2=[[NSMutableArray alloc]init];
		operators1=[[NSMutableArray alloc]init];
		operators2=[[NSMutableArray alloc]init];
		[self splitEquation:subEquation1 into:numbers1 and:operators1];
		[self splitEquation:subEquation2 into:numbers2 and:operators2];
		[self syntaxCheck:numbers1 and:operators1];
		[self syntaxCheck:numbers2 and:operators2];
		[numbers1 release];
		[operators1 release];
		[numbers2 release];
		[operators2 release];
	}
	//For function with 1 parameter
	else if([validate numFunctionParameter:functionName]==1) {
		for (int y = x-1; y < [number length]; y++) {
			//Ignore embedded functions
			if ([number characterAtIndex:y]=='[') {
				inAnotherFunction++;
			}
			else if([number characterAtIndex:y]==']' && y != [number length]-1) {
				inAnotherFunction--;
			}
			if (inAnotherFunction==0) {
				//If not in an embeded function
				cur=[number characterAtIndex:y];
			}
			if (cur==']' && prev=='[') {
				[errorMessages addObject:[NSString stringWithFormat:@"Missing parameter for function %@",functionName]];
			}
			prev=cur;
		}
		inAnotherFunction=0;
		//Recursively check within function parameters 
		NSString *subEquation=@"";
		//First get the two parameters
		for (x; x < [number length]-1; x++) {
			if ([number characterAtIndex:x]=='[') {
				inAnotherFunction++;
			}
			else if([number characterAtIndex:x]==']' && x != [number length]-1) {
				inAnotherFunction--;
			}
			subEquation=[subEquation stringByAppendingFormat:@"%c",[number characterAtIndex:x]];
		}
		//Recursively check parameters as well
		NSMutableArray *numbers, *operators;
		subEquation=[self appendEqualsIfInexistant:subEquation];
		numbers=[[NSMutableArray alloc]init];
		operators=[[NSMutableArray alloc]init];
		[self splitEquation:subEquation into:numbers and:operators];
		[self syntaxCheck:numbers and:operators];
		[numbers release];
		[operators release];
	}
}
-(void)checkParameterized:(NSString *)number
{
	//Check for required opening parameter
	if ([number characterAtIndex:0] != '(') {
		[errorMessages addObject:@"Missing opening parameter"];
		return;
	}
	else if([number characterAtIndex:[number length]-1] != ')'){
		[errorMessages addObject:@"Missing closing parameter"];
		return;
	}
	
	//Check for redundant parameters
	if ([number characterAtIndex:1] == '(' &&
		[number characterAtIndex:[number length]-2] == ')'){
		[errorMessages addObject:@"Redundant parameters within parameter"];
		return;
	}
	NSString *subEquation=@"";
	//Get subequation within parameters
	for (int x = 1; x < [number length]-1; x++){
		subEquation=[subEquation stringByAppendingFormat:@"%c",[number characterAtIndex:x]];
	}
	//Recursively check this equation
	subEquation=[self appendEqualsIfInexistant:subEquation];
	NSMutableArray *numbers, *operators;
	numbers=[[NSMutableArray alloc]init];
	operators=[[NSMutableArray alloc]init];
	[self splitEquation:subEquation into:numbers and:operators];
	[self syntaxCheck:numbers and:operators];
	[numbers release];
	[operators release];
}
-(void)checkPlainNumber:(NSString *)number
{
	BOOL findDecimal=NO;
	BOOL findNeg=NO;
	int negPos=0, decPos=0;
	for (int x = 0; x < [number length]; x++){
		if ([number characterAtIndex:x] != '.' && [number characterAtIndex:x] != POSNEG) {
			if ([number characterAtIndex:x] < 48 ||
				[number characterAtIndex:x] > 57)
				[errorMessages addObject:[NSString stringWithFormat:@"Unknown character: %c",[number characterAtIndex:x]]];
		}
		if ([number	characterAtIndex:x] == '.') {
			if (findDecimal==NO) {
				findDecimal=YES;
				decPos=x;
			}
			else if(findDecimal==YES){
				//Found two decimals
				[errorMessages addObject:
				 [NSString stringWithFormat:@"Extra decimal in number: %@",number]];
			}
		}
		if ([number characterAtIndex:x]==POSNEG){
			if (findNeg==NO) {
				findNeg=YES;
				negPos=x;
			}
			else if(findNeg==YES)
				//Found two negative signs
				[errorMessages addObject:
				 [NSString stringWithFormat:@"Extra negative signs for number: %@",number]];
		}
	}
	//Check that negative sign comes before numbers
	if (findNeg==YES) {
		if (negPos!= 0)
			[errorMessages addObject:
			 [NSString stringWithFormat:@"Arbitrary negative sign found in number: %@",[number stringByReplacingOccurrencesOfString:@"c" withString:@""]]];
	}
	//Check that if there is decimal and negative, negative comes first
	if (findDecimal==YES && findNeg==YES) {
		if (decPos < negPos)
			[errorMessages addObject:
			 [NSString stringWithFormat:@"Negative sign before decimal point for number: %@",[number stringByReplacingOccurrencesOfString:@"c" withString:@""]]];
	}
}

-(void)checkPlainVariable:(NSString *)number
{
	BOOL findDecimal=NO;
	BOOL findNeg=NO;
	int negPos=0, decPos=0;
	for (int x = 0; x < [number length]; x++){
		if ([number characterAtIndex:x] != '.' && [number characterAtIndex:x] != POSNEG && [number characterAtIndex:x] != 120) {
			if ([number characterAtIndex:x] < 48 ||
				[number characterAtIndex:x] > 57)
				[errorMessages addObject:[NSString stringWithFormat:@"Unknown character: %c",[number characterAtIndex:x]]];
		}
		if ([number	characterAtIndex:x] == '.') {
			if (findDecimal==NO) {
				findDecimal=YES;
				decPos=x;
			}
			else if(findDecimal==YES){
				//Found two decimals
				[errorMessages addObject:
				 [NSString stringWithFormat:@"Extra decimal in number: %@",number]];
			}
		}
		if ([number characterAtIndex:x]==POSNEG){
			if (findNeg==NO) {
				findNeg=YES;
				negPos=x;
			}
			else if(findNeg==YES)
				//Found two negative signs
				[errorMessages addObject:
				 [NSString stringWithFormat:@"Extra negative signs for number: %@",number]];
		}
	}
	//Check that negative sign comes before numbers
	if (findNeg==YES) {
		if (negPos!= 0)
			[errorMessages addObject:
			 [NSString stringWithFormat:@"Arbitrary negative sign found in number: %@",[number stringByReplacingOccurrencesOfString:@"c" withString:@""]]];
	}
	//Check that if there is decimal and negative, negative comes first
	if (findDecimal==YES && findNeg==YES) {
		if (decPos < negPos)
			[errorMessages addObject:
			 [NSString stringWithFormat:@"Negative sign before decimal point for number: %@",[number stringByReplacingOccurrencesOfString:@"c" withString:@""]]];
	}
}


#pragma mark DISPLAYING_ERRORS

-(void)deleteAllErrorMessages
{
	[errorMessages removeAllObjects];
}

#pragma mark DEBUG
-(void)printAllInArray:(NSMutableArray *)numbers and:(NSMutableArray *)operators
{
	for (int x = 0; x < [numbers count]; x++){
		//NSLog(@"Numbers: %@",[numbers objectAtIndex:x]);
	}
	for (int x = 0; x < [operators count]; x++){
		//NSLog(@"Operators: %@",[operators objectAtIndex:x]);
	}	
}

-(void)dealloc
{
	[errorMessages release];
	[equation release];
	[validate release];
	[numberArray release];
	[operatorArray release];
	[super dealloc];
}

@end
