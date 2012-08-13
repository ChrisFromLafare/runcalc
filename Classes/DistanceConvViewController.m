//
//  ConvViewController.m
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DistanceConvViewController.h"
#import "RCDistance.h"

@interface DistanceConvViewController ()

@end

@implementation DistanceConvViewController

@synthesize tfKm, tfMiles;
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
    viNumericKeyboard.nbDigits=3;
    viNumericKeyboard.nbFrac=2;
    self.tfKm.inputView = self.viNumericKeyboard;
    self.tfMiles.inputView = self.viNumericKeyboard;   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tfKm = nil;
    self.tfMiles = nil;
    self.viNumericKeyboard = nil;
}

-(void)dealloc {
    [self viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)editingBegin:(id)sender {
    viNumericKeyboard.delegate = sender;
//    if (sender == tfKm) {
//        viNumericKeyboard.nbDigits = 3;
//    }
//    else {
//        viNumericKeyboard.nbDigits = 3;
//    }
//    [viNumericKeyboard.picker reloadAllComponents];
    [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
}

- (void)convert:(id)sender {
    RCDistance *distance = [[RCDistance alloc] initWithString:((UITextField *)sender).text];
    if (sender == tfKm) {
        RCDistance *distanceMi = [distance toMiles];
        tfMiles.text = [distanceMi stringValue];
    }
    else {
        RCDistance *distanceKm = [distance toKm];
        tfKm.text = [distanceKm stringValue];
    }
}

- (IBAction)backgroundTouched:(id)sender {
    [tfKm resignFirstResponder];
    [tfMiles resignFirstResponder];
}


@end
