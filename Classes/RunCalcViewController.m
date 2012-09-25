//
//  FirstViewController.m
//  RunCalc
//
//  Created by Snow Leopard User on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RunCalcViewController.h"
#import "RunCalcModel.h"

#import "math.h"
#define BUTTON_SHADOW_LENGTH 178 // LONGUEUR de l'ombre dégradée a gauche et a droite du bouton

@implementation RunCalcViewController

@synthesize runCalcModel;
@synthesize tfSpeed, tfDistance, tfDuration, tfPace;
@synthesize scUnit;
@synthesize lblHalfMarathon, lblMarathon, lblDistanceUnit, lblPaceUnit, lblSpeedUnit;
@synthesize lblDistanceUnit1, lblPaceUnit1, lblSpeedUnit1;
@synthesize viDurationKeyboard, viNumericKeyboard, viKeyboardAccessory;
@synthesize ivButtonSpeed, ivButtonDistance, ivButtonDuration;
@synthesize pgrSpeed, pgrDistance, pgrDuration;

enum RCParameter {SPEED=1, DURATION=2, DISTANCE=3} calcVar;



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        // Custom initialization
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Create Background  
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RunCalc-Bg1.png"]];
    // Load images for buttons
    self.ivButtonDistance.image = [UIImage imageNamed:@"RunCalc-ButtonWithShadows.png"];
    self.ivButtonSpeed.image =   [UIImage imageNamed:@"RunCalc-ButtonWithShadows-2.png"];
    self.ivButtonDuration.image = [UIImage imageNamed:@"RunCalc-ButtonWithShadows.png"];
    // Init Model
    RCSpeed *rs = [[RCSpeed alloc] initWithSpeed: 0];
    RCDistance *rd = [[RCDistance alloc] initWithDistance:1.0];
    runCalcModel = [[RunCalcModel alloc] initWithDistance:rd andSpeed:rs];
    runCalcModel.unit = UNIT_KM;
    tfSpeed.text = [runCalcModel.speed stringValue];
    tfDistance.text = [runCalcModel.distance stringValue];
    tfDuration.text = [runCalcModel.duration stringValue];
    tfPace.text = [runCalcModel.speed stringValueForPace];
    // Charger les claviers
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NumericKeyboardView" owner:self options:nil];
    self.viNumericKeyboard = (NumericKeyboardView *)[views objectAtIndex:0];
    viNumericKeyboard.leadingZeros = YES;
    viNumericKeyboard.nbDigits=3;
    viNumericKeyboard.nbFrac=2;
    self.tfDistance.inputView = self.viNumericKeyboard;
    self.tfSpeed.inputView = self.viNumericKeyboard;
    views = [[NSBundle mainBundle] loadNibNamed:@"DurationKeyboardView" owner:self options:nil];
    self.viDurationKeyboard = (DurationKeyboardView *)[views objectAtIndex:0];
    self.tfDuration.inputView = viDurationKeyboard;
    self.tfPace.inputView = viDurationKeyboard;
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
    self.viKeyboardAccessory = (KeyboardAccessoryView *)[views objectAtIndex:0];
    self.tfPace.inputAccessoryView = viKeyboardAccessory;
    self.tfDuration.inputAccessoryView = viKeyboardAccessory;
    self.tfDistance.inputAccessoryView = viKeyboardAccessory;
    self.tfSpeed.inputAccessoryView = viKeyboardAccessory;
    [self lockVariable: DISTANCE];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.tfSpeed = nil;
	self.tfDistance = nil;
	self.tfDuration = nil;
    self.runCalcModel = nil;
    self.tfPace = nil;
    self.scUnit = nil;
    self.lblMarathon = nil;
    self.lblHalfMarathon = nil;
    self.lblDistanceUnit = nil;
    self.lblPaceUnit = nil;
    self.lblSpeedUnit = nil;
    self.lblDistanceUnit1 = nil;
    self.lblPaceUnit1 = nil;
    self.lblSpeedUnit1 = nil;
}


- (void)dealloc {
    [self viewDidUnload];
}

- (void) updateRuns {
    lblMarathon.text = [runCalcModel getMarathonDuration].stringValue;
    lblHalfMarathon.text = [runCalcModel getHalfMarathonDuration].stringValue;
}

- (void) speedChanged {	
	// Get speed 
    RCSpeed *rs = [[RCSpeed alloc] initWithString: tfSpeed.text];
    if (calcVar == DURATION) {
        RCDistance *rd = [[RCDistance alloc] initWithString: tfDistance.text];
        runCalcModel = [[RunCalcModel alloc] initWithDistance: rd andSpeed: rs];
        tfDuration.text = [runCalcModel.duration stringValue];
    }
    else {
        RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:tfDuration.text];
        runCalcModel = [[RunCalcModel alloc] initWithSpeed:rs andDuration:rt];
        tfDistance.text = [runCalcModel.distance stringValue];
    }
    tfPace.text = [rs stringValueForPace];
    [self updateRuns];
}

- (void) paceChanged {	
	// Get speed (as pace)
    RCSpeed *rs = [[RCSpeed alloc] initWithPaceString: tfPace.text];
    if (calcVar) {
        RCDistance *rd = [[RCDistance alloc] initWithString: tfDistance.text];
        runCalcModel = [[RunCalcModel alloc] initWithDistance: rd andSpeed: rs];
        tfDuration.text = [runCalcModel.duration stringValue];
    }
    else {
        RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:tfDuration.text];
        runCalcModel = [[RunCalcModel alloc] initWithSpeed:rs andDuration:rt];
        tfDistance.text = [runCalcModel.distance stringValue];
    }
    tfSpeed.text = [rs stringValue];
    tfDuration.text = [runCalcModel.duration stringValue];
    [self updateRuns];
}

- (void) distanceChanged {
	// Get distance
    RCDistance *rd = [[RCDistance alloc] initWithString:tfDistance.text];
    if (calcVar == DURATION) {
        RCSpeed *rs = [[RCSpeed alloc] initWithString: tfSpeed.text];
        runCalcModel = [[RunCalcModel alloc] initWithDistance:rd andSpeed:rs];
        tfDuration.text = [runCalcModel.duration stringValue];
    }
    else {
        RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:tfDuration.text];
        runCalcModel = [[RunCalcModel alloc] initWithDuration:rt andDistance:rd];
        tfSpeed.text = [runCalcModel.speed stringValue];
        tfPace.text = [runCalcModel.speed stringValueForPace];
        [self updateRuns];
    }
}


- (void) durationChanged {
	//Get Duration and speed
    RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:tfDuration.text];
    if (calcVar == DISTANCE) {
        RCSpeed *rs = [[RCSpeed alloc] initWithString: tfSpeed.text];
        runCalcModel = [[RunCalcModel alloc] initWithSpeed:rs andDuration:rt];
        tfDistance.text = [runCalcModel.distance stringValue];
    }
    else {
        RCDistance *rd = [[RCDistance alloc] initWithString:tfDistance  .text];
        runCalcModel = [[RunCalcModel alloc] initWithDuration:rt andDistance:rd];
        tfSpeed.text = [runCalcModel.speed stringValue];
        tfPace.text = [runCalcModel.speed stringValueForPace];
        [self updateRuns];
    }
}

							
- (IBAction) convert: (id)sender {
	if (sender == tfSpeed) {
		[self speedChanged];
	}
    else if (sender == tfPace) {
        [self paceChanged];
    }
	else if (sender == tfDistance) {
		[self distanceChanged];
	}
	else if (sender == tfDuration) {
		[self durationChanged];
	}
	else {
		;
	}
}

- (IBAction)selectUnit:(id)sender  {
    RCSpeed *s = runCalcModel.speed;
    switch ([sender selectedSegmentIndex]) {
        case 0: //Km
            self.lblSpeedUnit.text = @"Km/h";
            self.lblPaceUnit.text = @"mn/Km";
            self.lblDistanceUnit.text = @"Km";
            self.lblSpeedUnit1.text = @"Km/h";
            self.lblPaceUnit1.text = @"mn/Km";
            self.lblDistanceUnit1.text = @"Km";
            runCalcModel.unit = UNIT_KM;
            if (runCalcModel.distance.status == DISTANCE_VALID)
                runCalcModel.distance.value = runCalcModel.distance.value * MILE_TO_KM;
            if (s.status == SPEED_VALID) {
                runCalcModel.speed.value = runCalcModel.speed.value * MILE_TO_KM;
            }
            break; 
        case 1: //Mi
            self.lblSpeedUnit.text = @"Mi/h";
            self.lblPaceUnit.text = @"mn/Mi";
            self.lblDistanceUnit.text = @"Mi";
            self.lblSpeedUnit1.text = @"Mi/h";
            self.lblPaceUnit1.text = @"mn/Mi";
            self.lblDistanceUnit1.text = @"Mi";
            runCalcModel.unit = UNIT_MI;
            s = runCalcModel.speed;
            if (runCalcModel.distance.status == DISTANCE_VALID)
                runCalcModel.distance.value = runCalcModel.distance.value / MILE_TO_KM;
            if (s.status == SPEED_VALID) {
                runCalcModel.speed.value = runCalcModel.speed.value / MILE_TO_KM;
            }
            break; 
        default:
            break;
    }
    tfSpeed.text = [runCalcModel.speed stringValue];
    tfPace.text = [runCalcModel.speed stringValueForPace];
    tfDistance.text = [runCalcModel.distance stringValue];
}
	
- (IBAction)backgroundTouched:(id)sender {
    [tfDistance resignFirstResponder];
    [tfDuration resignFirstResponder];
    [tfPace resignFirstResponder];
    [tfSpeed resignFirstResponder];
}

-(IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    __block CGPoint translation, translation1;
    enum RCParameter oldCalcVar = calcVar;
    if (recognizer.state == UIGestureRecognizerStateEnded) { 
        if (recognizer.view.center.x > 160) {
            translation = CGPointMake(320 - (recognizer.view.frame.size.width/2 - BUTTON_SHADOW_LENGTH) - 20,
                                      recognizer.view.center.y);
            translation1 = CGPointMake(20 + [self.view viewWithTag:calcVar].frame.size.width/2 - BUTTON_SHADOW_LENGTH, 
                                      [self.view viewWithTag:calcVar].center.y);
            // the tag in view equal 1 for speed, 2 for duration, 3 for distance according to ENUM RCParameter
            [self lockVariable: recognizer.view.tag];
        }
        else {
            translation = CGPointMake(20 + recognizer.view.frame.size.width/2 - BUTTON_SHADOW_LENGTH, 
                                      recognizer.view.center.y);
            translation1 = CGPointMake(320 - ([self.view viewWithTag:calcVar].frame.size.width/2 - BUTTON_SHADOW_LENGTH) - 20,
                                      [self.view viewWithTag:calcVar].center.y);
        } 
        [UIView animateWithDuration:0.2 delay:0 
                    options:UIViewAnimationOptionCurveEaseOut 
                    animations:^{
                        recognizer.view.center = translation;
                        [self.view viewWithTag:oldCalcVar].center = translation1;
                    } 
                    completion:nil];
    }
    else {
        CGPoint min = CGPointMake(20 + recognizer.view.frame.size.width/2 - BUTTON_SHADOW_LENGTH, 
                                  recognizer.view.center.y);
        CGPoint max = CGPointMake(320 - (recognizer.view.frame.size.width/2 - BUTTON_SHADOW_LENGTH) - 20,
                                  recognizer.view.center.y);
        translation = recognizer.view.center;
        translation.x += [recognizer translationInView:self.view].x;
        if (translation.x > max.x)
            translation.x = max.x;
        else if (translation.x < min.x)
            translation.x = min.x;
        recognizer.view.center = translation;
        translation = [self.view viewWithTag:calcVar].center;
        translation.x -= [recognizer translationInView:self.view].x;
        if (translation.x > max.x)
            translation.x = max.x;
        else if (translation.x < min.x)
            translation.x = min.x;
        [self.view viewWithTag:calcVar].center = translation;
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

- (void) lockVariable:(enum RCParameter)sender {
//    UIColor *color = [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:0.0];
    if (sender == SPEED) {
        calcVar = SPEED;
        tfSpeed.enabled = NO;
        tfPace.enabled = NO;
        pgrSpeed.enabled = NO;
        
//        tfSpeed.backgroundColor = color;
//        tfPace.backgroundColor = color;
    }
    else {
//        bSpeedLocked.selected = NO;
        tfSpeed.enabled = YES;
        tfPace.enabled = YES;
        pgrSpeed.enabled = YES;
//        tfSpeed.backgroundColor = nil;
//        tfPace.backgroundColor = nil;
    }    
    if (sender == DISTANCE) {
        calcVar = DISTANCE;
        tfDistance.enabled = NO;
        pgrDistance.enabled = NO;
//        tfDistance.backgroundColor = color;
    }
    else {
        tfDistance.enabled = YES;
        pgrDistance.enabled = YES;
//        tfDistance.backgroundColor = nil;
    }
    if (sender == DURATION) {
        calcVar = DURATION;
        tfDuration.enabled = NO;
        pgrDuration.enabled = NO;
//        tfDuration.backgroundColor = color;
    }
    else {
        tfDuration.enabled = YES;
        pgrDuration.enabled = YES;
//        tfDuration.backgroundColor = nil;
    }
}

- (BOOL)adjustSpeed:(NSString **)aString {
	NSScanner *scan = [NSScanner localizedScannerWithString: *aString];
	float f;
	if ([scan scanFloat:&f]) {
		f = f * 10;
		if (f >= 100.0) {
			f -= 100.0 * floorf(f/100);
		}
		NSString *newVal = [NSString localizedStringWithFormat:@"%05.2f", f];
		*aString = newVal;
		return YES;
	}
	return NO;
}

- (BOOL)adjustDistance:(NSString **)aString {
	NSScanner *scan = [NSScanner localizedScannerWithString: *aString];
	float f;
	if ([scan scanFloat:&f]) {
		f = f * 10;
		if (f >= 1000.0) {
			f -= 1000.0 * floorf(f/1000);
		}
		NSString *newVal = [NSString localizedStringWithFormat:@"%06.2f", f];
		*aString = newVal;
		return YES;
	}
	return NO;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {					
//	NSString *resultingString;
//	if (textField == tfSpeed) {
//        // DEL
//        if ((string.length == 0) && (range.location == textField.text.length - 1)) {
//            if (([textField.text characterAtIndex:0] != '#') && ([textField.text characterAtIndex:0] != '-')) {
//                resultingString = [NSString stringWithFormat:@"0%c%c%c%c", 
//                               [textField.text characterAtIndex:0],
//                               [textField.text characterAtIndex:2],
//                               [textField.text characterAtIndex:1],
//                               [textField.text characterAtIndex:3]];
//                textField.text = resultingString;
//            }
//            
//       }
//		// the input text must be 1 character long and at the end of the string
//		if ((string.length == 1) && (range.location == textField.text.length)) { 
//            if (([textField.text characterAtIndex:0] != '#') && ([textField.text characterAtIndex:0] != '-')) {
//                resultingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//                if ([self adjustSpeed:&resultingString]) {
//                    textField.text = resultingString;
//                }
//            }
//            else {
//                textField.text = [NSString localizedStringWithFormat:@"%05.2f", [string floatValue]/100];
//            }
//		}
//		return NO;
//	}
//	if (textField == tfDistance) {
//        // DEL
//        if ((string.length == 0) && (range.location == textField.text.length - 1)) {
//            if (([textField.text characterAtIndex:0] != '#') && ([textField.text characterAtIndex:0] != '-')) {
//                resultingString = [NSString stringWithFormat:@"0%c%c%c%c%c", 
//                                   [textField.text characterAtIndex:0],
//                                   [textField.text characterAtIndex:1],
//                                   [textField.text characterAtIndex:3],
//                                   [textField.text characterAtIndex:2],
//                                   [textField.text characterAtIndex:4]];
//                textField.text = resultingString;
//            }
//            
//        }
//		// the input text must be 1 character long and at the end of the string
//		if ((string.length == 1) && (range.location == textField.text.length)) { 
//            if (([textField.text characterAtIndex:0] != '#') && ([textField.text characterAtIndex:0] != '-')) {
//                resultingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//                if ([self adjustDistance:&resultingString]) {
//                    textField.text = resultingString;
//                }
//            }
//            else {
//                textField.text = [NSString localizedStringWithFormat:@"%06.2f", [string floatValue]/100];
//            }
//		}
//		return NO;
//	}
//    if ((textField == tfDuration) || (textField == tfPace)) {
//        //DEL
//        if ((string.length == 0) && (range.location == textField.text.length - 1)) {
//            if (([textField.text characterAtIndex:0] != '#') && ([textField.text characterAtIndex:0] != '-')) {
//                resultingString = [NSString stringWithFormat:@"0%c:%c%c:%c%c",
//                               [textField.text characterAtIndex:0],
//                               [textField.text characterAtIndex:1],
//                               [textField.text characterAtIndex:3],
//                               [textField.text characterAtIndex:4],
//                               [textField.text characterAtIndex:6]];
//                textField.text = resultingString;
//            }
//        }
//		// the input text must be 1 character long and at the end of the string
//		if ((string.length == 1) && (range.location == textField.text.length)) { 
//            if (([textField.text characterAtIndex:0] != '#') && ([textField.text characterAtIndex:0] != '-')) {
//                resultingString = [NSString stringWithFormat:@"%c%c:%c%c:%c%c",
//                               [textField.text characterAtIndex:1],
//                               [textField.text characterAtIndex:3],
//                               [textField.text characterAtIndex:4],
//                               [textField.text characterAtIndex:6],
//                               [textField.text characterAtIndex:7],
//                               [string characterAtIndex:0]];
//                textField.text = resultingString;
//            }
//            else {
//                textField.text = [NSString stringWithFormat:@"00:00:0%c",
//                                  [string characterAtIndex:0]];
//            }
//        }
//        return NO;
//    }
//	return YES;
//}

//- (BOOL)textFieldShouldClear:(UITextField *)textField {
//	if (textField == tfSpeed) {
//		textField.text = [NSString localizedStringWithFormat:@"%05.2f", @"0"];
//	}
//    else if (textField == tfDistance) {
//		textField.text = [NSString localizedStringWithFormat:@"%06.2f", @"0"];
//    }
//    else {
//        textField.text = @"00:00:00";
//    }
//	return NO;
//}

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    return NO;
//}

- (void)beginEdit:(id)sender {
//    UIColor *color = [[UIColor alloc] initWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    if (sender == tfDistance) {
//        if (viNumericKeyboard.nbDigits != 3) {
            viNumericKeyboard.nbDigits = 3;
//            [viNumericKeyboard.picker reloadAllComponents];
//        }
        viNumericKeyboard.delegate = sender;
        [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
//        tfSpeed.backgroundColor = color;
//        tfPace.backgroundColor = color;
    }
    else if (sender == tfDuration) {
        viDurationKeyboard.delegate = sender;
//        tfDistance.backgroundColor = color;
        [viDurationKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    else if (sender == tfSpeed) {
//        if (viNumericKeyboard.nbDigits != 2) {
            viNumericKeyboard.nbDigits = 2;
//            [viNumericKeyboard.picker reloadAllComponents];
//        }
        viNumericKeyboard.delegate = sender;
        [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
//        tfDuration.backgroundColor = color;
    }
    else { // tfPace
        viDurationKeyboard.delegate = sender;
//        tfDuration.backgroundColor = color;
        [viDurationKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
//    [color release];
    viKeyboardAccessory.activeControl = sender;
}

- (void)endEdit:(id)sender {
//    if (sender == tfDistance) {
//        tfSpeed.backgroundColor = nil;
//        tfPace.backgroundColor = nil;
//    }
//    else if (sender == tfDuration) {
//        tfDistance.backgroundColor = nil;
//    }
//    else {
//        tfDuration.backgroundColor = nil;
//    }
}

@end
