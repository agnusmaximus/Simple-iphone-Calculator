//
//  SearchNum.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/3/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "SearchNum.h"


@implementation SearchNum

-(id)initWithFrame:(CGRect)frame andSuperView:(UIView *)view
{
	[super init];

	//Initialize the button and textfiedl together
	searchButton = [[UIButton alloc]initWithFrame:frame];
	[searchButton setImage:[UIImage imageNamed:@"search-icon.png"] forState:UIControlStateNormal];
	
	[searchButton awakeFromNib];
	[view addSubview:searchButton];
	
	[searchButton addTarget:self action:@selector(toggleField:) forControlEvents:UIControlEventTouchDown];
	
	//Initialize textfield
	CGRect textfieldframe = CGRectMake(frame.origin.x + frame.size.width,
									   frame.origin.y + frame.size.height/8,
									   TEXTFIELD_SIZE_W,
									   TEXTFIELD_SIZE_H);
	searchTextField = [[UITextField alloc]initWithFrame:textfieldframe];
	[view addSubview:searchTextField];
	[searchTextField setBorderStyle:UITextBorderStyleRoundedRect];
	searchTextField.hidden = YES;
	
	//Set the textfield delegate to self
	searchTextField.delegate = self;
	
	nextButton = [[MyButton alloc]init];
	nextButton.frame = CGRectMake(frame.origin.x+frame.size.width*1.25+TEXTFIELD_SIZE_W,
								   frame.origin.y+ TEXTFIELD_SIZE_H/5, 
								   TEXTFIELD_SIZE_H, 
								   TEXTFIELD_SIZE_H);
	
	[nextButton awakeFromNib];
	nextButton.tag = -1;
	[nextButton setShouldDisableDuringDrag:NO];
	[view addSubview:nextButton];
	
	[nextButton setImage:[UIImage imageNamed:@"nex.png"] forState:UIControlStateNormal];
	[nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchDown];
	
	nextButton.hidden = YES;
	
	//Notifications
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextFieldTextDidChangeNotification object: nil];
	
	return self;
}

-(void)toggleField:(id)sender
{
	if (searchTextField.hidden == NO) {
		searchTextField.hidden = YES;
		nextButton.hidden = YES;
		[searchTextField resignFirstResponder];
	}
	else { 
		searchTextField.hidden = NO;
		nextButton.hidden = NO;
		[searchTextField becomeFirstResponder];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	textField.text = @"";
	[self toggleField:nil];
	return YES;
}

-(void)setScrollView:(UIScrollView *)sView
{
	//Set scrollview
	scrollView = sView;
}

-(void)setArray:(NSMutableArray *)ray
{
	array = ray;
}	

-(void)searchWithinArray
{
	//Search for the string within the scrollview
	NSString *searchstring = searchTextField.text;
	
	if (searchstring == nil)
		return;
	
	static int i = 0;
	for (i; i < [array count]; i++) {
		MyButton *button = [array objectAtIndex:i];
		NSRange range = [button.titleLabel.text rangeOfString:searchstring];
		if (range.location != NSNotFound) {
			//Found a match
			//Scroll to this button
			CGPoint bottomOffset = CGPointMake(0,
											   button.frame.origin.y);
			[scrollView setContentOffset: bottomOffset animated: YES];
			
			if (i < [array count])
				i++;
			else {
				i = 0;
			}
			return;
		}
	}
	i = 0;
}

-(void) keyPressed: (NSNotification*) notification
{
	[self searchWithinArray];
}

-(void)nextButton:(id)sender
{
	[self searchWithinArray];
}

-(void)dealloc
{
	[searchButton release];
	[searchTextField release];
	[super dealloc];
}

@synthesize searchTextField;

@end
