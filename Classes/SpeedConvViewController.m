//
//  ConvViewController.m
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyboardAccessoryView.h"
#import "SpeedConvViewController.h"
#import "RCTimeInterval.h"
#import "RCSpeed.h"


@interface SpeedConvViewController ()

@property (nonatomic) IBOutlet UIImageView *uivKm;
@property (nonatomic) IBOutlet UIImageView *uivMi;
@property (nonatomic) IBOutlet UIImageView *uivMnKm;
@property (nonatomic) IBOutlet UIImageView *uivMnM;
@property (nonatomic) KeyboardAccessoryView *kav;
@property (nonatomic) BOOL keyboardShown;
@property (nonatomic) CGFloat heightCoveredByKeyboard;

@end

@implementation SpeedConvViewController

@synthesize tfKmH, tfMiH, tfMnKm, tfMnMi;
@synthesize viNumericKeyboard, viDurationKeyboard;
@synthesize uivKm, uivMi, uivMnKm, uivMnM;
@synthesize kav;
@synthesize scrollView;
@synthesize keyboardShown, heightCoveredByKeyboard;

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
    // Init scrollview
    self.scrollView.contentSize = self.scrollView.frame.size;
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
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];  
    kav = (KeyboardAccessoryView *)[views objectAtIndex:0];
    self.tfKmH.inputAccessoryView = kav;
    self.tfMiH.inputAccessoryView = kav;
    self.tfMnKm.inputAccessoryView = kav;
    self.tfMnMi.inputAccessoryView = kav;
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter  defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappeared:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
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
    CGRect activeControlFrameIVC = [self.view convertRect:self.kav.activeControl.frame fromView:self.kav.activeControl.superview];
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


- (void)editingBegin:(id)sender {
    if ((sender == tfKmH) || (sender == tfMiH)) {
        viNumericKeyboard.delegate = sender;
        [viNumericKeyboard setKeyboardValue:((UITextField *)sender).text];
        if (sender == tfKmH)
            uivKm.highlighted = YES;
        else 
            uivMi.highlighted = YES;
    }
    else if ((sender == tfMnKm) || (sender == tfMnMi)) {
        viDurationKeyboard.delegate = sender;
        [viDurationKeyboard setKeyboardValue:((UITextField *)sender).text];
        if (sender == tfMnKm)
            uivMnKm.highlighted = YES;
        else
            uivMnM.highlighted = YES;
    }
    kav.activeControl = sender;
    if (keyboardShown) [self makeTextFieldVisible:nil];
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
}

- (IBAction)backgroundTouched:(id)sender {
    [tfKmH resignFirstResponder];
    [tfMiH resignFirstResponder];
    [tfMnKm resignFirstResponder];
    [tfMnMi resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    uivKm.highlighted = NO;
    uivMi.highlighted = NO;
    uivMnKm.highlighted = NO;
    uivMnM.highlighted = NO;
}

@end
