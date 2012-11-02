//
//  CAEditButton.m
//  RunCalc
//
//  Created by Christian on 20/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CAEditButton.h"

@implementation CAEditButton

@synthesize inputView, inputAccessoryView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)isUserInteractionEnabled {
    return YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL ret = [super becomeFirstResponder];
    if (ret) self.selected = YES;
    return ret;
}

- (BOOL)resignFirstResponder {
    BOOL ret = [super resignFirstResponder];
    if (ret) self.selected = NO;
    return ret;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self becomeFirstResponder];
}

-(void)setText:(NSString *)aString {
    [self setTitle:aString forState:UIControlStateNormal];
    [self sendActionsForControlEvents: UIControlEventValueChanged];
}

-(void)setTextWithoutValueChangedEvent:(NSString *)aString {
    [self setTitle:aString forState:UIControlStateNormal];
}

-(NSString *)text {
    return self.titleLabel.text;
}


@end
