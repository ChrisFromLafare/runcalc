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

@interface SpeedConvViewController : UIViewController <UITextFieldDelegate> {
}

@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) IBOutlet CAEditButton *bMnKm;
@property (nonatomic) IBOutlet CAEditButton *bMnMi;
@property (nonatomic) IBOutlet CAEditButton *bKmH;
@property (nonatomic) IBOutlet CAEditButton *bMiH;
@property (nonatomic) NumericKeyboardView *viNumericKeyboard;
@property (nonatomic) DurationKeyboardView *viDurationKeyboard;

-(IBAction)editingBegin:(id)sender; 
-(IBAction)convert:(id)sender;
-(IBAction)backgroundTouched:(id)sender;

@end
