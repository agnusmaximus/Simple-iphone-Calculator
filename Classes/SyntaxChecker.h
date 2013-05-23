//
//  SyntaxChecker.h
//  Equations Calculator
//
//  Created by Max Lam on 11/27/10.
//  Copyright 2010 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ValidFunctions;

@interface SyntaxChecker : NSObject {
	NSMutableArray *errorMessages;
	NSString *equation;
	NSMutableArray *numberArray, *operatorArray;
	ValidFunctions *validate;
	BOOL userFunction; //YES for function, NO for equation
}

#pragma mark TRANSITIONS
-(BOOL)checkEquation:(NSString *)passedEquation;
-(void)ridSpaces;
-(void)addMultSymbolBeforeParenthesesIfNeeded;
-(NSString *)appendEqualsIfInexistant:(NSString *)passedEquation;
-(void)setUserFunction:(BOOL)yesOrNo;

#pragma mark SPLITTING_EQUATION
-(void)splitEquation:(NSString *)subEquation into:(NSMutableArray *)numbers and:(NSMutableArray *)operators;

#pragma mark SYNTAX_CHECKING
-(void)syntaxCheck:(NSMutableArray *)numbers and:(NSMutableArray *)operators;
-(BOOL)isFunction:(NSString *)number;
-(BOOL)isParameterized:(NSString *)number;
-(BOOL)isPlainNumber:(NSString *)number;
-(void)checkFunction:(NSString *)number;
-(void)checkParameterized:(NSString *)number;
-(void)checkPlainNumber:(NSString *)number;
-(void)checkPlainVariable:(NSString *)number;

#pragma mark DISPLAYING_ERRORS
-(void)deleteAllErrorMessages;

#pragma mark DEBUG
-(void)printAllInArray:(NSMutableArray *)numbers and:(NSMutableArray *)operators;
@end
