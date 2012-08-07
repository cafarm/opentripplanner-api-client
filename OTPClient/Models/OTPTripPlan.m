//
//  OTPTripPlan.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPTripPlan.h"
#import "OTPItinerary.h"
#import "NSDate+OTPTimeInterval.h"

@implementation OTPTripPlan

@synthesize date;
@synthesize from;
@synthesize to;
@synthesize itineraries;

// Add parent tripPlan reference to itineraries 
- (BOOL)validateItineraries:(id *)ioValue error:(NSError **)outError
{
    NSArray *itinerariesValue = (NSArray *)*ioValue;
    for (OTPItinerary *itinerary in itinerariesValue) {
        itinerary.tripPlan = self;
    }
    return YES;
}

// OTP json dates are in unix epoch milliseconds not the standard seconds
- (void)setDateAsTimeInterval:(NSNumber *)dateAsTimeInterval
{
    self.date = [NSDate dateWithOTPTimeInterval:[dateAsTimeInterval doubleValue]];
}

- (NSNumber *)dateAsTimeInterval
{
    return [NSNumber numberWithDouble:[self.date otpTimeInterval]];
}

@end
