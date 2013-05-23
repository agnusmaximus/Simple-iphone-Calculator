//
//  EquationConnect.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/7/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEDScreen.h"
#import "Macros.h"
#import "EquationBrain.h"
#import "ButtonMorphs.h"
#import "CalcState.h"
#import "Sound.h"
#import "FootPrints.h"

@interface EquationConnect : NSObject {
	LEDScreen *ledscreen;
	EquationBrain *brain;
	
	Sound *effects;
	
	id delegate;
	
	FootPrints *footprints;
}

-(id)initWithLEDScreen:(LEDScreen *)screen;
-(void)receive:(id)sender;

@property (nonatomic ,retain) id delegate;
@property (nonatomic, retain) FootPrints * footprints;

-(void)morphButtons;

@end
