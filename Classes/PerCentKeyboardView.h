//
//  TimeKeyboardView.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerCentKeyboardView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>  {
    id <UITextInput> delegate;
    bool leadingZeros;
}

@property (nonatomic, assign) id <UITextInput> delegate;
@property (nonatomic, assign) bool leadingZeros;

-(void) setKeyboardValue:(NSString *)aNumber;
@end
