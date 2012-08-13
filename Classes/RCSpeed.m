//
//  RCSpeed.m
//  RunCalc
//
//  Created by mishanet on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCSpeed.h"
#import "RCDistance.h"
#import "RCTimeInterval.h"

@implementation RCSpeed

@synthesize value, status, paceValue, paceStatus;

#pragma mark -
#pragma mark Initializers

- (id)init
{
    self = [super init];
    if (self) {
        value = 0;
        status = SPEED_UNDEF;
        paceValue = 0;
        paceStatus = PACE_UNDEF;
    }
    return self;
}

- (void)toPace:(float)aSpeed {
    if (aSpeed == 0) {
        paceValue = 0;
        paceStatus = PACE_UNDEF;
    } else {
        paceValue = 3600 / aSpeed;
        paceStatus = (paceValue <= MAXPACE)? PACE_VALID : PACE_OUTOFRANGE;
    }
}

- (void)toSpeed:(NSTimeInterval)aPace {
    if (aPace == 0) {
        value = 0;
        status = SPEED_UNDEF;
    } else {
        value = 3600 / aPace;
        status = (value <= MAXSPEED)? SPEED_VALID : SPEED_OUTOFRANGE;
    }
}

- (id) initWithSpeed:(float)aSpeed {
    self = [super init];
    if (self) {
        value = aSpeed;
        status = (aSpeed <= MAXSPEED)? SPEED_VALID : SPEED_OUTOFRANGE;
        [self toPace:aSpeed];
    }
    return self;
}

- (id) initWithString:(NSString *)aString {
    self = [super init];
    if (self) {
        if ([aString isEqualToString: @"--.--"]) {
            value = 0;
            status = SPEED_UNDEF;
        }
        else if ([aString isEqualToString:@"##.##"]) {
            value = 0;
            status = SPEED_OUTOFRANGE;
        }
        else {
            NSScanner *aScan = [NSScanner localizedScannerWithString:aString];
            if (([aScan scanFloat:&value]) && ([aScan isAtEnd])) {
                status = (value <= MAXSPEED)? SPEED_VALID : SPEED_OUTOFRANGE;
            }
            else {
                value = 0;
                status = SPEED_UNDEF;
            }
        }
        [self toPace: value];
    }
    return self;
}

- (id) initWithPace:(NSTimeInterval)aPace {
    self = [super init];
    if (self) {
        paceValue = aPace;
        paceStatus = (aPace  <= MAXPACE)? PACE_VALID : PACE_OUTOFRANGE;
        [self toSpeed:aPace];
    }
    return self;
}

- (id) initWithPaceString:(NSString *)aString {
    self = [super init];
    if (self) {
        if ([aString isEqualToString: @"--:--:--"]) {
            paceValue = 0;
            paceStatus = PACE_UNDEF;
        }
        else if ([aString isEqualToString:@"##:##:##"]) {
            paceValue = 0;
            paceStatus = PACE_OUTOFRANGE;
        }
        else {
            int h,m,s;
            NSScanner *aScan = [NSScanner localizedScannerWithString:aString];
            if ([aScan scanInt:&h] && [aScan scanString:@":" intoString:NULL]
                && [aScan scanInt:&m] && [aScan scanString:@":" intoString:NULL]
                && [aScan scanInt:&s] && [aScan isAtEnd])
            {
                paceValue = h*3600 + m*60 + s;
                paceStatus = (paceValue <= MAXDURATION)? PACE_VALID : PACE_OUTOFRANGE;
            }
            else {
                paceValue = 0;
                paceStatus = PACE_UNDEF;
            }
        }
        [self toSpeed:paceValue];
    }
    return self;
}

#pragma mark -

- (NSString *) stringValue {
    switch (status) {
        case SPEED_UNDEF:
            return @"--.--";
        case SPEED_OUTOFRANGE:
            return @"##.##";
        default:
            return [NSString localizedStringWithFormat:@"%05.2f", value];
    }
}

- (NSString *) stringValueForPace {
    int h,mn,sec;
    switch (paceStatus) {
        case PACE_UNDEF:
            return @"--:--:--";
        case PACE_OUTOFRANGE:
            return @"##:##:##";
        default:
            h = floor(paceValue / 3600);
            mn = floor((paceValue - h*3600)/60);
            sec = paceValue - h*3600 - mn*60;
            return [NSString stringWithFormat:@"%02d:%02d:%02d", h, mn, sec];
    }
}

-(void) fromDistance:(RCDistance *)aDistance andDuration:(RCTimeInterval *)aDuration {
    if ((aDistance == nil) || (aDuration == nil)) {
        self.value = 0;
        self.status = SPEED_UNDEF;
    }
    else if ((aDistance.status == DISTANCE_UNDEF) || 
        (aDuration.status == TIMEINTERVAL_UNDEF) || (aDuration.value == 0)) {
        self.value = 0;
        self.status = SPEED_UNDEF;
    }
    else {
        self.value = aDistance.value / aDuration.value * 3600;
        self.status = (self.value <= MAXSPEED)? SPEED_VALID : SPEED_OUTOFRANGE;
    }
    [self toPace:value];
}

#pragma mark -
#pragma mark Units Convertion

-(RCSpeed *)toKmH {
    if ((status == SPEED_VALID) || (status == SPEED_OUTOFRANGE))
        return [[RCSpeed alloc] initWithSpeed:self.value * MILE_TO_KM];
    else {
        return [[RCSpeed alloc] init];
    }
}

-(RCSpeed *)toMileH {
    if ((status == SPEED_VALID) || (status == SPEED_OUTOFRANGE))
        return [[RCSpeed alloc] initWithSpeed:self.value / MILE_TO_KM];
    else {
        return [[RCSpeed alloc] init];
    }    
}
@end
