//
//  TimeKeyboardView.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditableItem.h"

@interface NumericKeyboardView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    int nbDigits;
    int nbFrac;
}

@property (nonatomic, unsafe_unretained) id <UITextInput> delegate;
@property (nonatomic, unsafe_unretained) id <CAEditableItem> delegate1;
@property (nonatomic, assign) bool leadingZeros;
@property (nonatomic, assign) int nbDigits;
@property (nonatomic, assign) int nbFrac;

-(void) setKeyboardValue:(NSString *)aNumber;
@end
