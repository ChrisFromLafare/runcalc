//
//  RCDistance.m
//  RunCalc
//
//  Created by mishanet on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCDistance.h"
#import "RCSpeed.h"
#import "RCTimeInterval.h"

@implementation RCDistance

@synthesize value, status;

#pragma mark -
#pragma mark Initializers

- (id)init
{
    self = [super init];
    if (self) {
        value = 0;
        status = DISTANCE_UNDEF;
    }
    return self;
}

- (id) initWithDistance:(float)aDistance {
    self = [super init];
    if (self) {
        value = aDistance;
        status = (aDistance <= MAXDISTANCE)? DISTANCE_VALID : DISTANCE_OUTOFRANGE;
    }
    return self;
}

- (id) initWithString:(NSString *)aString {
    self = [super init];
    if (self) {
        if ([aString isEqualToString: @"---.--"]) {
            value = 0;
            status = DISTANCE_UNDEF;
        }
        else if ([aString isEqualToString:@"###.##"]) {
            value = 0;
            status = DISTANCE_OUTOFRANGE;
        }
        else {
            NSScanner *aScan = [NSScanner localizedScannerWithString:aString];
            if (([aScan scanFloat:&value]) && (aScan.isAtEnd))
                status = (value <= MAXDISTANCE)? DISTANCE_VALID : DISTANCE_OUTOFRANGE;
            else {
                value = 0;
                status = DISTANCE_UNDEF;
            }
        }
    }
    return self;
}

#pragma mark -

- (NSString *) stringValue {
    switch (status) {
        case DISTANCE_UNDEF:
            return @"---.--";
        case DISTANCE_OUTOFRANGE:
            return @"###.##";
        default:
            return [NSString localizedStringWithFormat:@"%06.2f", value];
    }
}

- (void) fromSpeed:(RCSpeed *)aSpeed andDuration:(RCTimeInterval *)aDuration {
    if ((aSpeed == nil) || (aDuration == nil)) {
        self.value = 0;
        self.status = DISTANCE_UNDEF;
        return;
    }
    if ((aSpeed.status == SPEED_UNDEF) || (aDuration.status == TIMEINTERVAL_UNDEF)) {
        self.value = 0;
        self.status = DISTANCE_UNDEF;
    }
    else {
        self.value = aSpeed.value * aDuration.value / 3600;
        self.status = (self.value <= MAXDISTANCE)? DISTANCE_VALID : DISTANCE_OUTOFRANGE;
    }
}

#pragma mark -
#pragma mark Units Convertion

-(RCDistance *) toMiles {
    if (status == DISTANCE_UNDEF) {
        return [[[RCDistance alloc] init] autorelease];
    }
    return [[[RCDistance alloc] initWithDistance:self.value / MILE_TO_KM] autorelease];
}

-(RCDistance *) toKm {
    if (status == DISTANCE_UNDEF) {
        return [[[RCDistance alloc] init] autorelease];
    }
    return [[[RCDistance alloc] initWithDistance:self.value * MILE_TO_KM] autorelease];
}


@end
