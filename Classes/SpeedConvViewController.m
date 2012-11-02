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

@property (nonatomic) KeyboardAccessoryView *kav;
@property (nonatomic) BOOL keyboardShown;
@property (nonatomic) CGFloat heightCoveredByKeyboard;

@end

@implementation SpeedConvViewController

@synthesize bKmH, bMiH, bMnKm, bMnMi;
@synthesize viNumericKeyboard, viDurationKeyboard;
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
    self.bKmH.inputView = self.viNumericKeyboard;
    self.bMiH.inputView = self.viNumericKeyboard; 
    views = [[NSBundle mainBundle] loadNibNamed:@"DurationKeyboardView" owner:self options:nil];
    self.viDurationKeyboard = (DurationKeyboardView *)[views objectAtIndex:0];
    self.bMnKm.inputView = self.viDurationKeyboard;
    self.bMnMi.inputView = self.viDurationKeyboard;
    views = [[NSBundle mainBundle] loadNibNamed:@"KeyboardAccessoryView" owner:self options:nil];  
    kav = (KeyboardAccessoryView *)[views objectAtIndex:0];
    self.bKmH.inputAccessoryView = kav;
    self.bMiH.inputAccessoryView = kav;
    self.bMnKm.inputAccessoryView = kav;
    self.bMnMi.inputAccessoryView = kav;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.bKmH = nil;
    self.bMiH = nil;
    self.bMnKm = nil;
    self.bMnMi = nil;
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
    if ((sender == bKmH) || (sender == bMiH)) {
        viNumericKeyboard.delegate1 = sender;
        [viNumericKeyboard setKeyboardValue:((CAEditButton *)sender).text];
    }
    else if ((sender == bMnKm) || (sender == bMnMi)) {
        viDurationKeyboard.delegate1 = sender;
        [viDurationKeyboard setKeyboardValue:((CAEditButton *)sender).text];
    }
    kav.activeControl = sender;
    if (keyboardShown) [self makeTextFieldVisible:nil];
}

- (void)convert:(id)sender {
    RCSpeed *speed;
    if ((sender == bMiH) || (sender == bKmH)) {
        speed = [[RCSpeed alloc] initWithString:((CAEditButton *)sender).text];
    }
    else if ((sender == bMnKm) || (sender == bMnMi)) {
        speed = [[RCSpeed alloc] initWithPaceString:((CAEditButton *)sender).text];        
    }
    if (sender == bKmH) {
        RCSpeed *speedMi = [speed toMileH];
        [bMnKm setTextWithoutValueChangedEvent:[speed stringValueForPace]];
        [bMiH setTextWithoutValueChangedEvent: [speedMi stringValue]];
        [bMnMi setTextWithoutValueChangedEvent: [speedMi stringValueForPace]];
    }
    else if (sender == bMiH) {
        RCSpeed *speedKm = [speed toKmH];
        [bMnMi setTextWithoutValueChangedEvent:[speed stringValueForPace]];
        [bKmH setTextWithoutValueChangedEvent: [speedKm stringValue]];
        [bMnKm setTextWithoutValueChangedEvent: [speedKm stringValueForPace]];
    }
    else if (sender == bMnKm) {
        RCSpeed *speedMi = [speed toMileH];
        [bKmH setTextWithoutValueChangedEvent: [speed stringValue]];
        [bMiH setTextWithoutValueChangedEvent: [speedMi stringValue]];
        [bMnMi setTextWithoutValueChangedEvent: [speedMi stringValueForPace]];
    }
    else if (sender == bMnMi) {
        RCSpeed *speedKm = [speed toKmH];
        [bMiH setTextWithoutValueChangedEvent: [speed stringValue]];
        [bKmH setTextWithoutValueChangedEvent: [speedKm stringValue]];
        [bMnKm setTextWithoutValueChangedEvent: [speedKm stringValueForPace]];
    }
}

- (IBAction)backgroundTouched:(id)sender {
    [bKmH resignFirstResponder];
    [bMiH resignFirstResponder];
    [bMnKm resignFirstResponder];
    [bMnMi resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

@end
