//
//  Computations.h
//  EquationsCalculator
//
//  Created by Max Lam on 11/28/10.
//  Copyright 2010 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ValidFunctions;

@interface Computations : NSObject {
	NSString *equation;
	NSNumber *answer;
	NSMutableArray *numberArray, *operatorArray;
	ValidFunctions *validate;
	BOOL notANumber;
}

#pragma mark TRANSITIONS
-(NSString *)passEquationToComputer:(NSString *)passedEquation;

#pragma mark COMPUTATIONS
-(NSString *)compute:(NSMutableArray *)numbers and:(NSMutableArray *)operators;
-(NSString *)condense:(NSString *)expression;

#pragma mark MODIFYING_EQUATION
-(void)ridSpaces;
-(void)addMultSymbolBeforeParenthesesIfNeeded;
-(NSString *)appendEqualsIfInexistant:(NSString *)passedEquation;

#pragma mark SPLITTING_EQUATION
-(void)splitEquation:(NSString *)subEquation into:(NSMutableArray *)numbers and:(NSMutableArray *)operators;

#pragma mark TYPE_CHECKING
-(BOOL)isFunction:(NSString *)number;
-(BOOL)isParameterized:(NSString *)number;
-(BOOL)isPlainNumber:(NSString *)number;
-(NSString *)ifNegConvertToNeg:(NSString *)number;

@end
