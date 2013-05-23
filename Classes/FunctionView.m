//
//  FunctionView.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "FunctionView.h"


@implementation FunctionView

-(id)init
{
	arrayOfBars = [[NSMutableArray alloc]init];
	return self;
}

-(void)shrinkScrollView
{
	int amount = 0;;
	
	if ([[CalcState sharedState] numFunctionBar] == 0) {
		for (id view in delegate.subviews) {
			if ([view class] == [MyButton class]) {
				UIButton *button = view;
				
				CALayer *layer = button.layer;
				
				if (button.tag < 0)
					break;
				
				if (button.frame.origin.y == 315)
					break;
				
				[UIView beginAnimations:nil context:NULL];
				[CATransaction begin];
				
				layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y,
										 layer.frame.size.width, layer.frame.size.height/1.165);
				
				int yPosition = (315 - layer.frame.origin.y) + layer.frame.origin.y - layer.frame.size.height*(315-layer.frame.origin.y)/70;
				
				amount = yPosition - layer.position.y;
				
				layer.frame = CGRectMake(layer.frame.origin.x, yPosition,
										 layer.frame.size.width, layer.frame.size.height);
				
				[CATransaction commit];
				[UIView commitAnimations];
				
				//[button.titleLabel setAdjustsFontSizeToFitWidth:YES];
			}
			else if ([view class] == [UIButton class]) {
				UIButton *button = view;
				
				CALayer *layer = button.layer;
				
				[UIView beginAnimations:nil context:NULL];
				[CATransaction begin];
				
				layer.frame = CGRectMake(layer.frame.origin.x,
										 60,
										 layer.frame.size.width,
										 layer.frame.size.height);
				
				[CATransaction commit];
				[UIView commitAnimations];
			}
			else if ([view class] == [UITextField class]) {
				UITextField *button = view;
				
				CALayer *layer = button.layer;
				
				[UIView beginAnimations:nil context:NULL];
				[CATransaction begin];
				
				layer.frame = CGRectMake(layer.frame.origin.x,
										 60,
										 layer.frame.size.width,
										 layer.frame.size.height);
				
				[CATransaction commit];
				[UIView commitAnimations];
			}
			/*else if ([view class] == [MyScrollView class]) {
				MyScrollView *scrollView = view;
				scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-amount*1.5,
											  scrollView.frame.size.width, scrollView.frame.size.height);
			}*/
		}
	}
	[self addFunctionBar:delegate.superview];
	[self translateLastBarObj];
	[[CalcState sharedState] setNumFunctionBar:[[CalcState sharedState] numFunctionBar]+1];
}

-(void)addFunctionBar:(UIView *)superV;
{
	UIView *newView;
	newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 325, 55)];
	[superV addSubview:newView];
	[superV insertSubview:newView atIndex:0];
	
	UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LED.PNG"]];
	image.frame = CGRectMake(0, 0, 325, 55);
	
	[newView addSubview:image];
	[image release];
	
	for (id view in superV.subviews) {
		if ([view class] == [MyScrollView class]) {
			MyScrollView *scrollView = view;
			[superV insertSubview:scrollView atIndex:0];
		}
	}
	
	//Add the new view to array
	[arrayOfBars addObject:newView];
}

-(void)translateLastBarObj
{
	UIView *lastObj = [arrayOfBars lastObject];
	CALayer *layer = lastObj.layer;
		
	[UIView beginAnimations:nil context:NULL];
	[CATransaction begin];
	
	layer.frame = CGRectMake(-2, 40, 325, 55);
	
	[CATransaction commit];
	[UIView commitAnimations];
}

-(void)dealloc
{
	[arrayOfBars release];
	[super dealloc];
}

@end
