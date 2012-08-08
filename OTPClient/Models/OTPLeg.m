//
//  OTPLeg.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPLeg.h"
#import "OTPPlace.h"
#import "OTPEncodedPolyline.h"
#import "OTPWalkStep.h"
#import "NSDate+OTPTimeInterval.h"

@implementation OTPLeg

@synthesize mode;
@synthesize route;
@synthesize interlineWithPreviousLeg;
@synthesize isInterlinedWithPreviousLeg;
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

@synthesize itinerary;

- (BOOL)isInterlinedWithPreviousLeg
{
    return [interlineWithPreviousLeg boolValue];
}

// Add leg reference to from
- (BOOL)validateFrom:(id *)ioValue error:(NSError **)outError
{
    OTPPlace *fromValue = (OTPPlace *)*ioValue;
    fromValue.leg = self;
    return YES;
}

// Add leg reference to to
- (BOOL)validateTo:(id *)ioValue error:(NSError **)outError
{
    OTPPlace *toValue = (OTPPlace *)*ioValue;
    toValue.leg = self;
    return YES;
}

// Add leg reference to legGeometry
- (BOOL)validateLegGeometry:(id *)ioValue error:(NSError **)outError
{
    OTPEncodedPolyline *legGeometryValue = (OTPEncodedPolyline *)*ioValue;
    legGeometryValue.leg = self;
    return YES;
}

// Add leg reference to walkSteps
- (BOOL)validateWalkSteps:(id *)ioValue error:(NSError **)outError
{
    NSArray *walkStepsValue = (NSArray *)*ioValue;
    for (OTPWalkStep *walkStep in walkStepsValue) {
        walkStep.leg = self;
    }
    return YES;
}

// Convert mode string to mode type prior to assignment
- (BOOL)validateMode:(id *)ioValue error:(NSError **)outError
{
    NSString *stringValue = (NSString *)*ioValue;
    
    if ([stringValue isEqualToString:@"WALK"]) {
        *ioValue = [NSNumber numberWithInt:OTPWalk];
    } else if ([stringValue isEqualToString:@"BUS"]) {
        *ioValue = [NSNumber numberWithInt:OTPBus];
    } else if ([stringValue isEqualToString:@"TRAM"]) {
        *ioValue = [NSNumber numberWithInt:OTPTram];
    } else if ([stringValue isEqualToString:@"RAIL"]) {
        *ioValue = [NSNumber numberWithInt:OTPRail];
    } else if ([stringValue isEqualToString:@"FERRY"]) {
        *ioValue = [NSNumber numberWithInt:OTPFerry];
    } else {
        return NO;
    }
    return YES;
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
