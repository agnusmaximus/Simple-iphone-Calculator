//
//  ButtomMorphs.m
//  SimpleCalculator
//
//  Created by Max Lam on 5/20/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "Buttonmorphs.h"


@implementation ButtonMorphs

-(id)init
{
	[super init];
	return self;
}

-(void)morphAll:(BOOL)state
{
	//Morph all the buttons that change
	if (state == YES) {
		//Morph
		cubeAndrt.tag = CUBERT;
		[cubeAndrt setTitle:@"∛x" forState:UIControlStateNormal];
		
		log2And2exp.tag = TWOEXP;
		[log2And2exp setTitle:@"2ˣ" forState:UIControlStateNormal];
		
		sinAndInv.tag = SININV;
		[sinAndInv setTitle: @"sin⁻¹" forState:UIControlStateNormal];
		
		cosAndInv.tag = COSINV;
		[cosAndInv setTitle: @"cos⁻¹"forState:UIControlStateNormal];
		
		tanAndInv.tag = TANINV;
		[tanAndInv setTitle: @"tan⁻¹"forState:UIControlStateNormal];
		
		eAndScieE.tag = SCIE;
		[eAndScieE setTitle:@"sciE" forState:UIControlStateNormal];
		
		percAndRadDeg.tag = DEGTORAD;
		[percAndRadDeg setTitle:@"Rad/Deg" forState:UIControlStateNormal];
		[percAndRadDeg.titleLabel setAdjustsFontSizeToFitWidth:YES]; 
		
		[sqrandrt setTitle:@"√" forState:UIControlStateNormal];
		sqrandrt.tag = SQRRT;
		
		inverseAndSum.tag = SUM_FUNC;
		[inverseAndSum setTitle:@"Sum" forState:UIControlStateNormal];
		[inverseAndSum.titleLabel setAdjustsFontSizeToFitWidth:YES];
		
		[morphButton setImage:[UIImage imageNamed:@"arrow4.png"] forState:UIControlStateNormal];
	}
	else {
		cubeAndrt.tag = CUBE;
		[cubeAndrt setTitle: @"x³" forState:UIControlStateNormal];
		
		log2And2exp.tag = LOG2;
		[log2And2exp setTitle: @"log₂" forState:UIControlStateNormal];
		
		sinAndInv.tag = SIN;
		[sinAndInv setTitle: @"sin" forState:UIControlStateNormal];
		
		cosAndInv.tag = COS;
		[cosAndInv setTitle: @"cos" forState:UIControlStateNormal];
		
		tanAndInv.tag = TAN;
		[tanAndInv setTitle: @"tan"forState:UIControlStateNormal];
		
		eAndScieE.tag = E;
		[eAndScieE setTitle:@"e" forState:UIControlStateNormal];
	
		percAndRadDeg.tag = PERC;
		[percAndRadDeg setTitle:@"%" forState:UIControlStateNormal];
		[percAndRadDeg.titleLabel setAdjustsFontSizeToFitWidth:YES]; 
		
		[sqrandrt setTitle:@"x²" forState:UIControlStateNormal];
		sqrandrt.tag = SQR;
		
		inverseAndSum.tag = INV;
		[inverseAndSum setTitle:@"1/x" forState:UIControlStateNormal];
		[inverseAndSum.titleLabel setAdjustsFontSizeToFitWidth:YES];
		
		[morphButton setImage:[UIImage imageNamed:@"arrow3.png"] forState:UIControlStateNormal];
	}
}

-(void)dealloc
{
	[super dealloc];
}

@end
