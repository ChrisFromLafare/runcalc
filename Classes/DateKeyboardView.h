//
//  DateKeyboardView.h
//  RunCalc
//
//  Created by Christian on 03/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditableItem.h"

@interface DateKeyboardView : UIView {}

@property (nonatomic, unsafe_unretained) id <UITextInput> delegate;
@property (nonatomic, unsafe_unretained) id <CAEditableItem> delegate1;
@property (nonatomic) NSString *dateFormat;

-(void) setKeyboardValue:(NSString *)aString;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (IBAction)dateChanged:(id)sender;
@end
