//
//  FunctionView.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	Provides an extra input view for various functions like sum(), avg(), etc.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyScrollView.h"
#import "MyButton.h"
#import "CalcState.h"

@interface FunctionView : NSObject {

	IBOutlet MyScrollView *delegate; //Should be set to View Controller
	
	NSMutableArray *arrayOfBars;
}

-(void)shrinkScrollView;
-(void)addFunctionBar:(UIView *)superV;
-(void)translateLastBarObj;

@end
