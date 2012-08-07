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

@synthesize modeString = _modeString;
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

- (void)setModeString:(NSString *)modeString
{
    if ([modeString isEqualToString:@"WALK"]) {
        self.mode = OTPWalk;
    } else if ([modeString isEqualToString:@"BUS"]) {
        self.mode = OTPBus;
    } else if ([modeString isEqualToString:@"TRAM"]) {
        self.mode = OTPTram;
    } else if ([modeString isEqualToString:@"RAIL"]) {
        self.mode = OTPRail;
    } else if ([modeString isEqualToString:@"FERRY"]) {
        self.mode = OTPFerry;
    }
    
    _modeString = modeString;
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
