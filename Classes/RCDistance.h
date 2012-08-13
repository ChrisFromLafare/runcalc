//
//  RCDistance.h
//  RunCalc
//
//  Created by mishanet on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCSpeed;
@class RCTimeInterval;

#define MAXDISTANCE 999.99
#define MILE_TO_KM 1.609344

@interface RCDistance : NSObject {
    float value;
    enum RCDistanceStatus {
        DISTANCE_UNDEF = -1,
        DISTANCE_VALID = 0,
        DISTANCE_OUTOFRANGE=1
    } status;
}

@property (nonatomic, assign) float value;
@property (nonatomic, assign) enum RCDistanceStatus status;

- (id) initWithDistance: (float) aDistance;
- (id) initWithString: (NSString *)aString;
- (NSString *) stringValue;
- (void) fromSpeed: (RCSpeed *) aSpeed andDuration: (RCTimeInterval *) aDuration;
- (RCDistance *) toMiles;
- (RCDistance *) toKm;

@end
