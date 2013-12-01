//
//  StartTrainingPlanDateViewController.m
//  RunCalc
//
//  Created by Christian on 08/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartTrainingPlanDateViewController.h"
#import "DateKeyboardView.h"
#import "NumericKeyboardView.h"
#import "KeyboardAccessoryView.h"
#import "RCDate.h"

@interface StartTrainingPlanDateViewController ()

@property (nonatomic) DateKeyboardView *viDateKeyboard;
@property (nonatomic) NumericKeyboardView *viNumericKeyboard;
@property (nonatomic) NSString *dateFormat;

@end

@implementation StartTrainingPlanDateViewController

@synthesize bRaceDate, bTrainingWeeks, bStartTrainingDate;
@synthesize viDateKeyboard, viNumericKeyboard;
@synthesize dateFormat;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view.
    // load the keyboard
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RunCalc-Bg2.png"]];
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"DateKeyboardView" owner:self options:nil];
    self.viDateKeyboard = (DateKeyboardView *)[views objectAtIndex:0];
    self.bRaceDate.inputView = self.viDateKeyboard;
    viDateKeyboard.delegate1 = bRaceDate;
    views = [[NSBundle mainBundle] loadNibNamed:@"NumericKeyboardView" owner:self options:nil];
    self.viNumericKeyboard = (NumericKeyboardView *)[views objectAtIndex:0];
    self.viNumericKeyboard.nbDigits=2;
    self.viNumericKeyboard.nbFrac = 0;
    self.bTrainingWeeks.inputView = self.viNumericKeyboard;
    viNumericKeyboard.delegate1 = bTrainingWeeks;
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
    self.bRaceDate.inputAccessoryView = (KeyboardAccessoryView *)[views objectAtIndex:0];
    self.bTrainingWeeks.inputAccessoryView = (KeyboardAccessoryView *)[views objectAtIndex:0];
    dateFormat = [NSDateFormatter dateFormatFromTemplate:@"edMMMyyyy" options:0 locale:[NSLocale currentLocale]];
    self.viDateKeyboard.dateFormat = dateFormat;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappeared:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillDisappear: (NSNotification *)aNotification {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat: dateFormat];
    NSDate *startTrainingDate = [df dateFromString:bStartTrainingDate.text];
    if ([startTrainingDate compare:[[NSDate alloc]init]] == NSOrderedAscending) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Too late!!" message:@"You should have started your training earlier" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}
#pragma -
#pragma mark actions

-(void)beginEditRaceDate:(id)sender {
    viDateKeyboard.delegate1 = sender;
    ((KeyboardAccessoryView *)(bRaceDate.inputAccessoryView)).activeControl = sender;
}

-(void)beginEditTrainingWeeks:(id)sender {
    viNumericKeyboard.delegate1 = sender;
    ((KeyboardAccessoryView *)(bRaceDate.inputAccessoryView)).activeControl = sender;
}

-(void)calcTrainingStartDate:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    NSDate *raceDate = [df dateFromString:bRaceDate.text];
    NSInteger nbWeeks = [bTrainingWeeks.text integerValue];
    if (nbWeeks <= 0)
        self.bStartTrainingDate.text = @"--/---/----";
    else {
        NSDate *startTrainingDate = [RCDate dateBySubstractingWeeks:nbWeeks toDate:raceDate];
        self.bStartTrainingDate.text = [df stringFromDate:startTrainingDate];
    }
}
@end
