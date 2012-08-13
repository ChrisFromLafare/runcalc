//
//  TimeKeyboardView.m
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PerCentKeyboardView.h"
#import <math.h>
#define WHEELWIDTH 42.0f
#define NBROWS 10000

@interface PerCentKeyboardView () {
    UIPickerView *picker;
    UILabel *lblDecDot;
}

@property (nonatomic) IBOutlet UIPickerView *picker;
//@property (nonatomic, retain) IBOutlet UILabel *lblDecDot;

@end

@implementation PerCentKeyboardView

@synthesize delegate, picker, leadingZeros;

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
}


#pragma mark -
#pragma Accessors & Setters

/*
 // Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // Use a large rows number to simulate a cycling wheel
    // By default, add a NBROWS/2 offset to the starting row
    return  NBROWS;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // row has an offset to allow the cycle simulation, get rid of it
    if (component == 0) {
        return [NSString stringWithFormat:@"%d", row % 2];        
    }
    else {
        return [NSString stringWithFormat:@"%d", row % 10];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UITextRange *textRange = [delegate 
                          textRangeFromPosition: [delegate beginningOfDocument]  
                          toPosition: [delegate endOfDocument]];
    int value = 0;
    for (int i=0; i < 3; i++) {
        value = value * 10 + [pickerView selectedRowInComponent:i] % 10;
    }
    [delegate replaceRange: textRange
                  withText: [NSString localizedStringWithFormat: 
                             (leadingZeros == YES)?@"%03d":@"%3d", value]];               
}

- (void)setKeyboardValue:(NSString *)aNumber {
    int f;
    NSScanner *scan = [NSScanner localizedScannerWithString:aNumber];
    if ([scan scanInt :&f]) {
        for (int i=3; i >= 0; i--) {
            int digit = f % 10;
            [picker selectRow:digit inComponent:i animated:YES];
            // readjust the offset in order to avoid reaching the limits, make it invisible by removing the animation
            [picker selectRow:NBROWS/2+digit inComponent:i animated:NO];
            f /= 10;
        }
    }
    else {
        for (int i=0; i < 3; i++) {
            [picker selectRow:NBROWS/2 inComponent:i animated:YES];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    // Make the wheel with de decimal point wider
    if (component == 2) return WHEELWIDTH + 5;
    return WHEELWIDTH;
}
@end


