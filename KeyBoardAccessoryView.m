//
//  KeyBoardAccessory.m
//  RunCalc
//
//  Created by Christian on 16/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyboardAccessoryView.h"

@implementation KeyboardAccessoryView

@synthesize delegate;
@synthesize bDone;
@synthesize activeControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RunCalc-BgAccessory.png"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)closeKeyboard:(id)sender 
{
    [activeControl resignFirstResponder];
}

@end
