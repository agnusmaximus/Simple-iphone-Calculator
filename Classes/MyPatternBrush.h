//
//  MyPatternBrush.h
//  DrawLines
//
//  Created by Reetu Raj on 17/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import <QuartzCore/QuartzCore.h>
@class FootPrints;

@interface MyPatternBrush : UIView {
    UIColor *brushPattern;
    UIBezierPath *myPath;
		
	id delegate;
	
	NSMutableArray *inputArray;	//Search this array when selecting buttons
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableArray * inputArray;

@end
