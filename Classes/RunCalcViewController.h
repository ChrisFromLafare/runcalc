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

@property (nonatomic) RunCalcModel *runCalcModel;
@property (nonatomic) IBOutlet UITextField *tfSpeed;
@property (nonatomic) IBOutlet UITextField *tfDistance;
@property (nonatomic) IBOutlet UITextField *tfDuration;
@property (nonatomic) IBOutlet UITextField *tfPace;
@property (nonatomic) IBOutlet UILabel *lblHalfMarathon;
@property (nonatomic) IBOutlet UILabel *lblMarathon;
@property (nonatomic) IBOutlet UILabel *lblSpeedUnit;
@property (nonatomic) IBOutlet UILabel *lblPaceUnit;
@property (nonatomic) IBOutlet UILabel *lblDistanceUnit;
@property (nonatomic) IBOutlet UISegmentedControl *scUnit;
@property (nonatomic) IBOutlet UIButton *bSpeedLocked;
@property (nonatomic) IBOutlet UIButton *bDistanceLocked;
@property (nonatomic) IBOutlet UIButton *bDurationLocked;
@property (nonatomic) IBOutlet NumericKeyboardView *viNumericKeyboard;
@property (nonatomic) IBOutlet DurationKeyboardView *viDurationKeyboard;

- (IBAction)convert: (id) sender;
- (IBAction)selectUnit:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)beginEdit:(id)sender;
- (IBAction)endEdit:(id)sender;
- (IBAction)lockVariable:(id)sender;

@end
