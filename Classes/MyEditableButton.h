//
//  MyEditableButton.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/6/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MyTranslucentView.h"
#import "MyLabel.h"
#import "Distinguish.h"
@class FootPrints;

#define TIMEINTERVAL .4f
#define INPUT_W 150
#define INPUT_H 30

@interface MyEditableButton : MyButton {
	NSTimer *timer;
	MyTranslucentView *blackout;
	UITextField *textField;
	
	id editDelegate;
	
	Distinguish *check;
}

-(void)holdDown:(id)sender;
-(void)endEditing;

@property (nonatomic, retain) id editDelegate;

@end
