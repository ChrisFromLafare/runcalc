//
//  CAEditableItem.h
//  RunCalc
//
//  Created by Christian on 21/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CAEditableItem <NSObject>

- (void)setText:(NSString *)aString;
- (NSString *) text;

@end
