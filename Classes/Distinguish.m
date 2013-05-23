//
//  Distinguish.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/11/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "Distinguish.h"


@implementation Distinguish

-(BOOL)isEquation:(NSString *)string
{
	if ([string rangeOfString:@"-"].location != NSNotFound ||
		[string rangeOfString:@"/"].location != NSNotFound ||
		[string rangeOfString:@"×"].location != NSNotFound ||
		[string rangeOfString:@"!"].location != NSNotFound ||
		[string rangeOfString:@"√"].location != NSNotFound ||
		[string rangeOfString:@"^"].location != NSNotFound ||
		[string rangeOfString:@"%"].location != NSNotFound ||
		[string rangeOfString:@"("].location != NSNotFound ||
		[string rangeOfString:@")"].location != NSNotFound ||
		[string rangeOfString:@"C"].location != NSNotFound ||
		[string rangeOfString:@"S"].location != NSNotFound ||
		[string rangeOfString:@"T"].location != NSNotFound ||
		[string rangeOfString:@"L"].location != NSNotFound) {
		return YES;
	}
	for (int i = 0; i < [string length]; i++) {	//Scientific notations
		if ([string characterAtIndex:i] == '+' &&
			[string characterAtIndex:i-1] != 'e') {
			return YES;
		}
		if (([string characterAtIndex:i] > '9' ||
			[string characterAtIndex:i] < '0') &&
			[string characterAtIndex:i] != '+' &&
			[string characterAtIndex:i] != '-' &&
			[string characterAtIndex:i] != '.') {
			return YES;
		}
	}
	return NO;
}

@end
