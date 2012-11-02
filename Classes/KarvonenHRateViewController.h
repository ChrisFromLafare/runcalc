//
//  SimpleHRateViewController.h
//  RunCalc
//
//  Created by mishanet on 18/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditButton.h"
#import "HRateCellView.h"
#import "NumericKeyboardView.h"

@interface KarvonenHRateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *tvRates;
    UITableViewCell *tcHRRate;
    CAEditButton *bMaxRate;
    CAEditButton *bRestRate;
    NSArray *rates;
    NumericKeyboardView *viNumericKeyboard;
}

@property (nonatomic) IBOutlet UITableView *tvRates;
@property (nonatomic) IBOutlet UITableViewCell *tcHRate;
@property (nonatomic) IBOutlet CAEditButton *bMaxRate;
@property (nonatomic) IBOutlet CAEditButton *bRestRate;
@property (nonatomic) NSArray *rates;
@property (nonatomic) NumericKeyboardView *viNumericKeyboard;

- (IBAction)beginEditing:(id)sender;
- (IBAction)calcFrequencies:(id)sender;
- (IBAction)backgroundTouched:(id)sender;


@end
