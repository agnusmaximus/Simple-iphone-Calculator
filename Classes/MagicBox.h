//
//  MagicBox.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/1/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	What this is suppose to do is supply an extra view; a storage
//	where the user can drag and drop various stored integers.
//	More functionality would include operations that act upon the
//	integers in the box -- for example, an average function that takes
//	the average of all the numbers in the box.
//	Even more functionality would be that user's would be able more of these
//	boxes and then name them -- for example: constants storage, etc

#import <UIKit/UIKit.h>
#import "MyLabel.h"
#import "MyButton.h"
#import "CalcState.h"
#import "Sound.h"
//#import "CalculatorConnect.h"
#import "Macros.h"
#import "SearchPrints.h"
#import "LEDScreen.h"
#import "Distinguish.h"
#import "EditableStorageButton.h"
@class CalculatorConnect;

#define EXPAND_RATE .025
#define UPDATE_SPEED 1/300.0f

#define BUTTON_HEIGHT 50
#define BUTTON_WIDTH 60
#define ELBOW_SPACE 0

#define DIGITS_VAR 1

@interface MagicBox : NSObject {
	UIImageView *view;
	UIScrollView *superView;
	BOOL hidden;
	
	NSTimer *actionTimer;
	
	//ScrollView
	UIScrollView *scrollView;
	
	//The queue
	NSMutableArray *queue;
	//Delete button queue
	NSMutableArray *deleteButtonQueue;
	
	//UILabel user is draggin from the box
	UILabel *uLabel;
	
	UITextField *inputBox;
	
	//Delegate -- should point to Calculator Connect
	id delegate;
	
	//Sounds
	Sound *mySounds;
	
	//Search field
	SearchPrints *searchfield;
	
	//Led Screen
	LEDScreen *screen;
	
	//Distinguishin between variables and equations
	Distinguish *check;
}

-(id)initWithView:(UIScrollView *)sView;
-(void)toggleOnOff;

-(void)unscroll;
-(void)scroll;

//Queue operations
-(void)addToQueue:(id)obj;
-(void)deleteFromQueue:(id)sender;
-(void)moveUp:(int)index;

//Delete button queue
-(void)subtract1fromTag:(int)index;

-(void)numberToDelegate:(NSString *)number;

-(int)characterToNumber:(unichar)charac;

//Data
-(void)saveData;
-(void)loadData;

@property (nonatomic, retain) UIImageView *view;
@property (readonly) BOOL hidden;
@property (nonatomic, retain) UITextField * inputBox;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) SearchPrints *searchfield;
@property (nonatomic, retain) LEDScreen *screen;

@end
