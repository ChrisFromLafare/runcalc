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

@interface SpeedConvViewController : UIViewController {
    UITextField *tfKmH;
    UITextField *tfMiH;
    UITextField *tfMnKm;
    UITextField *tfMnMi;
    NumericKeyboardView *viNumericKeyboard;
    DurationKeyboardView *viDurationKeyboard;
}

@property (nonatomic) IBOutlet UITextField *tfMnKm;
@property (nonatomic) IBOutlet UITextField *tfMnMi;
@property (nonatomic) IBOutlet UITextField *tfKmH;
@property (nonatomic) IBOutlet UITextField *tfMiH;
@property (nonatomic) NumericKeyboardView *viNumericKeyboard;
@property (nonatomic) DurationKeyboardView *viDurationKeyboard;

-(IBAction)editingBegin:(id)sender; 
-(IBAction)convert:(id)sender;
-(IBAction)backgroundTouched:(id)sender;

@end
