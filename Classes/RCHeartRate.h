//
//  RCHeartRate.h
//  RunCalc
//
//  Created by mishanet on 17/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {MALE, FEMALE} t_sex;

@interface RCHeartRate : NSObject {
    int maxRate;
    int restRate;
}

@property (nonatomic, assign) int maxRate;
@property (nonatomic, assign) int restRate;

-(id)initWithMaxRate: (int)aRate;
-(id)initWithSex:(t_sex)aSex andAge:(int)aAge;
-(int)PerCent: (float) aPercentage;
-(int)PerCentKarvonen: (float) aPercentage;

@end
