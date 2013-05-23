//
//  MyPatternBrush.m
//  DrawLines
//
//  Created by Reetu Raj on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyPatternBrush.h"
#import "FootPrints.h"

@implementation MyPatternBrush

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor=[UIColor whiteColor];
        myPath=[[UIBezierPath alloc]init];
        myPath.lineWidth=3;
        brushPattern=[[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:.6];

    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [brushPattern setStroke];
    [myPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    
    // Drawing code
    //[myPath stroke];
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [myPath moveToPoint:[mytouch locationInView:self]];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [myPath addLineToPoint:[mytouch locationInView:self]];
   
    [self setNeedsDisplay];
    
    //The bounding box
	CGRect boundingBox = CGPathGetPathBoundingBox(myPath.CGPath);
	
	//boundingBox = [self convertRect:boundingBox toView:self.superview];
	
	//First check with bounding box if any buttons are being selected
	for (MyButton *button in inputArray) {
		CGRect bframe;
		bframe = [button.superview convertRect:button.frame toView:button.superview.superview];
		
		if (CGRectContainsRect(boundingBox, bframe) || CGRectIntersectsRect(boundingBox, bframe)) {
			[button setButtonSelected:YES];
		}	
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([delegate respondsToSelector:@selector(toggleSelectMode:)]) {
		[delegate toggleSelectMode:nil];
	}
	
	[myPath removeAllPoints];
	[self setNeedsDisplay];
}

- (void)dealloc
{
    [brushPattern release];
    [super dealloc];
}

@synthesize delegate;
@synthesize inputArray;

@end
