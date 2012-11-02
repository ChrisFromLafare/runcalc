//
//  CAEditButton.h
//  RunCalc
//
//  Created by Christian on 20/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAEditableItem.h"

@interface CAEditButton : UIButton <CAEditableItem>

@property (strong, nonatomic, readwrite) UIView* inputView;
@property (strong, nonatomic, readwrite) UIView* inputAccessoryView;

- (void)setText:(NSString *)aString;
- (void)setTextWithoutValueChangedEvent:(NSString *)aString;
- (NSString *) text;

@end
