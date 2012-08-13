//
//  ConvViewController.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumericKeyboardView.h"
#import "DurationKeyboardView.h"

@interface DistanceConvViewController : UIViewController {
    UITextField *tfKm;
    UITextField *tfMiles;
    NumericKeyboardView *viNumericKeyboard;
    DurationKeyboardView *viDurationKeyboard;
}

@property (nonatomic) IBOutlet UITextField *tfKm;
@property (nonatomic) IBOutlet UITextField *tfMiles;
@property (nonatomic) IBOutlet NumericKeyboardView *viNumericKeyboard;
@property (nonatomic) IBOutlet DurationKeyboardView *viDurationKeyboard;

-(IBAction)editingBegin:(id)sender; 
-(IBAction)convert:(id)sender;
-(IBAction)backgroundTouched:(id)sender;

@end
