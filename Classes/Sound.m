//
//  Sound.m
//  SimpleCalculator
//
//  Created by Max Lam on 5/19/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import "Sound.h"


@implementation Sound

-(id)init
{
	[super init];
	return self;
}

-(void)click
{	
	//declare a system sound id
	SystemSoundID soundID;
	
	CFURLRef soundFileURLRef = CFBundleCopyResourceURL(CFBundleGetBundleWithIdentifier(CFSTR("com.apple.UIKit")),
													   CFSTR("Tock"), CFSTR("aiff"), NULL);
	
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
	
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
	CFRelease(soundFileURLRef);
}

-(void)error
{
	SystemSoundID soundID;
	
	CFURLRef soundFileURLRef = CFBundleCopyResourceURL(CFBundleGetBundleWithIdentifier(CFSTR("com.apple.UIKit")),
													   CFSTR("Tink"), CFSTR("aiff"), NULL);
	
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
	
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
	CFRelease(soundFileURLRef);
}

-(void)dealloc
{
	[super dealloc];
}

@end
