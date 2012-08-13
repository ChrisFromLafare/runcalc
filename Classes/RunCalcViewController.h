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


@interface RunCalcViewController : UIViewController <UITextFieldDelegate> {
    RunCalcModel *runCalcModel;
	UITextField *tfSpeed;
	UITextField *tfDistance;
	UITextField *tfDuration;
    UITextField *tfPace;
    UILabel *lblHalfMarathon;
    UILabel *lblMarathon;
    UILabel *lblSpeedUnit;
    UILabel *lblPaceUnit;
    UILabel *lblDistanceUnit;
    UISegmentedControl *scUnit;
    UIButton *bSpeedLocked;
    UIButton *bDistanceLocked;
    UIButton *bDurationLocked;
    NumericKeyboardView *viNumericKeyboard;
    DurationKeyboardView *viDurationKeyboard;
}

@property (retain, nonatomic) RunCalcModel *runCalcModel;
@property (retain, nonatomic) IBOutlet UITextField *tfSpeed;
@property (retain, nonatomic) IBOutlet UITextField *tfDistance;
@property (retain, nonatomic) IBOutlet UITextField *tfDuration;
@property (retain, nonatomic) IBOutlet UITextField *tfPace;
@property (retain, nonatomic) IBOutlet UILabel *lblHalfMarathon;
@property (retain, nonatomic) IBOutlet UILabel *lblMarathon;
@property (retain, nonatomic) IBOutlet UILabel *lblSpeedUnit;
@property (retain, nonatomic) IBOutlet UILabel *lblPaceUnit;
@property (retain, nonatomic) IBOutlet UILabel *lblDistanceUnit;
@property (retain, nonatomic) IBOutlet UISegmentedControl *scUnit;
@property (retain, nonatomic) IBOutlet UIButton *bSpeedLocked;
@property (retain, nonatomic) IBOutlet UIButton *bDistanceLocked;
@property (retain, nonatomic) IBOutlet UIButton *bDurationLocked;
@property (nonatomic, retain) IBOutlet NumericKeyboardView *viNumericKeyboard;
@property (nonatomic, retain) IBOutlet DurationKeyboardView *viDurationKeyboard;

- (IBAction)convert: (id) sender;
- (IBAction)selectUnit:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)beginEdit:(id)sender;
- (IBAction)endEdit:(id)sender;
- (IBAction)lockVariable:(id)sender;

@end
