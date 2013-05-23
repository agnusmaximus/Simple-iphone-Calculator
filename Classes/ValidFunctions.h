//
//  ValidFunctions.h
//  Equations Calculator
//
//  Created by Max Lam on 11/27/10.
//  Copyright 2010 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidFunctions : NSObject {
	NSMutableArray *validFunctions;
	NSMutableArray *functionParameters;
	NSMutableArray *mnemonic;
	NSAutoreleasePool *releasePool;
	NSString *userFunctionResult;
	BOOL goodToGo;
}

-(BOOL)findFunction:(NSString *)functionToFind;
-(int)numFunctionParameter:(NSString *)function;
-(int)lookupMnemonic:(NSString *)function;
-(NSNumber *)evaluateUnaryFunction:(NSString *)function numbers:(double)number;
-(NSNumber *)evaluatePolynaryFunction:(NSString *)function numbers:(double)number1 numbers:(double)number2;
-(NSMutableArray *)returnAllFunctionsInArray;
-(void)handleUserFunctionResult:(NSNotification *)note;
-(void)handleToggleChanges:(NSNotification *)note;

-(void)scanFunctionsList;

@end
