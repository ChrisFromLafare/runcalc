//
//  SimpleHRateFromAgeViewController.h
//  RunCalc
//
//  Created by mishanet on 18/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRateCellView.h"
#import "NumericKeyboardView.h"

@interface KarvonenHRateFromAgeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITextField *tfAge;
    UISegmentedControl *scSex;
    UITextField *tfRestRate;
    UITableView *tvRates;
    UITableViewCell *tcHRRate;
    NSArray *rates;
    NumericKeyboardView *viNumericKeyboard;
}

@property (nonatomic, retain) IBOutlet UITextField *tfAge;
@property (nonatomic, retain) IBOutlet UISegmentedControl *scSex;
@property (nonatomic, retain) IBOutlet UITextField *tfRestRate;
@property (nonatomic, retain) IBOutlet UITableView *tvRates;
@property (nonatomic, retain) IBOutlet UITableViewCell *tcHRate;
@property (nonatomic, retain) NSArray *rates;
@property (nonatomic, retain) NumericKeyboardView *viNumericKeyboard;

- (IBAction)beginEditing:(id)sender;
- (IBAction)calcFrequencies:(id)sender;
- (IBAction)backgroundTouched:(id)sender;


@end
