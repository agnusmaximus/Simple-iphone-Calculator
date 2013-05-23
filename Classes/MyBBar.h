//
//  MyBBar.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	The bottom bar, which acts as a gate to the menu

#import <UIKit/UIKit.h>
#import "MyMenu.h"

#define LEFT -1
#define MID 0
#define RIGHT 1

@interface MyBBar :  UIButton <UIScrollViewDelegate> {
	UIButton *nodeMid;
	UIButton *nodeRight;
	UIButton *nodeLeft;
	
	CGPoint lastContentOffset;
	
	int whichPointHighlighted;
	
	MyMenu *menu;
	
	IBOutlet id par1;
	IBOutlet id par2;
	
	IBOutlet id delegate;
}

-(void)highlightButton:(int)index;

-(void)nodeTouched:(id)sender;

@property (nonatomic,retain) id delegate;

@end
