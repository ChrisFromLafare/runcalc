//
//  KeyboardAccessoryView.h
//  RunCalc
//
//  Created by mishanet on 03/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface KeyboardAccessoryView : UIView {
//    id <UITextInput> __unsafe_unretained delegate;
    UIControl *activeControl;
}

//@property (nonatomic, unsafe_unretained) id <UITextInput> delegate;
//@property (nonatomic) UIButton *bDone;
@property (nonatomic) UIControl *activeControl;

-(IBAction)closeKeyboard:(id)sender;
@end
