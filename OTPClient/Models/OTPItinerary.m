//
//  OTPItinerary.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPItinerary.h"
#import "OTPLeg.h"
#import "OTPFare.h"
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

@synthesize tripPlan;

@synthesize boundingMapRect = _boundingMapRect;

- (id)init
{
    self = [super init];
    if (self) {
        _boundingMapRect = MKMapRectNull;
    }
    return self;
}

- (MKMapRect)boundingMapRect
{
    if (MKMapRectIsNull(_boundingMapRect)) {
        for (OTPLeg *leg in self.legs) {            
            if (MKMapRectIsNull(_boundingMapRect)) {
                _boundingMapRect = [leg boundingMapRect];
            } else {
                _boundingMapRect = MKMapRectUnion(_boundingMapRect, [leg boundingMapRect]);
            }
        }
    }
    return _boundingMapRect;
}

// Add parent itinerary reference to legs
- (BOOL)validateLegs:(id *)ioValue error:(NSError **)outError
{
    NSArray *legsValue = (NSArray *)*ioValue;
    for (OTPLeg *leg in legsValue) {
        leg.itinerary = self;
    }
    return YES;
}

// Add parent itinerary reference to fare
- (BOOL)validateFare:(id *)ioValue error:(NSError **)outError
{
    OTPFare *fareValue = (OTPFare *)*ioValue;
    fareValue.itinerary = self;
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
