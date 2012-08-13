//
//  RunCalcModel.m
//  RunCalc
//
//  Created by Snow Leopard User on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RunCalcModel.h"


@implementation RunCalcModel

@synthesize unit;
@dynamic speed, distance, duration;

#pragma mark -
#pragma mark Initializers

- (id) initWithDistance: (RCDistance *) aDistance andSpeed: (RCSpeed *) aSpeed {
	self = [super init];
	if (self) {
		speed = aSpeed;
        [speed retain];
		distance = aDistance;
        [distance retain];
        duration = [[RCTimeInterval alloc] init];
		[self.duration fromSpeed:aSpeed andDistance:aDistance];
        
	}
	return self;
}

- (id) initWithSpeed: (RCSpeed *) aSpeed andDuration: (RCTimeInterval *) aDuration {
	self = [super init];
	if (self) {
		speed = aSpeed;
        [speed retain];
		duration = aDuration;
        [duration retain];
        distance = [[RCDistance alloc] init];
        [distance fromSpeed:aSpeed andDuration:aDuration];
	}
	return self;
}
	
- (id) initWithDuration: (RCTimeInterval *) aDuration andDistance: (RCDistance *) aDistance {
	self = [super init];
	if (self) {
		duration = aDuration;
        [duration retain];
		self.distance = aDistance;
        [distance retain];
        speed = [[RCSpeed alloc] init];
        [speed fromDistance:aDistance andDuration:aDuration];
	}
	return self;
}

#pragma mark -
#pragma mark Getters and Setters

- (RCSpeed *) speed {
    return speed;
}

- (void) setSpeed:(RCSpeed *)speedValue {
    if (speedValue != speed) {
        [speedValue retain];
        [speed release];
        speed = speedValue;
        [duration fromSpeed:self.speed andDistance:self.distance];
    }
}

- (RCDistance *) distance {
    return distance;
}

- (void) setDistance:(RCDistance *)distanceValue {
    if (distanceValue != distance) {
        [distanceValue retain];
        [distance release];
        distance = distanceValue;
        [self.speed fromDistance:self.distance andDuration:self.duration];
    }
}

- (RCTimeInterval *) duration {
    return duration;
}

- (void)setDuration:(RCTimeInterval *)durationValue {
    if (duration != durationValue) {
        [durationValue retain];
        [duration release];
        duration = durationValue;
        [self.distance fromSpeed:self.speed andDuration:self.duration];
    }
}

#pragma mark -
#pragma mark Duration at fixed speed

-(RCTimeInterval *) getDurationForDistance:(float)aDistance {
    RCTimeInterval *dur = [[[RCTimeInterval alloc] init] autorelease];
    RCDistance *dist = [[RCDistance alloc] initWithDistance:aDistance];
    [dur fromSpeed:self.speed andDistance:dist];
    [dist release];
    return dur;
}

-(RCTimeInterval *)getHalfMarathonDuration {
    return (unit == UNIT_KM) ?
    [self getDurationForDistance:HALF_MARATHON_DISTANCE] :
    [self getDurationForDistance:HALF_MARATHON_DISTANCE / MILE_TO_KM];
}

-(RCTimeInterval *)getMarathonDuration {
    return (unit == UNIT_KM) ?
    [self getDurationForDistance:MARATHON_DISTANCE] :
    [self getDurationForDistance:MARATHON_DISTANCE / MILE_TO_KM];
}

-(RCTimeInterval *)get10KDuration {
    return (unit == UNIT_KM) ?
    [self getDurationForDistance:TEN_KM_DISTANCE] :
    [self getDurationForDistance:TEN_KM_DISTANCE / MILE_TO_KM];
}

#pragma mark -
#pragma mark Stop

- (void)dealloc
{
    self.duration = nil;
    self.distance = nil;
    self.speed = nil;
    [super dealloc];
}

@end
