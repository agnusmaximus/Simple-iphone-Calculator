//
//  EquationBrain.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionBrain.h"
#define TEST 0

@interface EquationBrain : NSObject {
	NSMutableArray *function_names;
	FunctionBrain *function_calc;
	double res;
}

-(BOOL)errors:(NSString *)equation;
-(NSMutableArray *)splitEquationByString:(NSString *)separators andEquation:(NSString *)equation;
-(BOOL)isCharacterOfSeparators:(NSString *)separators andChar:(unichar)character;

-(NSMutableArray *)getOperators:(NSString *)Operators andEquation:(NSString *)equation;

-(BOOL)validify:(NSMutableArray *)digits and: (NSMutableArray *)operators;

-(void)cleanup:(NSMutableArray *)array;

-(BOOL)isSetOfStringFoundInString:(NSArray *)strings andString:(NSString *)haystack;

-(NSString *)getInBetweenBraces:(NSString *)string;
-(NSString *)getWithoutBraces:(NSString *)string;

-(int)occurencesOfString:(NSString *)string inEquation:(NSString *)equation;

-(double)compute:(NSString *)equation andSum:(double)sum;
-(double)addUp:(NSMutableArray *)digits and: (NSMutableArray *)operators;

-(NSString *)replaceMultiplyWithStar:(NSString *)equation;

-(NSString *)spliceTheFunction:(NSString *)equation;

-(NSString *)getNumAfterNeg:(NSString *)equation;

@property (readwrite) double res;

@end
