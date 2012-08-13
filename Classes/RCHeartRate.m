//
//  RCHeartRate.m
//  RunCalc
//
//  Created by mishanet on 17/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCHeartRate.h"

@implementation RCHeartRate

@dynamic maxRate, restRate;

#pragma mark -
#pragma mark initializers

-(id)initWithMaxRate:(int)aRate {
    self = [super init];
    if (self) {
        self.maxRate = aRate;
    }
    return self;
}

-(id)initWithSex:(t_sex)aSex andAge:(int)aAge {
    int aMaxRate;
    if (aAge < 15) aAge = 15;
    else if (aAge > 90) aAge = 90;
    switch (aSex) {
        case MALE:
            aMaxRate = 214 - (0.8 * aAge);
            break;
        case FEMALE:
            aMaxRate = 209 - (0.7 * aAge);
        default:
            break;
    }
    return [self initWithMaxRate:aMaxRate];
}

#pragma mark -
#pragma mark properties

-(int)maxRate {
    return maxRate;
}

-(void)setMaxRate:(int)newMaxRate {
    if (newMaxRate > 220) {
        maxRate = 220;
    }
    else if (newMaxRate < 130) {
        maxRate = 130;
    }
    else {
        maxRate = newMaxRate;
    }
}

-(int)restRate {
    return restRate;
}

-(void)setRestRate:(int)newRestRate {
    if (newRestRate < 25) {
        restRate = 0;
    }
    else if (newRestRate > 80) {
        restRate = 0;
    }
    else {
        restRate = newRestRate;
    }
}
#pragma mark -
#pragma mark methods

- (int)PerCent:(float)aPercentage {
    if (aPercentage < 0.0) return 0.0;
    if (aPercentage > 1.0) return self.maxRate;
    else {
        return self.maxRate * aPercentage;
    }
}

-(int)PerCentKarvonen:(float)aPercentage {
    if (aPercentage < 0.0) {
        aPercentage = 0.0;
    }
    else if (aPercentage > 1) {
        aPercentage = 1.0;
    }
    if (self.restRate != 0) {
        return (self.maxRate - self.restRate) * aPercentage + self.restRate;
    }
    else {
        return [self PerCent:aPercentage];
    }
}
@end
