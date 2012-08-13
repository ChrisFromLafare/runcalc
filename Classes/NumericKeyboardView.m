//
//  TimeKeyboardView.m
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NumericKeyboardView.h"
#import <math.h>
#define WHEELWIDTH 42.0f
#define NBROWS 10000

@interface NumericKeyboardView () {
    UIPickerView *picker;
    UILabel *lblDecDot;
}

@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UILabel *lblDecDot;

@end

@implementation NumericKeyboardView

@synthesize delegate, picker, lblDecDot, leadingZeros;
@dynamic nbDigits, nbFrac;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    leadingZeros = NO;
    lblDecDot.text = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];    
}
- (void)dealloc
{
    self.picker = nil;
    self.lblDecDot = nil;
    [super dealloc];
}

#pragma mark -
#pragma Accessors & Setters

-(int)nbDigits {
    return nbDigits;
}

-(void)setNbDigits:(int)nb {
    if (nbDigits != nb) {
        nbDigits = nb;
        [picker reloadAllComponents];
        CGFloat x = (picker.frame.size.width - (nbDigits+nbFrac)*WHEELWIDTH)/2 + nbDigits*WHEELWIDTH - 11;
        [lblDecDot setFrame:CGRectMake(x, 
                                       lblDecDot.frame.origin.y, 
                                       lblDecDot.frame.size.width,
                                       lblDecDot.frame.size.height)];
    }
}

-(int)nbFrac {
    return nbFrac;
}

-(void)setNbFrac:(int)nb {
    if (nbFrac != nb) {
        nbFrac = nb;
        [picker reloadAllComponents];
        if (nbFrac == 0) {
            lblDecDot.hidden = TRUE;
        }
        else {
            lblDecDot.hidden = FALSE;
            CGFloat x = (picker.frame.size.width - (nbDigits+nbFrac)*WHEELWIDTH)/2 + nbDigits*WHEELWIDTH - 11;
            [lblDecDot setFrame:CGRectMake(x, 
                                       lblDecDot.frame.origin.y, 
                                       lblDecDot.frame.size.width,
                                       lblDecDot.frame.size.height)];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return nbDigits + nbFrac;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // Use a large rows number to simulate a cycling wheel
    // By default, add a NBROWS/2 offset to the starting row
    return  NBROWS;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // row has an offset to allow the cycle simulation, get rid of it
    return [NSString stringWithFormat:@"%d", row % 10];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UITextRange *textRange = [delegate 
                          textRangeFromPosition: [delegate beginningOfDocument]  
                          toPosition: [delegate endOfDocument]];
    float value = 0;
    for (int i=0; i < nbDigits + nbFrac; i++) {
        value = value * 10.0f + [pickerView selectedRowInComponent:i]%10;
    }
    for (int i = 0; i < nbFrac; i++) {
        value /= 10.0f;
    }
    NSString *formatString;
    if (nbFrac == 0) {
        if (leadingZeros == YES) {
            formatString = [NSString stringWithFormat:@"%%0%d.0f", nbDigits, nbFrac];
        }
        else {
            formatString = [NSString stringWithFormat:@"%%%d.0f", nbDigits, nbFrac];
        }
    }
    else {
        if (leadingZeros == YES) {
            formatString = [NSString stringWithFormat:@"%%0%d.%df", nbDigits+nbFrac+1, nbFrac];
        }
        else {
            formatString = [NSString stringWithFormat:@"%%%d.%df", nbDigits+nbFrac+1, nbFrac];
        }
    }
    [delegate replaceRange: textRange
                  withText: [NSString localizedStringWithFormat: formatString, value]];               
}

- (void)setKeyboardValue:(NSString *)aNumber {
    float f;
    NSScanner *scan = [NSScanner localizedScannerWithString:aNumber];
    if ([scan scanFloat:&f]) {
        for (int i=0; i< nbFrac; i++) {
            f *= 10;
        }
        for (int i=nbFrac+nbDigits-1; i >= 0; i--) {
            int digit = fmodf(f, 10.0f);
            [picker selectRow:digit inComponent:i animated:YES];
            // readjust the offset in order to avoid reaching the limits, make it invisible by removing the animation
            [picker selectRow:NBROWS/2+digit inComponent:i animated:NO];
            f /= 10;
        }
    }
    else {
        for (int i=0; i < nbDigits+nbFrac; i++) {
            [picker selectRow:NBROWS/2 inComponent:i animated:YES];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    // Make the wheel with de decimal point wider
    if ((component == nbDigits - 1) && (nbFrac != 0)) return WHEELWIDTH + 3;
    return WHEELWIDTH;
}
@end


