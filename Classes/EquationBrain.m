//
//  EquationBrain.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "EquationBrain.h"


@implementation EquationBrain

-(id)init
{
	[super init];
	//@"!"
	function_names = [[NSMutableArray alloc] initWithObjects:@"!",@"LOGTWO",@"%",@"LOGTEN",@"SQRT",@"Sin",@"Cos",@"Tan",@"Sinh",@"Cosh",@"Tanh",@"CUBERT",@"SININV",@"COSINV",@"TANINV",nil];
	res = 0;
	function_calc = [[FunctionBrain alloc]init];
	return self;
}
	
-(BOOL)errors:(NSString *)equation
{	
	if ([equation rangeOfString:@"()"].location != NSNotFound) {
		if (TEST)
			NSLog(@"Error:empty brackets");
		return NO;
	}
	
	equation = [equation stringByReplacingOccurrencesOfString:@")(" withString:@")*("];
	NSMutableArray *componentsArray;
	componentsArray = [self splitEquationByString:@"+/-*^$" andEquation:equation];
	if (componentsArray == nil) {
		if (TEST)
			NSLog(@"Error");
		return NO;		//There was an error
	}
	NSMutableArray *operatorsArray;
	operatorsArray = [self getOperators:@"+/-*^$" andEquation:equation];
	
	[self cleanup:operatorsArray];
	[self cleanup:componentsArray];
	
	if (![self validify:componentsArray and:operatorsArray]) {
		if (TEST)
			NSLog(@"Error: validify");
		return NO;
	}
	
	return YES;
}

-(NSMutableArray *)splitEquationByString:(NSString *)separators andEquation:(NSString *)equation
{
	//Splits a string by its separators -- will not separate within exception area dividers
	//Usually the exceptions are paranthases
	NSMutableArray *result = [[NSMutableArray alloc]init];
	
	int level_of_exception = 0;
	NSString *storage = @"";
	for (int i = 0; i < [equation length]; i++) {
		//Check for parenthases
		if ([equation characterAtIndex:i] == '(')
			level_of_exception++;
		else if ([equation characterAtIndex:i] == ')')
			level_of_exception--;
		if ([self isCharacterOfSeparators:separators andChar:[equation characterAtIndex:i]] 
			&& level_of_exception == 0) {
			//Retain and push storage into the array
			[result addObject:storage];
			//[storage retain];
			storage = @"";
		}
		else {
			storage = [storage stringByAppendingFormat:@"%c",[equation characterAtIndex:i]];
		}
	}
	
	if (level_of_exception != 0)
		return nil;		//Balancing problem
	
	//Add last object
	[result addObject:storage];
	
	//Check array
	if (TEST)
		for (NSString *string in result) {
			NSLog(@"%@",string);
		}	
	
	return result;
}

-(NSMutableArray *)getOperators:(NSString *)Operators andEquation:(NSString *)equation
{
	//returns mutable array with operators
	NSMutableArray *array = [[NSMutableArray alloc]init];
	
	int level_of_exception = 0;
	for (int i = 0; i < [equation length]; i++) {
		if ([equation characterAtIndex:i] == '(') 
			level_of_exception++;
		else if ([equation characterAtIndex:i] == ')')
			level_of_exception--;
		if ([self isCharacterOfSeparators:Operators andChar:[equation characterAtIndex:i]] &&
			level_of_exception == 0) {
			[array addObject:[NSString stringWithFormat:@"%c",[equation characterAtIndex:i]]];
		}
	}
	if (TEST) 
		for (NSString *string in array) {
			NSLog(@"%@",string);
		}
	return array;
}

-(BOOL)isCharacterOfSeparators:(NSString *)separators andChar:(unichar)character
{
	BOOL yesOrNo = NO;
	for (int i = 0; i < [separators length]; i++) {
		if ([[NSString stringWithFormat:@"%c",character] isEqualToString:
			 [NSString stringWithFormat:@"%c",[separators characterAtIndex:i]]]) {
			yesOrNo = YES;
		}
	}
	return yesOrNo;
}	

-(BOOL)validify:(NSMutableArray *)digits and: (NSMutableArray *)operators
{
	//Check the count first
	if ([digits count] <= [operators count])
		return NO;
	
	for (int i = 0; i < [digits count]; i++) {
		//Is each component fully condensed?
		if ([self isSetOfStringFoundInString:[NSArray arrayWithObjects:@"+",@"-",@"*",@"/",@"^",@"$",nil] andString:[digits objectAtIndex:i]] == YES) {
			NSString *stringToCheck = [self getInBetweenBraces:[digits objectAtIndex:i]];
			//NO
			if (![self errors:stringToCheck])
				return NO;
		}
		else if ([self isSetOfStringFoundInString:(NSArray *)function_names andString:[digits objectAtIndex:i]]) {
			NSString *stringToCheck = [digits objectAtIndex:i];
			if ([stringToCheck characterAtIndex:0] == '(' &&
				[stringToCheck characterAtIndex:[stringToCheck length]-1] == ')')
				stringToCheck = [self getInBetweenBraces:stringToCheck];
			
			if ([self spliceTheFunction:stringToCheck] == nil) {
				if (TEST)
					NSLog(@"Error splice the function");
				return NO;
			}
		}
		
	}
	return YES;
}

-(void)cleanup:(NSMutableArray *)array
{
	//Remove objects that are empty
	for (int i = 0; i < [array count]; i++) {
		if ([[array objectAtIndex:i] isEqualToString:@""])
			[array removeObjectAtIndex:i];
	}
}

-(BOOL)isSetOfStringFoundInString:(NSArray *)strings andString:(NSString *)haystack
{
	for (int i = 0; i < [strings count]; i++) {
		if ([haystack rangeOfString:[strings objectAtIndex:i]].location != NSNotFound) {
			return YES;
		}
	}
	return NO;
}
					  
-(NSString *)getInBetweenBraces:(NSString *)string {
	//Returns teh stuff in between braces
	int start_index = 0;
	int end_index = [string length]-1;
	
	for (start_index; start_index < end_index; start_index++) {
		//Found start index;
		if ([string characterAtIndex:start_index] == '(')
			break;
	}
	for (end_index; end_index > start_index; end_index--) {
		//Found end index;
		if ([string characterAtIndex:end_index] == ')')
			break;
	}
	
	return [string substringWithRange:NSMakeRange(start_index+1, end_index-start_index-1)];
}
	
-(int)occurencesOfString:(NSString *)string inEquation:(NSString *)equation
{
	int count = 0;
	
	for (int i = 0; i < [equation length]; i++) {
		//string should be 1 char long
		if ([string isEqualToString:[NSString stringWithFormat:@"%c",[equation characterAtIndex:i]]]) {
			count++;
		}
	}
	return count;
}

-(double)compute:(NSString *)equation andSum:(double)sum;
{
	equation = [equation stringByReplacingOccurrencesOfString:@")(" withString:@")*("];
	NSMutableArray *componentsArray;
	componentsArray = [self splitEquationByString:@"+/-*^$" andEquation:equation];
	
	NSMutableArray *operatorsArray;
	operatorsArray = [self getOperators:@"+/-*^$" andEquation:equation];
	
	[self cleanup:operatorsArray];
	[self cleanup:componentsArray];
		
	sum += [self addUp:componentsArray and:operatorsArray];
	if (TEST)
		NSLog(@"Result:%lf",sum);
	return sum;
}

-(double)addUp:(NSMutableArray *)digits and: (NSMutableArray *)operators
{
	for (int i = 0; i < [digits count]; i++) {
		//Is each component fully condensed?
		if ([self isSetOfStringFoundInString:[NSArray arrayWithObjects:@"+",@"-",@"*",@"/",@"^",@"$",nil] andString:[digits objectAtIndex:i]] &&
			![self isSetOfStringFoundInString:(NSArray *)function_names andString:[digits objectAtIndex:i]]) {
			NSString *stringToCheck = [self getInBetweenBraces:[digits objectAtIndex:i]];
			double portion = [self compute:stringToCheck andSum:0];
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",portion] atIndex:i];
		}
		if ([self isSetOfStringFoundInString:[NSArray arrayWithObjects:@"(",@")",nil] andString:[digits objectAtIndex:i]] &&
				 ![self isSetOfStringFoundInString:(NSArray *)function_names andString:[digits objectAtIndex:i]]) {
			NSString *string = [digits objectAtIndex:i];
			string = [string substringWithRange:NSMakeRange(1, [string length]-1)];
			[digits removeObjectAtIndex:i];
			[digits insertObject:string atIndex:i];
		}
		if ([self isSetOfStringFoundInString:(NSArray *)function_names andString:[digits objectAtIndex:i]] &&
				 [self isSetOfStringFoundInString:[NSArray arrayWithObjects:@"+",@"-",@"*",@"/",@"^",@"$",nil] andString:[digits objectAtIndex:i]]) {
			NSString *condensed_equation = [digits objectAtIndex:i];
			if ([condensed_equation characterAtIndex:0] == '(' &&
				[condensed_equation characterAtIndex:[condensed_equation length]-1] == ')') {
				condensed_equation = [self getInBetweenBraces:condensed_equation];
				double result = [self compute:condensed_equation andSum:0];
				[digits removeObjectAtIndex:i];
				[digits insertObject:[NSString stringWithFormat:@"%lf",result] atIndex:i];
			}
		}
		if ([self isSetOfStringFoundInString:(NSArray *)function_names andString:[digits objectAtIndex:i]]) {
			NSString *input_seq = [digits objectAtIndex:i];;
			if ([[digits objectAtIndex:i] characterAtIndex:0] == '(' &&
				[[digits objectAtIndex:i]characterAtIndex:[[digits objectAtIndex:i] length]-1] == ')') 
				input_seq = [self getInBetweenBraces:input_seq];
			
			//Function calculation
			double partial = [self compute:[self getInBetweenBraces:input_seq] andSum:0];
			double result = [function_calc functionWithFunction:[self spliceTheFunction:input_seq] andNumber:partial];
			if (isnan(result) || isinf(result)) {
				return NAN;
			}
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",result] atIndex:i];
		}
	}
	
	//Negatives
	for (int i = 0; i < [digits count]; i++) {
		NSString *string = [digits objectAtIndex:i];
		string = [string stringByReplacingOccurrencesOfString:@"c" withString:@"-"];
		[digits removeObjectAtIndex:i];
		[digits insertObject:string atIndex:i];
	}
	
	//Check for exponent and Rts first
	for (int i = 0; i < [operators count]; i++) {
		if ([[operators objectAtIndex:i] isEqualToString: @"^"]) {
			double num = pow([[digits objectAtIndex:i] doubleValue], [[digits objectAtIndex:i+1] doubleValue]);
			[digits removeObjectAtIndex:i];
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",num] atIndex:i];
			[operators removeObjectAtIndex:i];
			i--;
		}
		else if ([[operators objectAtIndex:i] isEqualToString: @"$"]) {
			double num = pow([[digits objectAtIndex:i+1] doubleValue], 1/[[digits objectAtIndex:i] doubleValue]);
			[digits removeObjectAtIndex:i];
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",num] atIndex:i];
			[operators removeObjectAtIndex:i];
			i--;
		}
	}
	
	//Then check for divide and multiple first
	for (int i = 0; i < [operators count]; i++) {
		if ([[operators objectAtIndex:i] isEqualToString: @"*"]) {
			double num = [[digits objectAtIndex:i] doubleValue] * [[digits objectAtIndex:i+1] doubleValue];
			[digits removeObjectAtIndex:i];
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",num] atIndex:i];
			[operators removeObjectAtIndex:i];
			i--;
		}
		else if ([[operators objectAtIndex:i] isEqualToString: @"/"]) {
			double num = [[digits objectAtIndex:i] doubleValue] / [[digits objectAtIndex:i+1] doubleValue];
			[digits removeObjectAtIndex:i];
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",num] atIndex:i];
			[operators removeObjectAtIndex:i];
			i--;
		}
	}
	
	//Add and sub
	for (int i = 0; i < [operators count]; i++) {
		if ([[operators objectAtIndex:i] isEqualToString: @"+"]) {
			double num = [[digits objectAtIndex:i] doubleValue] + [[digits objectAtIndex:i+1] doubleValue];
			[digits removeObjectAtIndex:i];
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",num] atIndex:i];
			[operators removeObjectAtIndex:i];
			i--;
		}
		else if ([[operators objectAtIndex:i] isEqualToString: @"-"]) {
			double num = [[digits objectAtIndex:i] doubleValue] - [[digits objectAtIndex:i+1] doubleValue];
			[digits removeObjectAtIndex:i];
			[digits removeObjectAtIndex:i];
			[digits insertObject:[NSString stringWithFormat:@"%lf",num] atIndex:i];
			[operators removeObjectAtIndex:i];
			i--;
		}
	}
	return [[digits objectAtIndex:0] doubleValue];
}

-(NSString *)replaceMultiplyWithStar:(NSString *)equation
{
	//Replace with these strings with understandable text
	
	NSString *result = [equation stringByReplacingOccurrencesOfString:@"×" withString:@"*"];
//	result = [result stringByReplacingOccurrencesOfString:@"√" withString:@"SQRT"];
	result = [result stringByReplacingOccurrencesOfString:@"Log₁₀" withString:@"LOGTEN"];
	result = [result stringByReplacingOccurrencesOfString:@"Log₂" withString:@"LOGTWO"];
	result = [result stringByReplacingOccurrencesOfString:@"∛" withString:@"CUBERT"];
	result = [result stringByReplacingOccurrencesOfString:@"Sin⁻¹" withString:@"SININV"];
	result = [result stringByReplacingOccurrencesOfString:@"Cos⁻¹" withString:@"COSINV"];
	result = [result stringByReplacingOccurrencesOfString:@"Tan⁻¹" withString:@"TANINV"];
	result = [result stringByReplacingOccurrencesOfString:@"√" withString:@"$"];	//Rts 
	result = [result stringByReplacingOccurrencesOfString:@"e+" withString:@"e"];
	
	result = [self getNumAfterNeg:result];
	result = [result stringByReplacingOccurrencesOfString:@"﹣" withString:@"((1-2)*"];
	return result;
}

-(NSString *)getNumAfterNeg:(NSString *)equation
{
	//Get after ﹣
	BOOL foundNeg = NO;
	unichar lastChar = ' ';
	int i;
	for (i = 0; i < [equation length]; i++) {
		if (foundNeg) {
			if (lastChar >= '0' &&
				lastChar <= '9' ||
				lastChar == 'e' ||
				lastChar == '.') {

				if (([equation characterAtIndex:i] < '0' ||
					[equation characterAtIndex:i] > '9') &&
					[equation characterAtIndex:i] != 'e' &&
					[equation characterAtIndex:i] != '.') {
					//Insert a ')';
					equation = [equation stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@")%c",[equation characterAtIndex:i]]];
					foundNeg = NO;
				}
			}
		}	
		if ([[equation substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"﹣"])
			foundNeg = YES;
		lastChar = [equation characterAtIndex:i];
	}
	i--;
	if (foundNeg) {
		if (lastChar >= '0' &&
			lastChar <= '9') {

			//Insert a ')';
			equation = [equation stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c)",[equation characterAtIndex:i]]];
			foundNeg = NO;
		}
	}
	return equation;
}

-(NSString *)spliceTheFunction:(NSString *)equation
{
	//Returns string of the function name
	//Nil if there is an error

	NSRange range;
	
	BOOL found = NO;
		
	//Avoid the innver level braces
	NSString *searchString = [self getWithoutBraces:equation];
	
	//Get range of the string first
	for (NSString *function in function_names) {
		if ((range = [searchString rangeOfString:function]).location != NSNotFound) {
			found = YES;
			break;
		}	
	}
	
	if (!found) {
		return nil;
	}
	
	if (range.location != 0) {
		if (TEST)	
			NSLog(@"location");
		return nil;
	}
	
	if ([equation length] <= range.location + range.length) {
		if (TEST)		
			NSLog(@"length");
		return nil;
	}
	
	if ([equation characterAtIndex:range.location+range.length]!='(') {
		if (TEST)	
			NSLog(@"(");
		return nil;
	}
			
	return [equation substringWithRange:range];
}

-(NSString *)getWithoutBraces:(NSString *)str
{
	NSString *string = @"";
	int level_of_braces = 0;
	
	for (int i = 0; i < [str length]; i++) {
		if ([str characterAtIndex:i] == '(')
			level_of_braces++;
		else if ([str characterAtIndex:i] == ')')
			level_of_braces--;
		
		if (level_of_braces == 0) {
			string = [string stringByAppendingFormat:@"%c",[str characterAtIndex:i]];
		}
	}
	return string;
}

-(void)dealloc
{
	[function_names release];
	[function_calc release];
	[super dealloc];
}

@synthesize res;

@end
