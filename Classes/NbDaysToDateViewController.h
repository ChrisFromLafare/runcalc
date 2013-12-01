//
//  NbDaysToDateViewController.h
//  RunCalc
//
//  Created by Christian on 03/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditButton.h"

@interface NbDaysToDateViewController : UIViewController

@property (nonatomic) IBOutlet CAEditButton *bRaceDate;
@property (nonatomic) IBOutlet CAEditButton *bNbWeeksToRace;
@property (nonatomic) IBOutlet CAEditButton *bNbDaysToRace;

- (IBAction)beginEditRaceDate:(id)sender;
- (IBAction)calcDates:(id)sender;
@end
