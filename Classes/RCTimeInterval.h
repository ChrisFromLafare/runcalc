//
//  RCTimeInterval.h
//  RunCalc
//
//  Created by mishanet on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RCSpeed.h"
//#import "RCDistance.h"
@class RCSpeed;
@class RCDistance;

//MAXDURATION = 99h59mn59sec
#define MAXDURATION 359999 


@interface RCTimeInterval : NSObject {
	NSTimeInterval value;
    enum RCTimeIntervalStatus {
        TIMEINTERVAL_UNDEF = -1,
        TIMEINTERVAL_VALID = 0,
        TIMEINTERVAL_OUTOFRANGE=1
    } status;    
}

@property (assign, nonatomic) NSTimeInterval value;
@property (assign, nonatomic) enum RCTimeIntervalStatus status;
- (id) initWithDuration: (NSTimeInterval) aDuration;
- (id) initWithString: (NSString *)aString;
- (NSString *) stringValue;
- (void) fromSpeed: (RCSpeed *)aSpeed andDistance: (RCDistance *)aDistance;

@end
