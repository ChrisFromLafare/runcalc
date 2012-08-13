//
//  RCSpeed.h
//  RunCalc
//
//  Created by mishanet on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCDistance;
@class RCTimeInterval;

#define MAXSPEED 99.99
//MAXPACE = 99h59mn59sec
#define MAXPACE 359999

@interface RCSpeed : NSObject {
    float value;
    NSTimeInterval paceValue;
    enum RCSpeedStatus {
        SPEED_UNDEF = -1,
        SPEED_VALID = 0,
        SPEED_OUTOFRANGE=1
    } status;
    enum RCPaceStatus {
        PACE_UNDEF = -1,
        PACE_VALID = 0,
        PACE_OUTOFRANGE = 1
    } paceStatus;
}

@property (nonatomic, assign) float value;
@property (nonatomic, assign) enum RCSpeedStatus status;
@property (nonatomic, assign) NSTimeInterval paceValue;
@property (nonatomic, assign) enum RCPaceStatus paceStatus;

- (id) initWithSpeed: (float) aSpeed;
- (id) initWithString: (NSString *)aString;
- (id) initWithPace: (NSTimeInterval) aPace;
- (id) initWithPaceString: (NSString *)aString;

- (NSString *) stringValue;
- (NSString *) stringValueForPace;
- (void) fromDistance: (RCDistance *) aDistance andDuration: (RCTimeInterval *) aDuration;
- (RCSpeed *) toKmH;
- (RCSpeed *) toMileH;
@end
