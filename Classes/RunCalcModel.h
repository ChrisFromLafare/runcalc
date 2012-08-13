//
//  RunCalcModel.h
//  RunCalc
//
//  Created by Snow Leopard User on 28/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTimeInterval.h"
#import "RCSpeed.h"
#import "RCDistance.h"

#define MARATHON_DISTANCE 42.195
#define HALF_MARATHON_DISTANCE 21.1
#define TEN_KM_DISTANCE 10
#define MILE_TO_KM 1.609344


@interface RunCalcModel : NSObject {
	RCSpeed *speed;
	RCDistance *distance;
    RCTimeInterval *duration;
    enum RCUnit {UNIT_KM, UNIT_MI} unit;
}

@property (nonatomic) RCSpeed *speed;
@property (nonatomic) RCDistance *distance;
@property (nonatomic) RCTimeInterval *duration;
@property (assign, nonatomic) enum RCUnit unit;

- (id) initWithDistance: (RCDistance *) aDistance andSpeed: (RCSpeed *) aSpeed;
- (id) initWithSpeed: (RCSpeed *) aSpeed andDuration: (RCTimeInterval *) aDuration;
- (id) initWithDuration: (RCTimeInterval *) aDuration andDistance: (RCDistance *) aDistance;

- (RCTimeInterval *)getMarathonDuration;
- (RCTimeInterval *)getHalfMarathonDuration;
- (RCTimeInterval *)getDurationForDistance: (float)aDistance;
@end
