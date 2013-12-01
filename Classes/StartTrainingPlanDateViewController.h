//
//  StartTrainingPlanDateViewController.h
//  RunCalc
//
//  Created by Christian on 08/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditButton.h"

@interface StartTrainingPlanDateViewController : UIViewController

@property (nonatomic) IBOutlet CAEditButton *bRaceDate;
@property (nonatomic) IBOutlet CAEditButton *bTrainingWeeks;
@property (nonatomic) IBOutlet CAEditButton *bStartTrainingDate;

- (IBAction)beginEditRaceDate:(id)sender;
- (IBAction)beginEditTrainingWeeks:(id)sender;
- (IBAction)calcTrainingStartDate:(id)sender;

@end
