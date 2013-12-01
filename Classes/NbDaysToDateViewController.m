//
//  NbDaysToDateViewController.m
//  RunCalc
//
//  Created by Christian on 03/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NbDaysToDateViewController.h"
#import "DateKeyboardView.h"
#import "KeyboardAccessoryView.h"
#import "RCDate.h"

@interface NbDaysToDateViewController ()

@property (nonatomic) DateKeyboardView *viDateKeyboard;
@property (nonatomic) NSString *dateFormat;

@end

@implementation NbDaysToDateViewController

@synthesize bNbDaysToRace, bNbWeeksToRace, bRaceDate;
@synthesize viDateKeyboard;
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
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
    self.bRaceDate.inputAccessoryView = (KeyboardAccessoryView *)[views objectAtIndex:0];
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

#pragma -
#pragma mark actions

-(void)beginEditRaceDate:(id)sender {
    viDateKeyboard.delegate1 = sender;
    ((KeyboardAccessoryView *)(bRaceDate.inputAccessoryView)).activeControl = sender;
}

-(void)calcDates:(id)sender {
    NSString *s;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    NSDate *raceDate = [df dateFromString:bRaceDate.text];
    NSDate *now = [[NSDate alloc] init];
    NSString *snow = [df stringFromDate:now];
    now = [df dateFromString:snow];
    NSInteger nbWeeks = [RCDate numberOfWeeksToDate:raceDate sinceDate:now];
    if (nbWeeks >= 0)
        s = [[NSString alloc] initWithFormat:@"%3d",nbWeeks];
    else 
        s = @"--/---/----";
    self.bNbWeeksToRace.text = s;
    NSInteger nbDays = [RCDate numberOfDaysToDate:raceDate sinceDate:now];
    if (nbDays >= 0)
        s = [[NSString alloc] initWithFormat:@"%3d",nbDays];
    else
        s = @"--";
    self.bNbDaysToRace.text = s;
}
@end
