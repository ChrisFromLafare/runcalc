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

@interface RunCalcViewController() 
@property (nonatomic) UIControl *activeControl;
@end

@implementation RunCalcViewController

@synthesize runCalcModel;
@synthesize scrollView;
@synthesize tfSpeed, tfDistance, tfDuration, tfPace;
@synthesize scUnit;
@synthesize lblHalfMarathon, lblMarathon, lblDistanceUnit, lblPaceUnit, lblSpeedUnit;
@synthesize lblDistanceUnit1, lblPaceUnit1, lblSpeedUnit1;
@synthesize viDurationKeyboard, viNumericKeyboard, viKeyboardAccessory;
@synthesize ivButtonSpeed, ivButtonDistance, ivButtonDuration;
@synthesize pgrSpeed, pgrDistance, pgrDuration;
@synthesize activeControl; // Contain the active control, used the define if scrolling is required
                            // to have the active control visible (not hidden by the keyboard)

enum RCParameter {SPEED=1, DURATION=2, DISTANCE=3} calcVar;



#pragma mark - View Management

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
    // Init scrollview
    self.scrollView.contentSize = self.scrollView.frame.size;
    // Init Model
    RCSpeed *rs = [[RCSpeed alloc] initWithSpeed: 0];
    RCDistance *rd = [[RCDistance alloc] initWithDistance:1.0];
    runCalcModel = [[RunCalcModel alloc] initWithDistance:rd andSpeed:rs];
    runCalcModel.unit = UNIT_KM;
    tfSpeed.text = [runCalcModel.speed stringValue];
    tfDistance.text = [runCalcModel.distance stringValue];
    tfDuration.text = [runCalcModel.duration stringValue];
    tfPace.text = [runCalcModel.speed stringValueForPace];
    // load specific keyboards & accessory 
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
    // lock the distance
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

-(void) viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappeared:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard management
- (void) keyboardWasShown: (NSNotification *)aNotification {
    // Get the keyboard height
    // ISC: in Screen Coordinate, IWC in Window coordinate, IVC in View coordinate
    CGRect keyboardEndFrameISC;
    [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameISC];
    CGRect keyboardEndFrameIWC = [self.scrollView.window convertRect:keyboardEndFrameISC fromWindow:nil];
    CGRect keyboardEndFrameIVC = [self.view convertRect:keyboardEndFrameIWC fromView:nil];
    // Compute the height covered by the keyboard (difference between the bottom of the view and the top of the keyboard
    CGFloat heightCoveredByKeyboard = self.view.frame.size.height - keyboardEndFrameIVC.origin.y;    
    // Set the scrollview insets accordingly
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, heightCoveredByKeyboard, 0);
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;
    // Get the activeControl's bottom left corner coordinates 
    CGRect activeControlFrameIVC = [self.view convertRect:activeControl.frame fromView:activeControl.superview];
    CGPoint baseControl = activeControlFrameIVC.origin;
    baseControl.y += activeControlFrameIVC.size.height;
    // if the activeControl's bottom corner is hidden by the keyboard scroll up to make it visible
    if (CGRectContainsPoint(keyboardEndFrameIVC, baseControl)) {
        CGPoint scrollPoint = CGPointMake(0.0, baseControl.y - keyboardEndFrameIVC.origin.y);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Reset the scrollview insets
-(void) keyboardWillDisappear: (NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;    
}

#pragma mark - UIComponents update
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


#pragma mark - IBAction methods
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

- (IBAction)beginEdit:(id)sender {
    activeControl = sender;
    if (sender == tfDistance) {
        viNumericKeyboard.nbDigits = 3;
        viNumericKeyboard.delegate = sender;
        [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    else if (sender == tfDuration) {
        viDurationKeyboard.delegate = sender;
        [viDurationKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    else if (sender == tfSpeed) {
            viNumericKeyboard.nbDigits = 2;
        viNumericKeyboard.delegate = sender;
        [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    else { // tfPace
        viDurationKeyboard.delegate = sender;
        [viDurationKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    viKeyboardAccessory.activeControl = sender;
}

#pragma mark - Gesture recognizer delegate implementation
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Helper functions
- (void) lockVariable:(enum RCParameter)sender {
    UIColor *colorOrange = [[UIColor alloc] initWithRed:238.0/255.0 green:177.0/255.0 blue:56.0/255.0 alpha:1.0];
    UIColor *colorGreen = [[UIColor alloc] initWithRed:94.0/255.0 green:217.0/255.0 blue:78.0/255.0 alpha:1.0];
    if (sender == SPEED) {
        calcVar = SPEED;
        tfSpeed.enabled = NO;
        tfPace.enabled = NO;
        pgrSpeed.enabled = NO;
        tfSpeed.textColor = colorOrange;
        tfPace.textColor = colorOrange;
    }
    else {
        tfSpeed.enabled = YES;
        tfPace.enabled = YES;
        pgrSpeed.enabled = YES;
        tfSpeed.textColor = colorGreen;
        tfPace.textColor = colorGreen;
    }    
    if (sender == DISTANCE) {
        calcVar = DISTANCE;
        tfDistance.enabled = NO;
        pgrDistance.enabled = NO;
        tfDistance.textColor = colorOrange;
    }
    else {
        tfDistance.enabled = YES;
        pgrDistance.enabled = YES;
        tfDistance.textColor = colorGreen;
    }
    if (sender == DURATION) {
        calcVar = DURATION;
        tfDuration.enabled = NO;
        pgrDuration.enabled = NO;
        tfDuration.textColor = colorOrange;
    }
    else {
        tfDuration.enabled = YES;
        pgrDuration.enabled = YES;
        tfDuration.textColor = colorGreen;
    }
}

@end
