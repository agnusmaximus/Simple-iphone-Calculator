//
//  SimpleCalculatorViewController.h
//  SimpleCalculator
//
//  Created by Max Lam on 5/19/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This class will handle the user interface

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MagicBox.h"
#import "LEDScreen.h"
#import "FootPrints.h"
#import "MyScrollView.h"
#import "MyButton.h"
#import "CalcState.h"
#import "Macros.h"
#import "ButtonMorphs.h"
#import "FunctionView.h"

@class EquationConnect;
@class SimpleCalculatorAppDelegate;

@interface SimpleCalculatorViewController : UIViewController {
	//Delegate attached in xib file to Calculator connect -- 
	//used primarily to transfer button pressed to model
	id delegate;	
	
	//ScrollView
	IBOutlet MyScrollView *scrollView;
	
	//Landscape mode
	SimpleCalculatorViewController *landscape;

	IBOutlet MyButton *magicEntry;
	
	//Magic
	MagicBox *magicBox;
	
	//The screen
	IBOutlet LEDScreen *screen;
	
	//The label being carried right now
	MyLabel *uLabel;
	
	//The connective tissue
	IBOutlet id connect;
	IBOutlet id footprints;
	
	EquationConnect *equationCalc;
	
	IBOutlet ButtonMorphs *morphs;
	
	IBOutlet MyButton *RightPar;
	IBOutlet MyButton *LeftPar;
	
	IBOutlet FunctionView *functionBar;
}

-(IBAction)buttonPressed:(id)sender;
-(IBAction)MagickBox:(id)sender;

-(void)saveData;
-(void)loadData;

@property (nonatomic, retain) id delegate;

@end

