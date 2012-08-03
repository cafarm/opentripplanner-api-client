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

@synthesize preferredItineraryIndex = _preferredItineraryIndex;
@synthesize preferredItinerary = _preferredItinerary;

- (void)setPreferredItineraryIndex:(unsigned int)preferredItineraryIndex
{
    NSAssert(preferredItineraryIndex < [self.itineraries count], @"Itinerary index out of bounds");
    
    _preferredItineraryIndex = preferredItineraryIndex;
}

- (OTPItinerary *)preferredItinerary
{
    return [self.itineraries objectAtIndex:self.preferredItineraryIndex];
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
