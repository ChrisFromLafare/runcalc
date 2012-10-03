//
//  FirstViewController.h
//  RunCalc
//
//  Created by Snow Leopard User on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunCalcModel.h"
#import "NumericKeyboardView.h"
#import "DurationKeyboardView.h"
#import "KeyBoardAccessoryView.h"


@interface RunCalcViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    RunCalcModel *runCalcModel;
    UIScrollView *srollView;
	UITextField *tfSpeed;
	UITextField *tfDistance;
	UITextField *tfDuration;
    UITextField *tfPace;
    UILabel *lblHalfMarathon;
    UILabel *lblMarathon;
    UILabel *lblSpeedUnit;
    UILabel *lblPaceUnit;
    UILabel *lblDistanceUnit;
    UILabel *lblSpeedUnit1;
    UILabel *lblPaceUnit1;
    UILabel *lblDistanceUnit1;
    UISegmentedControl *scUnit;
    UIImageView *ivButtonSpeed;
    UIImageView *ivButtonDistance;
    UIImageView *ivButtonDuration;
    UIGestureRecognizer *pgrSpeed;
    UIGestureRecognizer *pgrDistance;
    UIGestureRecognizer *pgrDuration;
    NumericKeyboardView *viNumericKeyboard;
    DurationKeyboardView *viDurationKeyboard;
    KeyboardAccessoryView *viKeyboardAccessory;
}

@property (nonatomic) RunCalcModel *runCalcModel;
@property (nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) IBOutlet UITextField *tfSpeed;
@property (nonatomic) IBOutlet UITextField *tfDistance;
@property (nonatomic) IBOutlet UITextField *tfDuration;
@property (nonatomic) IBOutlet UITextField *tfPace;
@property (nonatomic) IBOutlet UILabel *lblHalfMarathon;
@property (nonatomic) IBOutlet UILabel *lblMarathon;
@property (nonatomic) IBOutlet UILabel *lblSpeedUnit;
@property (nonatomic) IBOutlet UILabel *lblPaceUnit;
@property (nonatomic) IBOutlet UILabel *lblDistanceUnit;
@property (nonatomic) IBOutlet UILabel *lblSpeedUnit1;
@property (nonatomic) IBOutlet UILabel *lblPaceUnit1;
@property (nonatomic) IBOutlet UILabel *lblDistanceUnit1;
@property (nonatomic) IBOutlet UISegmentedControl *scUnit;
@property (nonatomic) IBOutlet UIImageView *ivButtonSpeed;
@property (nonatomic) IBOutlet UIImageView *ivButtonDistance;
@property (nonatomic) IBOutlet UIImageView *ivButtonDuration;
@property (nonatomic) IBOutlet UIGestureRecognizer *pgrSpeed;
@property (nonatomic) IBOutlet UIGestureRecognizer *pgrDistance;
@property (nonatomic) IBOutlet UIGestureRecognizer *pgrDuration;
@property (nonatomic) NumericKeyboardView *viNumericKeyboard;
@property (nonatomic) DurationKeyboardView *viDurationKeyboard;
@property (nonatomic) KeyboardAccessoryView *viKeyboardAccessory;

- (IBAction)convert: (id) sender;
- (IBAction)selectUnit:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)beginEdit:(id)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

@end
