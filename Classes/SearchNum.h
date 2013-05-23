//
//  SearchNum.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/3/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This will provide a search functionality to Footprints or MagicBox

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MyLabel.h"

#define TEXTFIELD_SIZE_W 150
#define TEXTFIELD_SIZE_H 25

@interface SearchNum : NSObject <UITextFieldDelegate> {
	//A button to pop up the search bar
	MyButton *searchButton;
	MyButton *nextButton;
	
	//A textfield to let the user search
	UITextField *searchTextField;
	
	//Scrollview to search within
	UIScrollView *scrollView;
	
	//array which contains the value
	NSMutableArray *array;
}

-(id)initWithFrame:(CGRect)frame andSuperView:(UIView *)view;

-(void)toggleField:(id)sender;
-(void)setScrollView:(UIScrollView *)sView;
-(void)setArray:(NSMutableArray *)ray;

-(void)searchWithinArray;

-(void)nextButton:(id)sender;

@property (nonatomic, retain) UITextField * searchTextField;

@end
