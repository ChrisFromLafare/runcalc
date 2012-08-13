//
//  RCTimeInterval.m
//  RunCalc
//
//  Created by mishanet on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCTimeInterval.h"
#import "RCSpeed.h"
#import "RCDistance.h"

@implementation RCTimeInterval

@synthesize value, status;

#pragma mark -
#pragma mark Initializers
- (id)init
{
    self = [super init];
    if (self) {
        self.value = 0.0;
        self.status = TIMEINTERVAL_UNDEF;
    }
    return self;
}

- (id)initWithDuration:(NSTimeInterval)aDuration  
{
    self = [super init];
    if (self) {
        self.value = aDuration;
        self.status = (aDuration <= MAXDURATION)? TIMEINTERVAL_VALID : TIMEINTERVAL_OUTOFRANGE;
    }
    return self;
}

- (id) initWithString:(NSString *)aString {
    self = [super init];
    if (self) {
        if ([aString isEqualToString: @"--:--:--"]) {
            value = 0;
            status = TIMEINTERVAL_UNDEF;
        }
        else if ([aString isEqualToString:@"##:##:##"]) {
            value = 0;
            status = TIMEINTERVAL_OUTOFRANGE;
        }
        else {
            int h,m,s;
            NSScanner *aScan = [NSScanner localizedScannerWithString:aString];
            if ([aScan scanInt:&h] && [aScan scanString:@":" intoString:NULL]
                && [aScan scanInt:&m] && [aScan scanString:@":" intoString:NULL]
                && [aScan scanInt:&s] && [aScan isAtEnd])
            {
                value = h*3600 + m*60 + s;
                status = (value <= MAXDURATION)? TIMEINTERVAL_VALID : TIMEINTERVAL_OUTOFRANGE;
            }
            else {
                value = 0;
                status = TIMEINTERVAL_UNDEF;
            }
        }
    }
    return self;
}

#pragma mark -

- (NSString *) stringValue {
    int h,mn,sec;
    switch (status) {
        case TIMEINTERVAL_UNDEF:
            return @"--:--:--";
        case TIMEINTERVAL_OUTOFRANGE:
            return @"##:##:##";
        default:
            h = floor(value / 3600);
            mn = floor((value - h*3600)/60);
            sec = value - h*3600 - mn*60;
            return [NSString stringWithFormat:@"%02d:%02d:%02d", h, mn, sec];
    }
}

-(void) fromSpeed:(RCSpeed *)aSpeed andDistance:(RCDistance *)aDistance {
    if ((aSpeed == nil) || (aDistance == nil)) {
        self.value = 0;
        self.status = TIMEINTERVAL_UNDEF;
    }
    if ((aSpeed.status == SPEED_UNDEF) || (aDistance.status == DISTANCE_UNDEF) 
        || (aSpeed.value == 0)) {
        self.value = 0;
        self.status = TIMEINTERVAL_UNDEF;
    }
    else {
        self.value = aDistance.value / aSpeed.value * 3600;
        self.status = (self.value <= MAXDURATION)? TIMEINTERVAL_VALID : TIMEINTERVAL_OUTOFRANGE;
    }
}

@end
