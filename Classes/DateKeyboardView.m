//
//  DateKeyboardView.m
//  RunCalc
//
//  Created by Christian on 03/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateKeyboardView.h"

@interface DateKeyboardView ()

@property (nonatomic) IBOutlet UIDatePicker *picker;

@end

@implementation DateKeyboardView

@synthesize delegate, delegate1;
@synthesize picker;
@synthesize dateFormat;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setKeyboardValue:(NSString *)aString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSDate *d = [df dateFromString:aString];
    [picker setDate:d animated:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (dateFormat == nil) {
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
    }
    else {
        [df setDateFormat:dateFormat];
    }
    NSString *dateString = [df stringFromDate: [picker date]];
    [delegate1 setText:dateString];
}

- (void)dateChanged:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (dateFormat == nil) {
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
    }
    else {
        [df setDateFormat:dateFormat];
    }
    NSString *dateString = [df stringFromDate: [picker date]];
    if (delegate) {
        UITextRange *textRange;
        textRange = [delegate 
                     textRangeFromPosition: [delegate beginningOfDocument]  
                     toPosition: [delegate endOfDocument]];
        [delegate replaceRange: textRange
                      withText: dateString];         
    }
    else if (delegate1) 
        [delegate1 setText:dateString];
}
@end
