//
//  SimpleCalculatorViewController.m
//  SimpleCalculator
//
//  Created by Max Lam on 5/19/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "SimpleCalculatorViewController.h"
#import "SimpleCalculatorAppDelegate.h"
#import "EquationConnect.h"

@implementation SimpleCalculatorViewController




// The designated initializer. Override to perform setup that is required before the view is loaded.
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	scrollView.frame = CGRectMake(0, 54, 320, 415);
	scrollView.contentSize = CGSizeMake(960, 415);
	scrollView.delaysContentTouches = NO;
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.directionalLockEnabled = YES;
	scrollView.canCancelContentTouches = YES;
	[scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 480) animated:NO];
	
	magicBox = [[MagicBox alloc]initWithView:scrollView];
	[magicBox setInputBox:[screen LEDscreen]];
	[magicBox setDelegate:connect];
	[magicBox setScreen:screen];
	
	[magicEntry setShouldDisableDuringDrag:NO];
	
	equationCalc = [[EquationConnect alloc]initWithLEDScreen:screen];
	equationCalc.delegate = morphs;
	equationCalc.footprints = footprints;

	if ([CalcState sharedState].CALCULATOR_MODE == DIGITS_MODE) {
		RightPar.hidden = YES;
		LeftPar.hidden = YES;
	}
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(IBAction)buttonPressed:(id)sender {
	static int lastMode = DIGITS_MODE;
	
	UIButton *button = sender;
	
	if (button.tag == SUM_FUNC) {
		[functionBar shrinkScrollView];
		return;
	}
	
	if (lastMode != [[CalcState sharedState] CALCULATOR_MODE]) {
	//	[screen setScreenString:@"0"];
		if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
			[screen setScreenString:[[screen screenString] stringByReplacingOccurrencesOfString:@"﹣" withString:@"-"]];
		}
		else if ([[CalcState sharedState] CALCULATOR_MODE] == EQUATION_MODE) {
			[screen setScreenString:[[screen screenString] stringByReplacingOccurrencesOfString:@"-" withString:@"﹣"]];
		}
		
		[screen setOperatorString:@""];
	}
	
	if ([CalcState sharedState].CALCULATOR_MODE == DIGITS_MODE) {
		//Handle button pressed -- send message to delegate
		if ([delegate respondsToSelector:@selector(update:)]) {
			[delegate update:sender];
		}
	}
	else {
		//Equation mode
		[equationCalc receive:sender];
	}
	
	if ([CalcState sharedState].CALCULATOR_MODE == DIGITS_MODE) {
		RightPar.hidden = YES;
		LeftPar.hidden = YES;
	}
	else {
		//Enable parenthases
		RightPar.hidden = NO;
		LeftPar.hidden = NO;
	}
	
	lastMode = [[CalcState sharedState] CALCULATOR_MODE];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//[self setupForOrientation:toInterfaceOrientation];
	return NO;
}

-(IBAction)MagickBox:(id)sender
{
	[magicBox toggleOnOff];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//The user touched the LED, create a UILabel of the ledscreen number
	
	UITouch *currentTouch = [[event allTouches] anyObject];
    CGPoint currentPoint = [currentTouch locationInView:scrollView.superview];
	
	MyLabel *newLabel;
	
	//Convert coordinates
	if (!CGRectContainsPoint(screen.LEDscreen.frame, currentPoint)) 
		return;
	
	//Spawn a label with number
	newLabel = [[MyLabel alloc]initWithFrame:CGRectMake(currentPoint.x - 140,
														currentPoint.y - 40, 
														250,
														50)];
	[newLabel setAdjustsFontSizeToFitWidth:YES];
	
	NSString *real_string = [screen screenString];
	//real_string = [real_string stringByReplacingOccurrencesOfString:@"﹣" withString:@"-"];
	
	if ([[CalcState sharedState] CALCULATOR_MODE] == DIGITS_MODE) {
		[newLabel setText:[NSString stringWithFormat:@"%g",[real_string	doubleValue]]];
		[newLabel awakeFromNib];
		[scrollView.superview addSubview:newLabel];
	}
	else if ([[CalcState sharedState] CALCULATOR_MODE] == EQUATION_MODE) {
		[newLabel setText:real_string];
		[newLabel awakeFromNib];
		[scrollView.superview addSubview:newLabel];
	}
		
	uLabel = newLabel;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Keep the label up with the user's finger
	UITouch *currentTouch = [[event allTouches] anyObject];
    CGPoint currentPoint = [currentTouch locationInView:scrollView.superview];
	
	uLabel.frame = CGRectMake(currentPoint.x - 140,
							  currentPoint.y - 40, 
							  250,
							  50);
	
	CGPoint mainPoint = [currentTouch locationInView:scrollView];
	
	if (CGRectContainsPoint(magicEntry.frame, mainPoint)) {
		//Highlight the storage icon
		magicEntry.highlighted = YES;
	}
	else {
		magicEntry.highlighted = NO;
	}
	
	//Check within storage search bar
	CGPoint windowPoint = [currentTouch locationInView:magicBox.view];
	
	if (CGRectContainsPoint(magicBox.searchfield.searchTextField.frame, windowPoint)) {
		magicBox.searchfield.searchTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
	}
	else {
		magicBox.searchfield.searchTextField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
	}
	
	//Check within footprints check bar
	FootPrints *foot = footprints;
	if (CGRectContainsPoint(foot.searchfield.searchTextField.frame, mainPoint)) {
		foot.searchfield.searchTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
	}
	else {
		foot.searchfield.searchTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *currentTouch = [[event allTouches] anyObject];
    CGPoint currentPoint = [currentTouch locationInView:scrollView.superview];
	
	CGPoint pointpos = [scrollView convertPoint:currentPoint fromView:scrollView.superview];
	CGPoint windowPoint = [currentTouch locationInView:magicBox.view];
	
	FootPrints *footprint = footprints;
	
	if (CGRectContainsPoint(magicBox.searchfield.searchTextField.frame, windowPoint)) {
		magicBox.searchfield.searchTextField.text = uLabel.text;
	}
	//Detect if the label was "dropped" anywhere
	else if (CGRectContainsPoint(magicBox.view.frame, pointpos) ||
		CGRectContainsPoint(magicEntry.frame, pointpos)) {
		//User wants to drop this value into storage
		[magicBox addToQueue:uLabel.text];
	}
	else if (CGRectContainsPoint(footprint.searchfield.searchTextField.frame, pointpos)) {
		footprint.searchfield.searchTextField.text = uLabel.text;
	}
	
	//If not, remove and release it
	[uLabel removeFromSuperview];
	[uLabel release];
	uLabel = nil;
	//Make an error sound?
	
	magicEntry.highlighted = NO;
	magicBox.searchfield.searchTextField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
	footprint.searchfield.searchTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0];
}

-(void)saveData
{
	//Save data 
	[magicBox saveData];
}

-(void)loadData
{
	//Load various data
	[magicBox loadData];
}

- (void)dealloc {
	[magicBox release];
	[equationCalc release];
    [super dealloc];
}

@synthesize delegate;

@end
