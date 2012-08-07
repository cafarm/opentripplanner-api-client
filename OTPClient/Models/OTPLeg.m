//
//  OTPLeg.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPLeg.h"
#import "NSDate+OTPTimeInterval.h"

@implementation OTPLeg

@synthesize mode;
@synthesize route;
@synthesize interlineWithPreviousLeg;
@synthesize tripShortName;
@synthesize headsign;
@synthesize tripID;

@synthesize startTime;
@synthesize endTime;
@synthesize distance;
@synthesize from;
@synthesize to;
@synthesize legGeometry;
@synthesize walkSteps;
@synthesize duration;

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
