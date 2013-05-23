//
//  Sound.h
//  SimpleCalculator
//
//  Created by Max Lam on 5/19/11.
//  Copyright 2011 Max Lam. All rights reserved.
//
//	This class plays a click sound

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Sound : NSObject {

}

-(void)click;
-(void)error;

@end
