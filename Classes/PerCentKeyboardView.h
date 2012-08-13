//
//  TimeKeyboardView.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerCentKeyboardView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>  {
    id <UITextInput> __unsafe_unretained delegate;
    bool leadingZeros;
}

@property (nonatomic, unsafe_unretained) id <UITextInput> delegate;
@property (nonatomic, assign) bool leadingZeros;

-(void) setKeyboardValue:(NSString *)aNumber;
@end
