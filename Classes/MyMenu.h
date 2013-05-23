//
//  MyMenu.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//  An interface to the state of the calculator

#import <UIKit/UIKit.h>
#import "CalcState.h"
#import "MyButton.h"

@interface MyMenu : UIView {
	NSTimer *timer;
	
	//State selection
	UISegmentedControl *stateSelect;
	
	MyButton *RightPar;
	MyButton *LeftPar;
}

-(void)appear:(id)sender;

-(void)Opaquify;
-(void)Translucify;

-(void)changeCalcState;

@property (nonatomic, retain) MyButton *RightPar;
@property (nonatomic, retain) MyButton *LeftPar;

@end
