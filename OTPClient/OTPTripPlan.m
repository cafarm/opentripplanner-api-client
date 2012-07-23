//
//  OTPTripPlan.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPTripPlan.h"

@implementation OTPTripPlan

@synthesize date;
@synthesize itineraries;

// OTP json dates are in unix epoch milliseconds not the standard seconds
- (void)setDateAsTimeInterval:(NSNumber *)dateAsTimeInterval
{
    self.date = [NSDate dateWithTimeIntervalSince1970:([dateAsTimeInterval longLongValue] / 1000)];
}

- (NSNumber *)dateAsTimeInterval
{
    return [NSNumber numberWithLongLong:([self.date timeIntervalSince1970] * 1000)];
}

@end
