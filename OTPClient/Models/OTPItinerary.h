//
//  OTPItinerary.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTPFare;
@class OTPLeg;

@interface OTPItinerary : NSObject

@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSNumber *startTimeAsTimeInterval;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSNumber *endTimeAsTimeInterval;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSNumber *walkTime;
@property (strong, nonatomic) NSNumber *transitTime;
@property (strong, nonatomic) NSNumber *waitingTime;
@property (strong, nonatomic) NSNumber *walkDistance;
@property (strong, nonatomic) NSNumber *transfers;
@property (strong, nonatomic) OTPFare *fare;
@property (strong, nonatomic) NSArray *legs;

@property (nonatomic) BOOL isStarted;
@property (nonatomic) unsigned int currentLegIndex;
@property (readonly, nonatomic) OTPLeg *currentLeg;

@end
