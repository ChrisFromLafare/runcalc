//
//  TimeKeyboardView.m
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DurationKeyboardView.h"
#import <math.h>
#define WHEELWIDTH 42.0f
#define MAXROWS 60000

@interface DurationKeyboardView () {
    UIPickerView *picker;
}

@property (nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation DurationKeyboardView

@synthesize delegate, picker, delegate1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    return 6;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAXROWS; //A big number is used to simulate cycling wheels
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [NSString stringWithFormat:@"%d", row];
    switch (component) {
        case 0:
        case 1:
        case 3:
        case 5:
            return [NSString stringWithFormat:@"%d", row % 10];
//            return row % 10;
        case 2:
        case 4:
            return [NSString stringWithFormat:@"%d", row % 6];
//            return row % 6;
        default:
            return 0;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UITextRange *textRange;
    if (delegate) {
        textRange = [delegate 
                    textRangeFromPosition: [delegate beginningOfDocument]  
                    toPosition: [delegate endOfDocument]];
    }
    NSString *replacementString = [[NSString alloc] initWithFormat:@"%d%d:%d%d:%d%d", 
                                   [pickerView selectedRowInComponent:0] % 10, 
                                   [pickerView selectedRowInComponent:1] % 10, 
                                   [pickerView selectedRowInComponent:2] % 6, 
                                   [pickerView selectedRowInComponent:3] % 10, 
                                   [pickerView selectedRowInComponent:4] % 6, 
                                   [pickerView selectedRowInComponent:5] % 10];
    if (delegate) {
        [delegate replaceRange: textRange
                  withText: replacementString];
        
    }
    else if (delegate1) {
        [delegate1 setText:replacementString];
    }
}

// Reset each picker component to the middle 
// readjust the offset in order to avoid reaching the limits, make it invisible by removing the animation
- (void)calibrate {
    for (int i=0; i < 6; i++) {
        [picker selectRow:MAXROWS/2 + arc4random()%10 inComponent:i animated:NO];
    }    
}

- (void)setKeyboardValue:(NSString *)aString {
    int value;
    [self calibrate];
    if (aString.length != 8) { //  hh:mm:nn
        for (int i=0; i < 6; i++) {
            [picker selectRow:MAXROWS/2 inComponent:i animated:YES];
        }
    }
    else {
        for (int i=0; i < 2; i++) {
            value = [[aString substringWithRange:NSMakeRange(i,1)] intValue];
//            [picker selectRow:value inComponent:i animated:YES];
            [picker selectRow:MAXROWS/2 + value inComponent:i animated:YES];            
        }
        for (int i=3; i < 5; i++) {
            value = [[aString substringWithRange:NSMakeRange(i,1)] intValue];
//            [picker selectRow:value inComponent:i-1 animated:YES];
            [picker selectRow:MAXROWS/2 + value inComponent:i-1 animated:YES];            
        }
        for (int i=6; i < 8; i++) {
            value = [[aString substringWithRange:NSMakeRange(i,1)] intValue];
//            [picker selectRow:value inComponent:i-2 animated:YES];
            [picker selectRow:MAXROWS/2 + value inComponent:i-2 animated:YES];            
        }
    } 
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if ((component == 1) || (component == 3)) return WHEELWIDTH + 3;
    return WHEELWIDTH;
}
@end


