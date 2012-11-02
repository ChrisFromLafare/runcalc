//
//  ConvViewController.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditButton.h"
#import "NumericKeyboardView.h"
#import "DurationKeyboardView.h"

@interface DistanceConvViewController : UIViewController <UITextFieldDelegate> {
}

@property (nonatomic) IBOutlet CAEditButton *bKm;
@property (nonatomic) IBOutlet CAEditButton *bMiles;
@property (nonatomic) IBOutlet NumericKeyboardView *viNumericKeyboard;
@property (nonatomic) IBOutlet DurationKeyboardView *viDurationKeyboard;

-(IBAction)editingBegin:(id)sender; 
-(IBAction)convert:(id)sender;
-(IBAction)backgroundTouched:(id)sender;

@end
