//
//  TimeKeyboardView.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumericKeyboardView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>  {
    id <UITextInput> __unsafe_unretained delegate;
    int nbDigits;
    int nbFrac;
    bool leadingZeros;
}

@property (nonatomic, unsafe_unretained) id <UITextInput> delegate;
@property (nonatomic, assign) bool leadingZeros;
@property (nonatomic, assign) int nbDigits;
@property (nonatomic, assign) int nbFrac;

-(void) setKeyboardValue:(NSString *)aNumber;
@end
