//
//  MyButton.m
//  Calculator2
//
//  Created by Max Lam on 5/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

-(void)awakeFromNib
{
	//Customize my buttons
	UIFont *newFont = [UIFont fontWithName:@"orbitron" size:26];

	[self titleLabel].font = newFont;
	[self setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateHighlighted];
	
	//[self setBackgroundImage:[UIImage imageNamed:@"button2.png"] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageNamed:@"buttonSelectedState.png" ] forState:UIControlStateHighlighted];

	shouldDisableDuringDrag = YES;
	self.alpha = 5;
	
	//Button is not selected
	buttonSelected = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	if (shouldDisableDuringDrag) {
		[self setEnabled:NO];
		return;
	}
	[delegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[super touchesEnded:touches withEvent:event];
	[delegate touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
	[super touchesCancelled:touches withEvent:event];
}

-(void)setShouldDisableDuringDrag:(BOOL)yesOrNo
{
	shouldDisableDuringDrag = yesOrNo;
	if (shouldDisableDuringDrag == NO) {
		self.alpha = 1;
	}
}

-(void)setButtonSelected:(BOOL)yesOrNO
{
	buttonSelected = yesOrNO;
	if (buttonSelected == YES) {
		//Highligh
		self.backgroundColor = [UIColor colorWithRed:.5 green:0 blue:0 alpha:.4];
	}
	else {
		//De-highlight
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	}
}

@synthesize delegate;
@synthesize buttonSelected;

@end
