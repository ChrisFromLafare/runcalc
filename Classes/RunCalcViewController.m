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
@property (nonatomic) BOOL keyboardShown;
@property (nonatomic) CGFloat heightCoveredByKeyboard;
@end

@implementation RunCalcViewController

@synthesize runCalcModel;
@synthesize scrollView;
@synthesize bSpeed, bDistance, bDuration, bPace;
@synthesize scUnit;
@synthesize lblHalfMarathon, lblMarathon, lblDistanceUnit, lblPaceUnit, lblSpeedUnit;
@synthesize lblDistanceUnit1, lblPaceUnit1, lblSpeedUnit1;
@synthesize viDurationKeyboard, viNumericKeyboard, viKeyboardAccessory;
@synthesize ivButtonSpeed, ivButtonDistance, ivButtonDuration;
@synthesize pgrSpeed, pgrDistance, pgrDuration;
@synthesize keyboardShown, heightCoveredByKeyboard;

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
    [bSpeed setTextWithoutValueChangedEvent: [runCalcModel.speed stringValue]];
    [bDistance setTextWithoutValueChangedEvent: [runCalcModel.distance stringValue]];
    [bDuration setTextWithoutValueChangedEvent: [runCalcModel.duration stringValue]];
    bPace.text = [runCalcModel.speed stringValueForPace];
    // load specific keyboards & accessory 
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NumericKeyboardView" owner:self options:nil];
    self.viNumericKeyboard = (NumericKeyboardView *)[views objectAtIndex:0];
    viNumericKeyboard.leadingZeros = YES;
    viNumericKeyboard.nbDigits=3;
    viNumericKeyboard.nbFrac=2;
    self.bDistance.inputView = self.viNumericKeyboard;
    self.bSpeed.inputView = self.viNumericKeyboard;
    views = [[NSBundle mainBundle] loadNibNamed:@"DurationKeyboardView" owner:self options:nil];
    self.viDurationKeyboard = (DurationKeyboardView *)[views objectAtIndex:0];
    self.bDuration.inputView = viDurationKeyboard;
    self.bPace.inputView = viDurationKeyboard;
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];
    self.viKeyboardAccessory = (KeyboardAccessoryView *)[views objectAtIndex:0];
    self.bPace.inputAccessoryView = viKeyboardAccessory;
    self.bDuration.inputAccessoryView = viKeyboardAccessory;
    self.bDistance.inputAccessoryView = viKeyboardAccessory;
    self.bSpeed.inputAccessoryView = viKeyboardAccessory;
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
	self.bSpeed = nil;
	self.bDistance = nil;
	self.bDuration = nil;
    self.runCalcModel = nil;
    self.bPace = nil;
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
    [super viewDidAppear:animated];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappeared:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard management
- (void) keyboardWillShow: (NSNotification *)aNotification {
    keyboardShown = YES;
    // Get the keyboard height
    // ISC: in Screen Coordinate, IWC in Window coordinate, IVC in View coordinate
    CGRect keyboardEndFrameISC;
    [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameISC];
    CGRect keyboardEndFrameIWC = [self.scrollView.window convertRect:keyboardEndFrameISC fromWindow:nil];
    CGRect keyboardSize = [self.view convertRect:keyboardEndFrameIWC fromView:nil];
    self.heightCoveredByKeyboard = self.view.frame.size.height - keyboardSize.origin.y;    
    [self makeTextFieldVisible: aNotification.userInfo];
}

-(void) makeTextFieldVisible: (NSDictionary *)userInfo {
    CGPoint scrollPoint;
    // Set the scrollview insets accordingly to the height covered by the keyboard
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, self.heightCoveredByKeyboard, 0);
    // Get the scroll bottom left corner coordinates
    CGRect svFrameIVC = [self.view convertRect:self.scrollView.frame fromView:self.scrollView.superview];
    // Get the activeControl's bottom left corner coordinates
    CGRect activeControlFrameIVC = [self.view convertRect:self.viKeyboardAccessory.activeControl.frame fromView:self.viKeyboardAccessory.activeControl.superview];
    CGPoint baseControl = activeControlFrameIVC.origin;
    if (baseControl.y < svFrameIVC.origin.y) {
        scrollPoint = CGPointMake(0.0, self.scrollView.contentOffset.y + baseControl.y - svFrameIVC.origin.y);
        [self scrollViewSetInsets:insets andContentOffset:scrollPoint givenUserInfo: userInfo];
    }
    else {
        baseControl.y += activeControlFrameIVC.size.height;
        // if the activeControl's bottom corner is hidden by the keyboard scroll up to make it visible
        if (svFrameIVC.origin.y + svFrameIVC.size.height - self.heightCoveredByKeyboard < baseControl.y) {
            scrollPoint = CGPointMake(0.0, self.scrollView.contentOffset.y + baseControl.y - (svFrameIVC.origin.y + svFrameIVC.size.height - self.heightCoveredByKeyboard));
            [self scrollViewSetInsets:insets andContentOffset:scrollPoint givenUserInfo:userInfo];
        }
        else
            [self scrollViewSetInsets:insets andContentOffset:self.scrollView.contentOffset givenUserInfo:userInfo];
    }
}

// Reset the scrollview insets
-(void) keyboardWillDisappear: (NSNotification *)aNotification {
    keyboardShown = NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [self scrollViewSetInsets:contentInsets andContentOffset: CGPointMake(0.0, 0.0) givenUserInfo:aNotification.userInfo];
}

// Perform scrolling
-(void) scrollViewSetInsets: (UIEdgeInsets)insets andContentOffset: (CGPoint)offset givenUserInfo: (NSDictionary *)userInfo {
    double duration = 0.5;
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseInOut;
    if (userInfo != nil) {
        duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    }
    UIViewAnimationOptions animationOptions = animationCurve;
    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
        self.scrollView.contentInset = insets;
        self.scrollView.scrollIndicatorInsets = insets;    
        self.scrollView.contentOffset = offset;
    } completion: nil];
}

#pragma mark - UIComponents update
- (void) updateRuns {
    lblMarathon.text = [runCalcModel getMarathonDuration].stringValue;
    lblHalfMarathon.text = [runCalcModel getHalfMarathonDuration].stringValue;
}

- (void) speedChanged {	
	// Get speed 
    RCSpeed *rs = [[RCSpeed alloc] initWithString: bSpeed.text];
    if (calcVar == DURATION) {
        RCDistance *rd = [[RCDistance alloc] initWithString: bDistance.text];
        runCalcModel = [[RunCalcModel alloc] initWithDistance: rd andSpeed: rs];
        [bDuration setTextWithoutValueChangedEvent: [runCalcModel.duration stringValue]];
    }
    else {
        RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:bDuration.text];
        runCalcModel = [[RunCalcModel alloc] initWithSpeed:rs andDuration:rt];
        [bDistance setTextWithoutValueChangedEvent: [runCalcModel.distance stringValue]];
    }
    [bPace setTextWithoutValueChangedEvent: [rs stringValueForPace]];
    [self updateRuns];
}

- (void) paceChanged {	
	// Get speed (as pace)
    RCSpeed *rs = [[RCSpeed alloc] initWithPaceString: bPace.text];
    if (calcVar) {
        RCDistance *rd = [[RCDistance alloc] initWithString: bDistance.text];
        runCalcModel = [[RunCalcModel alloc] initWithDistance: rd andSpeed: rs];
        [bDuration setTextWithoutValueChangedEvent: [runCalcModel.duration stringValue]];
    }
    else {
        RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:bDuration.text];
        runCalcModel = [[RunCalcModel alloc] initWithSpeed:rs andDuration:rt];
        [bDistance setTextWithoutValueChangedEvent: [runCalcModel.distance stringValue]];
    }
    [bSpeed setTextWithoutValueChangedEvent: [rs stringValue]];
    [bDuration setTextWithoutValueChangedEvent: [runCalcModel.duration stringValue]];
    [self updateRuns];
}

- (void) distanceChanged {
	// Get distance
    RCDistance *rd = [[RCDistance alloc] initWithString:bDistance.text];
    if (calcVar == DURATION) {
        RCSpeed *rs = [[RCSpeed alloc] initWithString: bSpeed.text];
        runCalcModel = [[RunCalcModel alloc] initWithDistance:rd andSpeed:rs];
        [bDuration setTextWithoutValueChangedEvent: [runCalcModel.duration stringValue]];
    }
    else {
        RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:bDuration.text];
        runCalcModel = [[RunCalcModel alloc] initWithDuration:rt andDistance:rd];
        [bSpeed setTextWithoutValueChangedEvent: [runCalcModel.speed stringValue]];
        [bPace setTextWithoutValueChangedEvent: [runCalcModel.speed stringValueForPace]];
        [self updateRuns];
    }
}


- (void) durationChanged {
	//Get Duration and speed
    RCTimeInterval *rt = [[RCTimeInterval alloc] initWithString:bDuration.text];
    if (calcVar == DISTANCE) {
        RCSpeed *rs = [[RCSpeed alloc] initWithString: bSpeed.text];
        runCalcModel = [[RunCalcModel alloc] initWithSpeed:rs andDuration:rt];
        [bDistance setTextWithoutValueChangedEvent: [runCalcModel.distance stringValue]];
    }
    else {
        RCDistance *rd = [[RCDistance alloc] initWithString: bDistance.text];
        runCalcModel = [[RunCalcModel alloc] initWithDuration:rt andDistance:rd];
        [bSpeed setTextWithoutValueChangedEvent: [runCalcModel.speed stringValue]];
        [bPace setTextWithoutValueChangedEvent: [runCalcModel.speed stringValueForPace]];
        [self updateRuns];
    }
}


#pragma mark - IBAction methods
- (IBAction) convert: (id)sender {
	if (sender == bSpeed) {
		[self speedChanged];
	}
    else if (sender == bPace) {
        [self paceChanged];
    }
	else if (sender == bDistance) {
		[self distanceChanged];
	}
	else if (sender == bDuration) {
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
    [bSpeed setTextWithoutValueChangedEvent: [runCalcModel.speed stringValue]];
    [bPace setTextWithoutValueChangedEvent: [runCalcModel.speed stringValueForPace]];
    [bDistance setTextWithoutValueChangedEvent: [runCalcModel.distance stringValue]];
}
	
- (IBAction)backgroundTouched:(id)sender {
    [bDistance resignFirstResponder];
    [bDuration resignFirstResponder];
    [bPace resignFirstResponder];
    [bSpeed resignFirstResponder];
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
    if (sender == bDistance) {
        viNumericKeyboard.nbDigits = 3;
        viNumericKeyboard.delegate1 = sender;
        viNumericKeyboard.delegate = nil;
        [viNumericKeyboard setKeyboardValue:((CAEditButton *)sender).text];
    }
    else if (sender == bDuration) {
        viDurationKeyboard.delegate1 = sender;
        viDurationKeyboard.delegate = nil;
        [viDurationKeyboard setKeyboardValue:((CAEditButton *)sender).text];
    }
    else if (sender == bSpeed) {
            viNumericKeyboard.nbDigits = 2;
        viNumericKeyboard.delegate = nil;
        viNumericKeyboard.delegate1 = sender;
        [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    else { // tfPace
        viDurationKeyboard.delegate1 = sender;
        viDurationKeyboard.delegate = nil;
        [viDurationKeyboard setKeyboardValue:((UITextField *)sender).text];
    }
    // Register the active control (used to resign first responder)
    viKeyboardAccessory.activeControl = sender;
    // Scroll the scroll up/down if required
    [self makeTextFieldVisible:nil];
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
        bSpeed.enabled = NO;
        bPace.enabled = NO;
        pgrSpeed.enabled = NO;
        [bSpeed setTitleColor:colorOrange forState:UIControlStateNormal];
        [bPace setTitleColor:colorOrange forState:UIControlStateNormal];
    }
    else {
        bSpeed.enabled = YES;
        bPace.enabled = YES;
        pgrSpeed.enabled = YES;
        [bSpeed setTitleColor:colorGreen forState:UIControlStateNormal];
        [bPace setTitleColor:colorGreen forState:UIControlStateNormal];
    }    
    if (sender == DISTANCE) {
        calcVar = DISTANCE;
        bDistance.enabled = NO;
        pgrDistance.enabled = NO;
        [bDistance setTitleColor:colorOrange forState:UIControlStateNormal];
    }
    else {
        bDistance.enabled = YES;
        pgrDistance.enabled = YES;
        [bDistance setTitleColor:colorGreen forState:UIControlStateNormal];
    }
    if (sender == DURATION) {
        calcVar = DURATION;
        bDuration.enabled = NO;
        pgrDuration.enabled = NO;
        [bDuration setTitleColor: colorOrange forState:UIControlStateNormal];
    }
    else {
        bDuration.enabled = YES;
        pgrDuration.enabled = YES;
        [bDuration setTitleColor: colorGreen forState:UIControlStateNormal];
    }
}

@end
