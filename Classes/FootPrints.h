//
//  FootPrints.h
//  SimpleCalculator
//
//  Created by Max Lam on 5/21/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	A class used to provide user with "footprints" or tape functions
//	Remember: Operators are always NSNumbers 
//			  Normal numbers are always strings

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CalculatorConnect.h"
#import "Macros.h"
#import "MyButton.h"
#import "MyLabel.h"
#import "CalcState.h"
#import "Sound.h"
#import "SearchPrints.h"
#import "MyPatternBrush.h"
#import "MyScrollView.h"
#import "MyEditableButton.h"
#import "LEDScreen.h"
#import "Distinguish.h"

#define BUTTON_HEIGHT 50
#define BUTTON_WIDTH 60
#define ELBOW_SPACE 0

#define NUMBER 0
#define OPERATOR 1
#define EQUATION 2

@interface FootPrints : NSObject {
	IBOutlet MyScrollView *vertScrollView;
	
	NSMutableArray *inputQueue;		//The User's input
	NSMutableArray *outputQueue;	//The Output queu
	NSMutableArray *userQueue;		//Queue to hold user's drag and drop
	NSMutableArray *effectsQueue;	//Queue to hold special effects
	
	IBOutlet id delegate;
	
	MyButton *deleteButton;
	
	IBOutlet UITextField *inputBox;
	
	int operatorSign;
	
	Sound *mySounds;
	
	SearchPrints *searchfield;
	
	//Brush
	UIButton *select;
	MyPatternBrush *brush;
	BOOL isSelectMode;
	
	CGPoint lastPt;
	
	IBOutlet LEDScreen *screen;
	
	//Check equations
	Distinguish *check;
}

//Input Queue functions
-(void)addToInput:(id)obj;
-(void)popFromInput;
-(void)clearInput;

//Output Queue Functions
-(void)addToOutput:(id)obj;
-(void)popFromOutput;
-(void)clearOutput;

//Digits mode inputs


//Clear effects queue
-(void)clearEffectsQueue;

-(void)deleteAll;

-(NSString *)returnStringForOperatorSign:(int)sign;

-(BOOL)isSignUnaryOperator:(id)sign;

-(void)touchAButton:(id)sender;

//Insert to delegate
-(void)numberToDelegate:(NSString *)number;
-(int)characterToNumber:(unichar)charac;

//Select mode
-(void)toggleSelectMode:(id)sender;

//Reddify edited button
-(void)reddifyEditedButton:(MyEditableButton *)button;

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) SearchPrints *searchfield;
@property (nonatomic, retain) UIScrollView * vertScrollView;
@property (nonatomic, retain) NSMutableArray * inputQueue;

@end
