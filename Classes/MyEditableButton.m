//
//  MyEditableButton.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/6/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MyEditableButton.h"
#import "FootPrints.h"

@implementation MyEditableButton

-(id)initWithFrame:(CGRect)frame
{
	[super initWithFrame:frame];
	check = [[Distinguish alloc]init];
	return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	//Check for more than 1 second press-down
	timer = [NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(holdDown:) userInfo:nil repeats:NO];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	[timer invalidate];
	timer = nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	[timer invalidate];
	timer = nil;
}

-(void)holdDown:(id)sender
{
	[timer invalidate];
	timer = nil;
	
	//Create blackout
	blackout = [[MyTranslucentView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	blackout.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
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

-(void)endEditing
{
	if (![textField.text isEqualToString:self.titleLabel.text] && [textField.text length] != 0) {
		//Values changed, highlight
		if ([delegate respondsToSelector:@selector(reddifyEditedButton:)]) {
			[delegate reddifyEditedButton:self];
		}
	}
	
	if ([textField.text length] != 0) {
		//[self setTitle:[NSString stringWithFormat:@"%g",[textField.text doubleValue]] forState:UIControlStateNormal];
		[self setTitle:textField.text forState:UIControlStateNormal];
		[self sizeToFit];
	
		if ([check isEquation:self.titleLabel.text]) {
			self.tag = EQUATION;
		}
	
	//Adjust a little more
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
								 self.frame.size.width+20, self.frame.size.height+15);
	
	}
	
	[textField removeFromSuperview];
	[textField release];
	textField = nil;
	
	[blackout removeFromSuperview];
	[blackout release];
	blackout = nil;
}

-(void)dealloc
{
	[check release];
	[super dealloc];
}	

@synthesize editDelegate;

@end
