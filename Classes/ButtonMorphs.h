//
//  ButtomMorphs.h
//  SimpleCalculator
//
//  Created by Max Lam on 5/20/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	Handles the buttons that will morph into another button

#import <UIKit/UIKit.h>
#import "Macros.h"

@interface ButtonMorphs : NSObject {
	//Scientific Buttons that will metamorphasize
	IBOutlet UIButton *cubeAndrt;
	IBOutlet UIButton *log2And2exp;
	IBOutlet UIButton *sinAndInv;
	IBOutlet UIButton *cosAndInv;
	IBOutlet UIButton *tanAndInv;
	
	IBOutlet UIButton *eAndScieE;
	
	IBOutlet UIButton *morphButton;
	
	IBOutlet UIButton *percAndRadDeg;
	
	IBOutlet UIButton *sqrandrt;
	
	IBOutlet UIButton *inverseAndSum;
}

-(void)morphAll:(BOOL)state;

@end
