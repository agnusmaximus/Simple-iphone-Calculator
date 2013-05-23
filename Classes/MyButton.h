//
//  MyButton.h
//  Calculator2
//
//  Created by Max Lam on 5/18/11.
//  Copyright 2011 Max Lam. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MyButton : UIButton {
	id delegate;
	
	BOOL shouldDisableDuringDrag;
	BOOL buttonSelected;
}

-(void)setShouldDisableDuringDrag:(BOOL)yesOrNo;

@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL buttonSelected;

@end
