//
//  FootPrints.m
//  SimpleCalculator
//
//  Created by Max Lam on 5/21/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "FootPrints.h"


@implementation FootPrints

-(id)init
{
	[super init];
	inputQueue = [[NSMutableArray alloc]init];
	outputQueue = [[NSMutableArray alloc]init];
	userQueue = [[NSMutableArray alloc]init];
	effectsQueue = [[NSMutableArray alloc]init];
	mySounds = [[Sound alloc]init];
	check = [[Distinguish alloc]init];	
	
	operatorSign = -1;
	
	return self;
}

-(void)awakeFromNib
{	
	vertScrollView.frame = CGRectMake(0, 0, 320, 301);
	vertScrollView.contentSize = CGSizeMake(320, 301);
	vertScrollView.delaysContentTouches = NO;	
	vertScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	
	deleteButton = [MyButton buttonWithType:UIButtonTypeCustom];
	[deleteButton awakeFromNib];
	[deleteButton.titleLabel setFont:[UIFont fontWithName:@"orbitron" size:12]];
	deleteButton.frame = CGRectMake(ELBOW_SPACE, 266, 70, 45);
	[deleteButton setTitle:@"delete all" forState:UIControlStateNormal];
	[vertScrollView addSubview:deleteButton];
	
	
	////Searchfield
	searchfield = [[SearchPrints alloc]initWithFrame:CGRectMake(10, 10, 35, 30) andSuperView:vertScrollView.superview];
	//[searchfield setArray:inputQueue];
	[searchfield addArray:inputQueue];
	[searchfield addArray:outputQueue];

	[searchfield setScrollView:vertScrollView];
	
	//Attach outlets
	[deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchDown];

	brush = [[MyPatternBrush alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	brush.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	//[vertScrollView addSubview:brush];
	[brush setInputArray:inputQueue];
	
	brush.delegate = self;
	
	//Select mode button
	select = [UIButton buttonWithType:UIButtonTypeCustom];
	[select awakeFromNib];
	select.frame = CGRectMake(250, -0, 50, 40);
	[select setImage:[UIImage imageNamed:@"TB_selection_lasso2.png"] forState:UIControlStateNormal];
	//[select.titleLabel setFont:[UIFont fontWithName:@"orbitron" size:12]];
	//[select setTitle:@"sel" forState:UIControlStateNormal];
	[select addTarget:self action:@selector(toggleSelectMode:) forControlEvents:UIControlEventTouchDown];
	[vertScrollView.superview addSubview:select];
	
	isSelectMode = NO;
	
	vertScrollView.alpha = 5;
}

-(void)addToInput:(id)obj
{	
	MyEditableButton *newButton;

	//Create a button with tag of obj -- this is a normal number, not an operator
	//MyEditableButton *newButton = [MyEditableButton buttonWithType:UIButtonTypeCustom];
	
	if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
		
		//Check what class object is
		//This is a number not an operator
		if ([obj isKindOfClass:[NSString class]]) {
			newButton = [MyEditableButton buttonWithType:UIButtonTypeCustom];
			newButton.editDelegate = self;
			[newButton awakeFromNib];
			
			//Get the coordinates of this button
			float placementy = ([inputQueue count] * BUTTON_HEIGHT) + BUTTON_HEIGHT;
			float placementx = 50;
			
			//Create the frame
			newButton.frame = CGRectMake(placementx, placementy + ELBOW_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
			
			NSString *result = [NSString stringWithFormat:@"%g",[obj doubleValue]];
			
			//Set the button title to the value
			[newButton setTitle:result forState:UIControlStateNormal];
			
			//Adjust title rect and content rect if string too large
			[newButton sizeToFit];
			
			//Adjust a little more
			newButton.frame = CGRectMake(newButton.frame.origin.x, newButton.frame.origin.y,
										 newButton.frame.size.width+20, newButton.frame.size.height+15);
			
			//This button is a normal number
			newButton.tag = NUMBER;
			
			//Check if placement exceeds length of scroll view
			while (vertScrollView.contentSize.height <= (newButton.frame.origin.y + BUTTON_HEIGHT)) {
				vertScrollView.contentSize = CGSizeMake(320, vertScrollView.contentSize.height+BUTTON_HEIGHT+ELBOW_SPACE);
				//Move delete button down as well
				deleteButton.frame = CGRectMake(deleteButton.frame.origin.x,
												deleteButton.frame.origin.y+BUTTON_HEIGHT+ELBOW_SPACE,
												deleteButton.frame.size.width,
												deleteButton.frame.size.height);
			}
			
			//Then add to the queue
			[inputQueue addObject:newButton];
			
			//Then add to the view
			[vertScrollView addSubview:newButton];
		}
		else {//if ([obj isKindOfClass:[NSNumber class]]) {
			newButton = [MyButton buttonWithType:UIButtonTypeCustom];
			//Operator this time, do same thing except exchange tag and string and 1 extra step
			
			[newButton awakeFromNib];
			float placementy = [inputQueue count] * BUTTON_HEIGHT + BUTTON_HEIGHT;
			float placementx = 50;
			
			newButton.frame = CGRectMake(placementx, placementy + ELBOW_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
			
			[newButton setTitle:[self returnStringForOperatorSign:[obj intValue]]
					   forState:UIControlStateNormal];
			
			//Adjust title rect and content rect if string too large
			[newButton sizeToFit];
			
			//Adjust a little more
			newButton.frame = CGRectMake(newButton.frame.origin.x, newButton.frame.origin.y,
										 newButton.frame.size.width+20, newButton.frame.size.height+15);
			
			newButton.tag = operatorSign + OPERATOR;
			operatorSign = -1;
			
			//Check if placement exceeds length of scroll view again
			while (vertScrollView.contentSize.height <= (newButton.frame.origin.y + BUTTON_HEIGHT)) {
				vertScrollView.contentSize = CGSizeMake(320, vertScrollView.contentSize.height+BUTTON_HEIGHT+ELBOW_SPACE);
				//Move delete button down as well
				deleteButton.frame = CGRectMake(deleteButton.frame.origin.x,
												deleteButton.frame.origin.y+BUTTON_HEIGHT+ELBOW_SPACE,
												deleteButton.frame.size.width,
												deleteButton.frame.size.height);
			}		
			
			//Then add to queue
			[inputQueue addObject:newButton];
			
			[vertScrollView addSubview:newButton];
		}
	}
	else {
		
		//Equations mode?
		newButton = [MyEditableButton buttonWithType:UIButtonTypeCustom];
		newButton.editDelegate = self;
		[newButton awakeFromNib];
		
		[newButton setTitle:obj forState:UIControlStateNormal];
		
		newButton.tag = EQUATION;
		
		//Get the coordinates of this button
		float placementy = ([inputQueue count] * BUTTON_HEIGHT) + BUTTON_HEIGHT;
		float placementx = 50;
		
		//Create the frame
		newButton.frame = CGRectMake(placementx, placementy + ELBOW_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
		
		//Adjust title rect and content rect if string too large
		[newButton sizeToFit];
		
		//Adjust a little more
		newButton.frame = CGRectMake(newButton.frame.origin.x, newButton.frame.origin.y,
									 newButton.frame.size.width+20, newButton.frame.size.height+15);
		
		//Check if placement exceeds length of scroll view
		while (vertScrollView.contentSize.height <= (newButton.frame.origin.y + BUTTON_HEIGHT)) {
			vertScrollView.contentSize = CGSizeMake(320, vertScrollView.contentSize.height+BUTTON_HEIGHT+ELBOW_SPACE);
			//Move delete button down as well
			deleteButton.frame = CGRectMake(deleteButton.frame.origin.x,
											deleteButton.frame.origin.y+BUTTON_HEIGHT+ELBOW_SPACE,
											deleteButton.frame.size.width,
											deleteButton.frame.size.height);
		}
		
		//Then add to the queue
		[inputQueue addObject:newButton];
		
		//Then add to the view
		[vertScrollView addSubview:newButton];
	}
	//Add target
	[newButton addTarget:self action:@selector(touchAButton:) forControlEvents:UIControlEventTouchDown];
	[newButton setDelegate:self];
	
	//Check for ACs and add a dividing line to it
	if (newButton.tag != NUMBER) {
		//AC is an operator
		if ((newButton.tag == AC+OPERATOR || newButton.tag == EQU+OPERATOR) && [inputQueue count] > 1) {
			UIButton *storage = [inputQueue objectAtIndex:[inputQueue count]-2];
			//Dont add 2 ACs in a row
			if (storage.tag != AC + OPERATOR) {
				//AC
				float placementy = [inputQueue count] * BUTTON_HEIGHT + BUTTON_HEIGHT;
				float placementx = 0;
				float width = 320;
				float height = 2;
				UIImage *image = [UIImage imageNamed:@"divider.jpg"];
				UIImageView *divider = [[UIImageView alloc]initWithImage:image];
				divider.frame = CGRectMake(placementx, placementy,
										   width, height);
				[vertScrollView addSubview:divider];
				[effectsQueue addObject:divider];
				[divider release];
			}
			else {
				//Ac already pushed, pop it
				[self popFromInput];
			}
		}
	}
	[newButton setShouldDisableDuringDrag:NO];
	//Scroll to bottom of scroll view
	//CGPoint bottom = CGPointMake(0, [vertScrollView contentSize].height - 335);
	//[vertScrollView setContentOffset:bottom];
}

-(void)popFromInput
{
	//delete index 0
	if ([inputQueue count] > 0) {
		MyButton *button = [inputQueue objectAtIndex:[inputQueue count]-1];
		[button removeFromSuperview];
		[inputQueue removeObjectAtIndex:[inputQueue count]-1];
	}
}

-(void)clearInput
{
	int i;
	for (i = 0; i < [inputQueue count]; i++) {
		MyButton *button = [inputQueue objectAtIndex:i];
		[button removeFromSuperview];
	}
	[inputQueue removeAllObjects];
}

-(void)clearEffectsQueue
{
	int i;
	for (i = 0; i < [effectsQueue count]; i++) {
		UIImageView *imagev = [effectsQueue objectAtIndex:i];
		[imagev removeFromSuperview];
	}
	[effectsQueue removeAllObjects];
}

-(void)addToOutput:(id)obj
{						
	//obj will always be a string
	//Create a button with tag of obj -- this is a normal number, not an operator
	MyButton *newButton = [MyButton buttonWithType:UIButtonTypeCustom];
	[newButton awakeFromNib];
	
	[newButton setShouldDisableDuringDrag:NO];
	
	//Get the coordinates of this button
	float placementy = ([inputQueue count] * BUTTON_HEIGHT) + BUTTON_HEIGHT;
	float placementx = 80+ELBOW_SPACE;
	
	//Create the frame
	newButton.frame = CGRectMake(placementx, placementy + ELBOW_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
	
	NSString *result;
	
	//Check infs
	if ([obj isEqualToString:@"inf"]) {
		result = @"inf";
	}
	else {
		if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) 
			result = [NSString stringWithFormat:@"%g",[obj doubleValue]];
		else if ([[CalcState sharedState] CALCULATOR_MODE] == EQUATION_MODE) {
			result = obj;
			result = [result stringByReplacingOccurrencesOfString:@"﹣" withString:@"-"];
		}
	}
	
	//Set the button title to the value
	[newButton setTitle:result forState:UIControlStateNormal];
	
	//Adjust title rect and content rect if string too large
	[newButton sizeToFit];
	
	//Adjust a little more
	newButton.frame = CGRectMake(newButton.frame.origin.x, newButton.frame.origin.y,
								 newButton.frame.size.width+20, newButton.frame.size.height+15);
	
	//This button is a normal number
	newButton.tag = NUMBER;
	
	//Check if placement exceeds length of scroll view
	while (vertScrollView.contentSize.height <= (newButton.frame.origin.y + BUTTON_HEIGHT)) {
		vertScrollView.contentSize = CGSizeMake(320, vertScrollView.contentSize.height+BUTTON_HEIGHT+ELBOW_SPACE);
		//Move delete button down as well
		deleteButton.frame = CGRectMake(deleteButton.frame.origin.x,
										deleteButton.frame.origin.y+BUTTON_HEIGHT+ELBOW_SPACE,
										deleteButton.frame.size.width,
										deleteButton.frame.size.height);
	}
	
	if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) 
		[self addToInput:[NSNumber numberWithInt:EQU]];
	else 
		[self addToInput:@"="];
	
	[outputQueue addObject:newButton];
	[vertScrollView addSubview:newButton];
	//Set its target
	[newButton addTarget:self action:@selector(touchAButton:) forControlEvents:UIControlEventTouchDown];
	[newButton setDelegate:self];
	
	if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
		//Check for repeated =
		if ([inputQueue count] > 2) {
			MyButton *storage = [inputQueue objectAtIndex:[inputQueue count]-3];
			if (storage.tag == EQU+OPERATOR) {
				[self popFromInput];
				[self popFromInput];
				[self popFromOutput];
				[[effectsQueue lastObject] removeFromSuperview];
				[effectsQueue removeLastObject];
			}
		}
	}
	
	//Scroll to bottom of scroll view
	//CGPoint bottom = CGPointMake(0, [vertScrollView contentSize].height - 335);
	//[vertScrollView setContentOffset:bottom];
}

-(void)popFromOutput
{
	//delete index 0
	if ([outputQueue count] > 0) {
		MyButton *button = [outputQueue objectAtIndex:[outputQueue count]-1];
		[button removeFromSuperview];
		[outputQueue removeObjectAtIndex:[outputQueue count]-1];
	}
}

-(void)clearOutput
{
	int i;
	for (i = 0; i < [outputQueue count]; i++) {
		MyButton *button = [outputQueue objectAtIndex:i];
		[button removeFromSuperview];
	}
	[outputQueue removeAllObjects];
}

-(NSString *)returnStringForOperatorSign:(int)sign
{
	operatorSign = sign;
	NSString *string;
	switch (sign) {
		case ADD:
			string = @"+";
			break;
		case SUB:
			string = @"-";
			break;
		case MULT:
			string = @"×";
			break;
		case DIV:
			string = @"÷";
			break;
		case EQU:
			string = @"=";
			break;
		case XPOWY:
			string = @"yˣ";
			break;
		case XRTY:
			string = @"x√y";
			break;
		case INV:
			string = @"1/x";
			break;
		case SQRRT:
			string = @"√";
			break;
		case SQR:
			string = @"x²";
			break;
		case CUBE:
			string = @"x³";
			break;
		case SIN:
			string = @"sin";
			break;
		case COS:
			string = @"cos";
			break;
		case TAN:
			string = @"tan";
			break;
		case LOG2:
			string = @"log₂";
			break;
		case LOG10:
			string = @"log₁₀";
			break;
		case PI:
			string = @"π";
			break;
		case E:
			string = @"e";
			break;
		case SINH:
			string = @"sinh";
			break;
		case COSH:
			string = @"cosh";
			break;
		case TANH:
			string = @"tanh";
			break;
		case FACT:
			string = @"x!";
			break;
		case POSNEG:
			string = @"+/-";
			break;
		case CUBERT:
			string = @"∛";
			break;
		case SININV:
			string = @"sin⁻¹";
			break;
		case COSINV:
			string = @"cos⁻¹";
			break;
		case TANINV:
			string = @"tan⁻¹";
			break;
		case TWOEXP:
			string = @"2ˣ";
			break;
		case AC:
			string = @"AC";
			break;
		default:
			string = @"?";
			break;
	}
	return string;
}
	
-(IBAction)deleteAll
{
	//Get rid of everything in queues
	[self clearInput];
	[self clearOutput];
	[self clearEffectsQueue];
	
	//Readjust scrollview
	vertScrollView.contentSize = CGSizeMake(320, 301);
	
	//Readjust delete frame
	deleteButton.frame = CGRectMake(ELBOW_SPACE, 266, 70, 45);
}

-(void)touchAButton:(id)sender
{
	//When user taps a button in the footprints
	MyButton *button = sender;
	
	MyLabel *newLabel;
	
	//Convert coordinates
	CGPoint pointpos = [vertScrollView convertPoint:button.frame.origin toView:nil];
	
	//Spawn a label with number
	newLabel = [[MyLabel alloc]initWithFrame:CGRectMake(pointpos.x,
														pointpos.y - button.frame.size.height, 
														button.frame.size.width,
														button.frame.size.height)];
	[newLabel setText:button.titleLabel.text];
	[newLabel awakeFromNib];
	[userQueue addObject:newLabel];
	
	
	//Handles button touches
	if (button.tag == NUMBER) {
		newLabel.tag = NUMBER;
	}
	else if (button.tag == EQUATION) {
		newLabel.tag = EQUATION;
	}
	else {
		//Spawn a label with operator
		//Newlabel tag for operators will be different
		newLabel.tag = button.tag-OPERATOR;
	}
	lastPt = newLabel.center;
	
	//Set the label's index for later use (index in array
	newLabel.index = [inputQueue indexOfObject:button];
	
	[vertScrollView.superview.superview addSubview:newLabel];
	[newLabel release];
	
	//If this button is also selected
	if (button.buttonSelected == NO)
		return;
	
	//Also add other buttons that are selected
	for (MyButton *otherButton in inputQueue) {
		if (otherButton.buttonSelected == YES &&
			otherButton != button) {
			pointpos = [vertScrollView convertPoint:otherButton.frame.origin toView:nil];
			
			MyLabel *otherLabel = [[MyLabel alloc]initWithFrame:CGRectMake(pointpos.x, 
																		   pointpos.y - button.frame.size.height,
																		   otherButton.frame.size.width,
																		   otherButton.frame.size.height)];
			[otherLabel setText:otherButton.titleLabel.text];
			[otherLabel awakeFromNib];
			[userQueue addObject:otherLabel];
			
			otherLabel.index = [inputQueue indexOfObject:otherButton];
			
			if (otherButton.tag == NUMBER) {
				otherLabel.tag = NUMBER;
			}
			else if (otherButton.tag == EQUATION) {
				otherLabel.tag = EQUATION;
			}
			else {
				otherLabel.tag = otherButton.tag - OPERATOR;
			}
			[vertScrollView.superview.superview addSubview:otherLabel];
			[otherLabel release];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//User dragging button
	UITouch *currentTouch = [[event allTouches] anyObject];
    CGPoint currentPoint = [currentTouch locationInView:vertScrollView];
	
	MyLabel *label = [userQueue objectAtIndex:0];
	
	CGPoint pointpos = [vertScrollView convertPoint:currentPoint toView:nil];
	
	label.center = CGPointMake(pointpos.x - label.frame.size.width/4, 
							   pointpos.y - label.frame.size.height);
	label.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.8];
	
	//Get the offset from the last touch
	
	CGPoint offset;
	offset = CGPointMake(label.center.x - lastPt.x,
						 label.center.y - lastPt.y);
	
	//Move the rest of the buttons by the offset of the touched button
	
	for (MyLabel *myLabel in userQueue) {
		if (myLabel != label) {
			myLabel.center = CGPointMake(myLabel.center.x + offset.x,
										  myLabel.center.y + offset.y);
		}
	}
	//Update the last point touched
	lastPt = label.center;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	MyLabel *Zlabel = [userQueue objectAtIndex:0];
	[Zlabel removeFromSuperview];	
	
	BOOL didInputObjZ = NO;
	
	//Check if user dragged to input box
	if (CGRectIntersectsRect(Zlabel.frame, inputBox.frame)) {
		
		//Loop through everything in userQueue
		for (MyLabel *label in userQueue) {
			if (label != Zlabel) {
				if (!didInputObjZ) {
					//Check if the index of this first object is 
					//less than the index of the one being inputed
					if (Zlabel.index < label.index) {
						if ([[CalcState sharedState]CALCULATOR_MODE] == DIGITS_MODE) {	//Check state first
							//Push in Z Label first
							if ([delegate respondsToSelector:@selector(update:)]) {
								if (Zlabel.tag == NUMBER) {	
									//Check for state of calc
									if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
										//Incrementally insert number 1 by 1
										[self numberToDelegate:Zlabel.text];
									}
								}
								else if (Zlabel.tag == EQUATION) {
									if ([check isEquation:Zlabel.text]) {
										[mySounds error];
									}
									else {
										[self numberToDelegate:Zlabel.text];
									}
								}
								else {
									//Operator here -- tag will represent signal for function
									[delegate update:Zlabel];
								}
							}
						}
						else if ([[CalcState sharedState]CALCULATOR_MODE] == EQUATION_MODE) {
							//Equation mode
							NSString *concat = Zlabel.text;
							if (Zlabel.tag == NUMBER) {
								concat = [concat stringByReplacingOccurrencesOfString:@"-" withString:@"﹣"];
							}
							[screen concatenateToString:concat];
						}
						didInputObjZ = YES;
					}
				}
				//State check again
				if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
					//Send message to delegate
					if ([delegate respondsToSelector:@selector(update:)]) {
						if (label.tag == NUMBER) {				
							//Incrementally insert number 1 by 1
							[self numberToDelegate:label.text];
						}
						else if (label.tag == EQUATION) {
							if ([check isEquation:label.text]) {
								[mySounds error];
							}
							else {
								[self numberToDelegate:label.text];
							}	
						}
						else {
							//Operator here -- tag will represent signal for function
							[delegate update:label];
						}	
					}
				}
				else if ([[CalcState sharedState]CALCULATOR_MODE] == EQUATION_MODE) {
					//Concatenate to screen
					//Equation mode
					NSString *concat = label.text;
					if (label.tag == NUMBER) {
						concat = [concat stringByReplacingOccurrencesOfString:@"-" withString:@"﹣"];
					}
					[screen concatenateToString:concat];
				}
			}
		}
		//If object zero still has not been pushed in, it is the last one to be entered
		if (!didInputObjZ) {
			
			if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
				//Push in Z Label first
				if ([delegate respondsToSelector:@selector(update:)]) {
					if (Zlabel.tag == NUMBER) {				
						//Incrementally insert number 1 by 1
						[self numberToDelegate:Zlabel.text];
					}
					else if (Zlabel.tag == EQUATION) {
						if ([check isEquation:Zlabel.text]) {
							[mySounds error];
						}
						else {
							[self numberToDelegate:Zlabel.text];
						}
					}
					else {
						//Operator here -- tag will represent signal for function
						[delegate update:Zlabel];
					}
				}
			}
			else if ([[CalcState sharedState] CALCULATOR_MODE] == EQUATION_MODE) {
				//Concatenate to screen
				//Equation mode
				NSString *concat = Zlabel.text;
				if (Zlabel.tag == NUMBER) {
					concat = [concat stringByReplacingOccurrencesOfString:@"-" withString:@"﹣"];
				}
				[screen concatenateToString:concat];
			}
		}
		
		//Change selected flag of userinput queue buttons
		for (MyButton *button in inputQueue) {
			button.buttonSelected = NO;
		}
	}
	
	//Remove all the rest from superview
	for (int i = 0; i < [userQueue count]; i++) {
		UILabel *label = [userQueue objectAtIndex:i];
		[label removeFromSuperview];
	}
	
	//[userQueue removeObjectAtIndex:0];
	//Then, for safety, remove all objects
	[userQueue removeAllObjects];
}	

-(void)numberToDelegate:(NSString *)number
{
	int x;
	BOOL isNeg = NO;
	
	if ([number isEqualToString:@"inf"] ||
		[[CalcState sharedState]stateOK] == NO) {
		[mySounds error];
		return;
	}
	
	for (x = 0; x < [number length]; x++) {
		UIButton *button = [[UIButton alloc]init];
		//Create a button with an appropriate tag
		unichar charac = [number characterAtIndex:x];
		if (charac == '-')
			isNeg = YES;
		button.tag = [self characterToNumber:charac];
		if (charac == 'e') {
			x++;
		}
		[delegate update:button];
		[button release];
	}
	if (isNeg) {
		//create a negative button
		UIButton *button = [[ UIButton alloc]init];
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

-(BOOL)isSignUnaryOperator:(id)sign
{
	UILabel *label = sign;
	
	//Unary operator is a function thus NSNumber
	if (label.tag >= 18 && label.tag <= 33) {
		return YES;
	}
	else if (label.tag >= 37 && label.tag <= 41) {
		return YES;
	}
	return NO;
}

-(void)toggleSelectMode:(id)sender
{
	//Toggle select mode
	if (isSelectMode == NO) {
		isSelectMode = YES;
		UIScrollView *sup = (UIScrollView *)vertScrollView.superview;
		sup.scrollEnabled = NO;
		vertScrollView.scrollEnabled = NO;
		[sup addSubview:brush];
		[select setBackgroundImage:[UIImage imageNamed:@"buttonSelectedState.png"] forState:UIControlStateNormal];
	}
	else if (isSelectMode == YES) {
		isSelectMode = NO;
		UIScrollView *sup = (UIScrollView *)vertScrollView.superview;
		sup.scrollEnabled = YES;
		vertScrollView.scrollEnabled = YES;
		[brush removeFromSuperview];
		select.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[select setBackgroundImage:nil forState:UIControlStateNormal];
	}
}

-(void)reddifyEditedButton:(MyEditableButton *)button
{
	UIView *redHighlight = [[UIView alloc]initWithFrame:CGRectMake(0,
																  button.frame.origin.y,
																   320, button.frame.size.height)];
	redHighlight.userInteractionEnabled = NO;
	redHighlight.backgroundColor = [UIColor colorWithRed:0 green:.5 blue:1 alpha:.3];
	[vertScrollView addSubview:redHighlight];
	[effectsQueue addObject:redHighlight];
	[redHighlight release];
}

-(void)dealloc
{
	[check release];
	[searchfield release];
	[inputQueue release];
	[outputQueue release];
	[userQueue release];
	[effectsQueue release];
	[mySounds release];
	[super dealloc];
}

@synthesize delegate;
@synthesize searchfield;
@synthesize vertScrollView;
@synthesize inputQueue;

@end
