//
//  ConvViewController.m
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyboardAccessoryView.h"
#import "DistanceConvViewController.h"
#import "RCDistance.h"

@interface DistanceConvViewController () {
}

@end

@implementation DistanceConvViewController

@synthesize bKm, bMiles;
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
    ((UIImageView *)self.view).image = [UIImage imageNamed:@"RunCalc-Bg2.png"];
	// Do any additional setup after loading the view.
    // load the keyboard
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NumericKeyboardView" owner:self options:nil];
    self.viNumericKeyboard = (NumericKeyboardView *)[views objectAtIndex:0];
    viNumericKeyboard.leadingZeros = YES;
    viNumericKeyboard.nbDigits=3;
    viNumericKeyboard.nbFrac=2;
    self.bKm.inputView = self.viNumericKeyboard;
    self.bMiles.inputView = self.viNumericKeyboard; 
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
    self.bKm.inputAccessoryView = [views objectAtIndex:0];
    self.bMiles.inputAccessoryView = [views objectAtIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.bKm = nil;
    self.bMiles = nil;
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
    viNumericKeyboard.delegate1 = sender;
    [viNumericKeyboard setKeyboardValue:((CAEditButton *)sender).text];
    KeyboardAccessoryView *kbv = (KeyboardAccessoryView *)((UITextField *)sender).inputAccessoryView;
    kbv.activeControl = sender;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (void)convert:(id)sender {
    RCDistance *distance = [[RCDistance alloc] initWithString:((CAEditButton *)sender).text];
    if (sender == bKm) {
        RCDistance *distanceMi = [distance toMiles];
        [bMiles setTextWithoutValueChangedEvent:[distanceMi stringValue]];
    }
    else {
        RCDistance *distanceKm = [distance toKm];
        [bKm setTextWithoutValueChangedEvent:[distanceKm stringValue]];
    }
}

- (IBAction)backgroundTouched:(id)sender {
    [bKm resignFirstResponder];
    [bMiles resignFirstResponder];
}


@end
