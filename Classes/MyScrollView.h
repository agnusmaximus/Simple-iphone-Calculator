//
//  MyScrollView.h
//  SimpleCalculator
//
//  Created by Max Lam on 6/4/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MyEditableButton.h"

@interface MyScrollView : UIScrollView <UIScrollViewDelegate> {
	BOOL resultedFromDec;
	IBOutlet id otherDelegate;
}

@end
