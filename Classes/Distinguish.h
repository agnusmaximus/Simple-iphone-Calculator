//
//  Distinguish.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/11/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	Distinguish Between equations and variables

#import <UIKit/UIKit.h>


@interface Distinguish : NSObject {

}

-(BOOL)isEquation:(NSString *)string;

@end
