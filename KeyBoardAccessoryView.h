//
//  KeyBoardAccessory.h
//  RunCalc
//
//  Created by Christian on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardAccessoryView : UIView
{
    id <UITextInput> __unsafe_unretained delegate;
    UIButton *bDone;
    UIControl *activeControl;
}

@property (nonatomic, unsafe_unretained) id <UITextInput> delegate;
@property (nonatomic) IBOutlet UIButton *bDone;
@property (nonatomic) UIControl *activeControl;

- (IBAction)closeKeyboard:(id)sender;
//

@end
