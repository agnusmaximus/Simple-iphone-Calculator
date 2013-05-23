//
//  CalculatorFrontObj.h
//  Calculator2
//
//  Created by Max Lam on 5/16/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This class represents the connective tissue for the calculator.
//	Button actions will be sent to this object and then to the 
//	objects that process thee actions. 

#import <UIKit/UIKit.h>
#import "LEDScreen.h"
#import "SimpleCalculatorViewController.h"
#import "Macros.h"
#import "Brain.h"
#import "SpinalCord.h"
#import "CalcState.h"
#import "Sound.h"
@class FootPrints;
#import "ButtonMorphs.h"

@interface CalculatorConnect : NSObject {
	IBOutlet LEDScreen *screenObj;
	Brain *brain;
	SpinalCord *spinalCord;
	IBOutlet FootPrints *footprints;	//History usage
	
	int lastOperator;	//Last operator user pressed, for order or ops
	int lastButton;		//Last button user pressed, for operator shifts
	
	//Sounds
	Sound *mysounds;
	
	//Delegate
	IBOutlet id delegate;
}

-(void)update:(id)sender;
-(BOOL)isLastButtonNormalPrecedence;
-(BOOL)isLastOperatorHigherPrecedence;
-(BOOL)isLastButtonHigherPrecedence;

-(void)morphButtons;

@property (nonatomic, retain) FootPrints *footprints;
@property (nonatomic, retain) id delegate;

@end
