//
//  MagicBox.m
//  SimpleCalculator
//
//  Created by Max Lam on 6/1/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "MagicBox.h"
#import "CalculatorConnect.h"

@implementation MagicBox

-(id)initWithView:(UIScrollView *)sView
{
	[super init];
	superView = sView;
	view = [[UIImageView alloc]init];
	
	//view.frame = CGRectMake(320, 70, 320, 400);
	view.frame = CGRectMake(321, 70, 246, 270);
	view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
	view.alpha = 0;
	view.userInteractionEnabled = YES;
	[view setImage:[UIImage imageNamed:@"Frame.png"]];

	//view.hidden = YES;
	[superView addSubview:view];
	
	//Create a label as well for directions
	MyLabel *dir = [[MyLabel alloc]init];
	[dir awakeFromNib];
	dir.text = @"Storage";
	dir.frame = CGRectMake(0, 0, 246, 50);
	dir.adjustsFontSizeToFitWidth = YES;
	[view addSubview:dir];
	[dir release];
	hidden = YES;
	
	//Create a scroll view
	scrollView = [[UIScrollView alloc]init];
	scrollView.frame = CGRectMake(0, 40, 246, 220);
	scrollView.contentSize = CGSizeMake(246, 240);
	scrollView.delaysContentTouches = NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.directionalLockEnabled = YES;
	scrollView.canCancelContentTouches = YES;
	[scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 480) animated:NO];
	
	//scrollView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	
	
	[view addSubview:scrollView];
	
	//Create the queue
	queue = [[NSMutableArray alloc]init];
	deleteButtonQueue = [[NSMutableArray alloc]init];
	
	mySounds = [[Sound alloc]init];
	
	//Searchfield
	searchfield = [[SearchPrints alloc]initWithFrame:CGRectMake(10, 10, 35, 30) andSuperView:view];
	[searchfield addArray:queue];
	[searchfield setScrollView:scrollView];
	
	check = [[Distinguish alloc]init];
	
	return self;
}

-(void)toggleOnOff
{
/*	if (view.hidden == YES)
		view.hidden = NO;
	else 
		view.hidden = YES;*/
	
	if (hidden == NO) {
		//Scroll
		if ([actionTimer isValid])
			return;
		//Toggle scroll view
		superView.scrollEnabled = YES;
		
		actionTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_SPEED target:self selector:@selector(scroll) userInfo:nil repeats:YES];
		hidden = YES;
	}
	else {
		//Unscroll
		if ([actionTimer isValid])
			return;
		superView.scrollEnabled = NO;
		
		actionTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_SPEED target:self selector:@selector(unscroll) userInfo:nil repeats:YES];
		hidden = NO;
	}
}

-(void)unscroll
{
	//Make the extra view appear
	//view.frame = CGRectMake(320, 30, 320, view.frame.size.height+EXPAND_RATE);
	view.alpha += EXPAND_RATE;
	if (view.alpha >= 1) {
		[actionTimer invalidate];
		actionTimer = nil;
	}
}

-(void)scroll
{
	//Make the extra view disappear
	//view.frame = CGRectMake(320, 30, 320, view.frame.size.height-EXPAND_RATE);
	view.alpha -= EXPAND_RATE;
	if (view.alpha <= 0) {
		[actionTimer invalidate];
		actionTimer = nil;
		if ([searchfield.searchTextField isFirstResponder])
			[searchfield textFieldShouldReturn:searchfield.searchTextField];
	}
}

-(void)addToQueue:(id)obj
{
	//Add to the queue and also to the storage
	//Create a button with the object name -- object should be NSString for number
	EditableStorageButton *newButton = [EditableStorageButton buttonWithType:UIButtonTypeCustom];
	
	//delegate
	newButton.delegate = self;
	
	//action
	[newButton addTarget:self action:@selector(touchAButton:) forControlEvents:UIControlEventTouchDown];
	
	[newButton awakeFromNib];
	
	[newButton setShouldDisableDuringDrag:NO];
	
	//Make the font smaller
	newButton.titleLabel.font = [UIFont fontWithName:@"orbitron" size:20];
	
	//Get the coordinates of this button
	float placementy = ([queue count] * BUTTON_HEIGHT);
	float placementx = 50;
	
	//Create the frame
	newButton.frame = CGRectMake(placementx, placementy + ELBOW_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
	
	NSString *result;
	
	if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
		result = [NSString stringWithFormat:@"%g",[obj doubleValue]];
		newButton.tag = DIGITS_VAR;
	}
	else if ([[CalcState sharedState] CALCULATOR_MODE] == EQUATION_MODE) {
		result = obj;
	}
	
	//Set the button title to the value
	[newButton setTitle:result forState:UIControlStateNormal];
	
	//Adjust title rect and content rect if string too large
	[newButton sizeToFit];
	
	//Adjust a little more
	newButton.frame = CGRectMake(newButton.frame.origin.x, newButton.frame.origin.y,
								 newButton.frame.size.width+20, newButton.frame.size.height+15);
	
	//Check if placement exceeds length of scroll view
	while (scrollView.contentSize.height <= (newButton.frame.origin.y + BUTTON_HEIGHT)) {
		scrollView.contentSize = CGSizeMake(245, scrollView.contentSize.height+BUTTON_HEIGHT+ELBOW_SPACE);
	}
	
	//Then add to the queue
	[queue addObject:newButton];
	
	//Then add to the view
	[scrollView addSubview:newButton];
	
	//Now add a delete button next to it
	MyButton *del = [MyButton buttonWithType:UIButtonTypeCustom];
	[del awakeFromNib];
	del.frame = CGRectMake(0, placementy, 55, 35);
	//Delete tag will specify the index of the queue to delete
	del.tag = [queue count];
	[del setTitle:@"-" forState:UIControlStateNormal];
	del.titleLabel.textColor = [UIColor redColor];
	[del setShouldDisableDuringDrag:NO];
	
	[del addTarget:self action:@selector(deleteFromQueue:) forControlEvents:UIControlEventTouchUpInside];
	
	//Add the del button to a queue
	[deleteButtonQueue addObject:del];
	
	//Add it to subview
	[scrollView addSubview:del];
	
	//Scroll to bottom of scroll view
	CGPoint bottom = CGPointMake(0, [scrollView contentSize].height - 240);
	[scrollView setContentOffset:bottom];
}

-(void)deleteFromQueue:(id)sender
{
	MyButton *index = sender;
	
	//delete number at index of index.tag
	MyButton *buttonToDelete = [queue objectAtIndex:index.tag-1];
	
	//Change the tags of the delete buttons
	[self subtract1fromTag:index.tag-1];
	
	//Remove from superview
	[buttonToDelete removeFromSuperview];
	//Remove it from queue
	[queue removeObjectAtIndex:index.tag-1];
	
	//Now release it
	buttonToDelete = nil;
	
	//If this button is not the last one, move every subsequent button up by 1
	if (index.tag-1 < [queue count]) {
		//Move every subsequent button up by 1
		[self moveUp:index.tag-1];
	}
		
	//Also release and remove the delete button
	[index removeFromSuperview];
	[deleteButtonQueue removeObject:index];
	index = nil;	
}

-(void)subtract1fromTag:(int)index
{
	//Subtracts 1 from all delete buttons beyond index
	for (int i = index+1; i < [deleteButtonQueue count]; i++) {
		MyButton * button = [deleteButtonQueue objectAtIndex:i];
		button.tag -= 1;
	}
}

-(void)moveUp:(int)index
{
	for (int i = index; i < [queue count]; i++) {
		//Move every button up by 1
		MyButton *button = [queue objectAtIndex:i];
		button.frame = CGRectMake(50.0f, i * BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT);
		[button sizeToFit];
		
		//Adjust a little more
		button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y,
									 button.frame.size.width+20, button.frame.size.height+15);
		
		//Also move delete button up
		MyButton *delButton = [deleteButtonQueue objectAtIndex:i+1];
		delButton.frame = CGRectMake(0, delButton.frame.origin.y - BUTTON_HEIGHT, 55, 35);
	}
	if (scrollView.contentSize.height > 240) {
		//Readjust scrollview
		scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, 
											scrollView.contentSize.height-BUTTON_HEIGHT-ELBOW_SPACE);
	}
}

-(void)touchAButton:(id)sender
{
	//When user taps a button in the footprints
	MyButton *button = sender;
	
	MyLabel *newLabel;
	
	//LOL 3 superviews... Yes I know
	//Convert coordinates
	CGPoint pointpos = [scrollView.superview.superview.superview convertPoint:button.frame.origin fromView:scrollView];
	
	//Spawn a label with number
	newLabel = [[MyLabel alloc]initWithFrame:CGRectMake(pointpos.x,
														pointpos.y - button.frame.size.height/2, 
														button.frame.size.width,
														button.frame.size.height)];
	[newLabel setText:button.titleLabel.text];
	
	[newLabel awakeFromNib];
	
	if (button.tag == DIGITS_VAR) {
		newLabel.tag = button.tag;
	}
	
	[scrollView.superview.superview.superview addSubview:newLabel];
	//Set our label
	uLabel = newLabel;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//User dragging button
	UITouch *currentTouch = [[event allTouches] anyObject];
    CGPoint currentPoint = [currentTouch locationInView:scrollView];
	
	//LOL 3 superviews... Yes I know
	CGPoint pointpos = [scrollView.superview.superview.superview convertPoint:currentPoint fromView:scrollView];
	
	uLabel.center = CGPointMake(pointpos.x - uLabel.frame.size.width/4, 
							   pointpos.y - uLabel.frame.size.height/2);
	uLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	//Check if the label was dropped into the input box
	if (CGRectIntersectsRect(uLabel.frame, inputBox.frame)) {
		if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
			BOOL shouldInput = YES;
			if (uLabel.tag != DIGITS_VAR) {
				if ([check isEquation:uLabel.text]) {
					[mySounds error];
					shouldInput = NO;
				}
			}
			if (shouldInput)
				[self numberToDelegate:uLabel.text];
		}
		else {
			if (uLabel.tag == DIGITS_VAR) {
				uLabel.text = [uLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@"﹣"];
			}
			
			[screen concatenateToString:uLabel.text];
		}
	}
	
	//then remove it from the superview and release it
	[uLabel removeFromSuperview];
	[uLabel release];
	uLabel = nil;
}	

-(void)numberToDelegate:(NSString *)number
{
	int x;
	
	if ([number isEqualToString:@"inf"] ||
		[[CalcState sharedState]stateOK] == NO) {
		[mySounds error];
		return;
	}
	
	for (x = 0; x < [number length]; x++) {
		UIButton *button = [[UIButton alloc]init];
		//Create a button with an appropriate tag
		unichar charac = [number characterAtIndex:x];
		button.tag = [self characterToNumber:charac];
		if (charac == 'e') {
			x++;
		}
		[delegate update:button];
		[button release];
	}
	
	if ([number rangeOfString:@"-"].location != NSNotFound ||
		[number rangeOfString:@"﹣"].location != NSNotFound) {
		UIButton *button = [[UIButton alloc]init];
		button.tag = POSNEG;
		[delegate update:button];
		[button release];
	}
}

-(int)characterToNumber:(unichar)charac
{
	switch (charac) {
		case '1':
			return 1;
		case '2':
			return 2;
		case '3':
			return 3;
		case '4':
			return 4;
		case '5':
			return 5;
		case '6':
			return 6;
		case '7':
			return 7;
		case '8':
			return 8;
		case '9':
			return 9;
		case '0':
			return 0;
		case 'e':
			return SCIE;
		case '.':
			return PT;
	}
	return 0;
}

-(void)saveData
{
	//Save whatever has been inputed into the storage box
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	//First save the number of entries
	[prefs setInteger:[queue count] forKey:@"numEntries"];
	
	//Next save all of the entries
	for (int i = 0; i < [queue count]; i++) {
		MyButton *button = [queue objectAtIndex:i];
		[prefs setObject:button.titleLabel.text forKey:[NSString stringWithFormat:@"%d",i]];
	}
	[prefs synchronize];
}

-(void)loadData
{
	//Restore data
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	int num_entries = [prefs integerForKey:@"numEntries"];
	[prefs removeObjectForKey:@"numEntries"];
	for (int i = 0; i < num_entries; i++) {
		NSString *number = [prefs objectForKey:[NSString stringWithFormat:@"%d",i]];
		[self addToQueue:number];
		[prefs removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
	}
}

-(void)dealloc
{
	[check release];
	[mySounds release];
	[queue release];
	[deleteButtonQueue release];
	[searchfield release];
	[super dealloc];
}

@synthesize view;
@synthesize hidden;
@synthesize inputBox;
@synthesize delegate;
@synthesize searchfield;
@synthesize screen;

@end
