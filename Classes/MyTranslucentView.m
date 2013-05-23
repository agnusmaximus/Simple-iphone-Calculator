//
//  MyTranslucentView.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/6/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MyTranslucentView.h"


@implementation MyTranslucentView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	if ([delegate respondsToSelector:@selector(endEditing)]) {
		[delegate endEditing];
	}
}

@synthesize delegate;

@end
