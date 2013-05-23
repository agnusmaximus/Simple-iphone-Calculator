//
//  MyScrollView.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/4/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MyScrollView.h"


@implementation MyScrollView

-(void)awakeFromNib
{
	self.delegate = self;
	resultedFromDec = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	NSArray   *views = [self subviews];
	
    for (id aView in views)
    {
		if ([aView class] == [MyButton class]) {
			MyButton *button = aView;
			if (button.enabled == NO)
				button.enabled = YES;
		}
    }
	if (!resultedFromDec) {
		for (id button in views) {
			if ([button class] == [MyButton class] ||
				[button class] == [MyEditableButton class]) {
				MyButton *mButton = button;
				mButton.buttonSelected = NO;
			}
		}
	}
	resultedFromDec = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
	resultedFromDec = YES;
	[self touchesEnded:nil withEvent:nil];
	
	[otherDelegate scrollViewDidEndDecelerating:scrollView];
}

-(BOOL)touchesShouldCancelInContentView:(UIView *)view
{
	if (view.alpha > 1) {
		return YES;
	}
	return NO;
}

@end
