//
//  TimeKeyboardView.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditableItem.h"

@interface DurationKeyboardView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>  {
    id <UITextInput> __unsafe_unretained delegate;
}

@property (nonatomic, unsafe_unretained) id <UITextInput> delegate;
@property (nonatomic, unsafe_unretained) id <CAEditableItem> delegate1;

-(void) setKeyboardValue:(NSString *)aString;
@end
