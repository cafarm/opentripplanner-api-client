//
//  OTPItinerary.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPItinerary.h"
#import "NSDate+OTPTimeInterval.h"

@implementation OTPItinerary

@synthesize duration;
@synthesize startTime;
@synthesize endTime;
@synthesize walkTime;
@synthesize transitTime;
@synthesize waitingTime;
@synthesize walkDistance;
@synthesize transfers;
@synthesize fare;
@synthesize legs;

@synthesize isStarted = _isStarted;
@synthesize currentLegIndex = _currentLegIndex;
@synthesize currentLeg = _currentLeg;

- (void)setCurrentLegIndex:(unsigned int)currentLegIndex
{
    NSAssert(currentLegIndex < [self.legs count], @"Leg index is out of bounds");
    
    _currentLegIndex = currentLegIndex;
}

- (OTPLeg *)currentLeg
{
    return [self.legs objectAtIndex:self.currentLegIndex];
}

- (void)setStartTimeAsTimeInterval:(NSNumber *)startTimeAsTimeInterval
{
    self.startTime = [NSDate dateWithOTPTimeInterval:[startTimeAsTimeInterval doubleValue]];
}

- (NSNumber *)startTimeAsTimeInterval
{
    return [NSNumber numberWithDouble:[self.startTime otpTimeInterval]];
}

- (void)setEndTimeAsTimeInterval:(NSNumber *)endTimeAsTimeInterval
{
    self.endTime = [NSDate dateWithOTPTimeInterval:[endTimeAsTimeInterval doubleValue]];
}

- (NSNumber *)endTimeAsTimeInterval
{
    return [NSNumber numberWithDouble:[self.endTime otpTimeInterval]];
}

@end
