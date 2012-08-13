//
//  ConvViewController.m
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeedConvViewController.h"
#import "RCTimeInterval.h"
#import "RCSpeed.h"


@interface SpeedConvViewController ()

@end

@implementation SpeedConvViewController

@synthesize tfKmH, tfMiH, tfMnKm, tfMnMi;
@synthesize viNumericKeyboard, viDurationKeyboard;

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
	// Do any additional setup after loading the view.
    // load the keyboard
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NumericKeyboardView" owner:self options:nil];
    self.viNumericKeyboard = (NumericKeyboardView *)[views objectAtIndex:0];
    viNumericKeyboard.leadingZeros = YES;
    viNumericKeyboard.nbDigits=2;
    viNumericKeyboard.nbFrac=2;
    self.tfKmH.inputView = self.viNumericKeyboard;
    self.tfMiH.inputView = self.viNumericKeyboard; 
    views = [[NSBundle mainBundle] loadNibNamed:@"DurationKeyboardView" owner:self options:nil];
    self.viDurationKeyboard = (DurationKeyboardView *)[views objectAtIndex:0];
    self.tfMnKm.inputView = self.viDurationKeyboard;
    self.tfMnMi.inputView = self.viDurationKeyboard;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tfKmH = nil;
    self.tfMiH = nil;
    self.tfMnKm = nil;
    self.tfMnMi = nil;
    self.viNumericKeyboard = nil;
}

-(void)dealloc {
    [self viewDidUnload];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)editingBegin:(id)sender {
    if ((sender == tfKmH) || (sender == tfMiH)) {
        viNumericKeyboard.delegate = sender;
        [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    else if ((sender == tfMnKm) || (sender == tfMnMi)) {
        viDurationKeyboard.delegate = sender;
        [viDurationKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
}

- (void)convert:(id)sender {
    RCSpeed *speed;
    if ((sender == tfMiH) || (sender == tfKmH)) {
        speed = [[RCSpeed alloc] initWithString:((UITextField *)sender).text];
    }
    else if ((sender == tfMnKm) || (sender == tfMnMi)) {
        speed = [[RCSpeed alloc] initWithPaceString:((UITextField *)sender).text];        
    }
    if (sender == tfKmH) {
        RCSpeed *speedMi = [speed toMileH];
        tfMnKm.text = [speed stringValueForPace];
        tfMiH.text = [speedMi stringValue];
        tfMnMi.text = [speedMi stringValueForPace];
    }
    else if (sender == tfMiH) {
        RCSpeed *speedKm = [speed toKmH];
        tfMnMi.text = [speed stringValueForPace];
        tfKmH.text = [speedKm stringValue];
        tfMnKm.text = [speedKm stringValueForPace];
    }
    else if (sender == tfMnKm) {
        RCSpeed *speedMi = [speed toMileH];
        tfKmH.text = [speed stringValue];
        tfMiH.text = [speedMi stringValue];
        tfMnMi.text = [speedMi stringValueForPace];
    }
    else if (sender == tfMnMi) {
        RCSpeed *speedKm = [speed toKmH];
        tfMiH.text = [speed stringValue];
        tfKmH.text = [speedKm stringValue];
        tfMnKm.text = [speedKm stringValueForPace];
    }
    [speed release];
}

- (IBAction)backgroundTouched:(id)sender {
    [tfKmH resignFirstResponder];
    [tfMiH resignFirstResponder];
    [tfMnKm resignFirstResponder];
    [tfMnMi resignFirstResponder];
}


@end
