//
//  SimpleCalculatorAppDelegate.h
//  SimpleCalculator
//
//  Created by Max Lam on 5/19/11.
//  Copyright 2011 Max Lam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleCalculatorViewController;

@interface SimpleCalculatorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SimpleCalculatorViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SimpleCalculatorViewController *viewController;

@end

