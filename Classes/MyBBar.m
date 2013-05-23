//
//  MyBBar.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MyBBar.h"


@implementation MyBBar

-(void)awakeFromNib
{
	menu = [[MyMenu alloc]init];
	menu.frame = CGRectMake(0, 0, 320, 410);
	menu.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	[self.superview addSubview:menu];
	menu.hidden = YES;
	menu.alpha = 0;
	menu.RightPar = par1;
	menu.LeftPar = par2;
	
	nodeMid = [UIButton buttonWithType:UIButtonTypeCustom];
	nodeRight = [UIButton buttonWithType:UIButtonTypeCustom];
	nodeLeft  = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[nodeMid setImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
	[nodeLeft setImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
	[nodeRight setImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
	
	nodeMid.frame = CGRectMake(self.frame.size.width/2-6, self.frame.size.height/2-20,
							   13, 13);
	
	nodeLeft.frame = CGRectMake(self.frame.size.width/2-6 - 26, self.frame.size.height/2-20,
								   13, 13);
	nodeRight.frame = CGRectMake(self.frame.size.width/2-6 + 26, self.frame.size.height/2-20,
								   13, 13);
	
	[self addSubview:nodeMid];
	[self addSubview:nodeLeft];
	[self addSubview:nodeRight];

	[nodeMid addTarget:self action:@selector(nodeTouched:) forControlEvents:UIControlEventTouchUpInside];
	[nodeRight addTarget:self action:@selector(nodeTouched:) forControlEvents:UIControlEventTouchUpInside];
	[nodeLeft addTarget:self action:@selector(nodeTouched:) forControlEvents:UIControlEventTouchUpInside];

	nodeMid.tag = MID;
	nodeLeft.tag = LEFT;
	nodeRight.tag = RIGHT;
	
	lastContentOffset = CGPointMake(320, 0);
	
	whichPointHighlighted = 0;
	
	nodeMid.highlighted = YES;
	
	[self addTarget:menu action:@selector(appear:) forControlEvents:UIControlEventTouchDownRepeat];
}

-(void)highlightButton:(int)index
{
	nodeMid.highlighted = NO;
	nodeRight.highlighted = NO;
	nodeLeft.highlighted = NO;
	
	if (index == LEFT)
		nodeLeft.highlighted = YES;
	else if (index == RIGHT)
		nodeRight.highlighted = YES;
	else 
		nodeMid.highlighted = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGPoint currentContentOffset = scrollView.contentOffset;

	if (currentContentOffset.x == 0) {
		whichPointHighlighted = LEFT;
	}
	else if (currentContentOffset.x == 640) {
		whichPointHighlighted = RIGHT;
	}
	else {
		whichPointHighlighted = MID;
	}
	
	[self highlightButton:whichPointHighlighted];
	lastContentOffset = currentContentOffset;
}

-(void)nodeTouched:(id)sender
{
	UIButton *button = sender;
	UIScrollView *superView = (UIScrollView *)self.delegate;
	switch (button.tag) {
		case RIGHT:
			[superView setContentOffset:CGPointMake(640, superView.contentOffset.y) animated:YES];
			break;
		case LEFT:
			[superView setContentOffset:CGPointMake(0, superView.contentOffset.y) animated:YES];
			break;
		case MID:
			[superView setContentOffset:CGPointMake(320, superView.contentOffset.y) animated:YES];
			break;
	}
	[self highlightButton:button.tag];
}

@synthesize delegate;

@end
