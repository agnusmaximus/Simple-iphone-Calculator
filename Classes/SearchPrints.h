//
//  SearchPrints.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/4/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	Sublcass of searchnum to search footprints

#import <UIKit/UIKit.h>
#import "SearchNum.h"

@interface SearchPrints : SearchNum {
	NSMutableArray *arrayOfArrays;
	int track;
}

-(void)addArray:(id)sarray;

@end
