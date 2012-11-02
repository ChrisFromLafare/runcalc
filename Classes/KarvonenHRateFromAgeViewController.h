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
#import "CAEditButton.h"

@interface KarvonenHRateFromAgeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic) IBOutlet CAEditButton *bAge;
@property (nonatomic) IBOutlet CAEditButton *bRestRate;
@property (nonatomic) UISegmentedControl *scSex;
@property (nonatomic) IBOutlet UITableView *tvRates;
@property (nonatomic) UITableViewCell *tcHRate;
@property (nonatomic) NSArray *rates;
@property (nonatomic) NumericKeyboardView *viNumericKeyboard;

- (IBAction)beginEditing:(id)sender;
- (IBAction)calcFrequencies:(id)sender;
- (IBAction)backgroundTouched:(id)sender;


@end
