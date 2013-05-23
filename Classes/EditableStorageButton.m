//
//  EditableStorageButton.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/11/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "EditableStorageButton.h"


@implementation EditableStorageButton

-(void)holdDown:(id)sender
{
	[timer invalidate];
	timer = nil;
	
	//Create blackout
	blackout = [[MyTranslucentView alloc]initWithFrame:CGRectMake(-1, -80, 320, 480)];
	blackout.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
	blackout.userInteractionEnabled = YES;
	blackout.delegate = self;
	[self.superview.superview addSubview:blackout];
	
	textField = [[UITextField alloc]initWithFrame:CGRectMake(160 - 150/2,
															 240 - 30*3,
															 150, 30)];
	
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;	
	
	//Info label
	MyLabel *label = [[MyLabel alloc]initWithFrame:CGRectMake(20, 240-30*8,
															  290, 70)];
	[label awakeFromNib];
	label.text = @"Editing the value for this number:";
	[label setAdjustsFontSizeToFitWidth:YES];
	//[label sizeToFit];
	[blackout addSubview:label];
	
	MyLabel *label2 = [[MyLabel alloc]initWithFrame:CGRectMake(15, 240-30*6.5,
															   290, 70)];
	[label2 awakeFromNib];
	label2.text = @"(Click anywhere to exit)";
	[label setAdjustsFontSizeToFitWidth:YES];
	//[label2 sizeToFit];
	[blackout addSubview:label2];
	[label release];
	[label2 release];
	
	[blackout addSubview:textField];
	textField.text = self.titleLabel.text;
	[textField becomeFirstResponder];
}

@end
