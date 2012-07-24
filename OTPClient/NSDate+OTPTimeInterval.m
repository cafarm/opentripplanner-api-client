//
//  NSDate+OTPTimeInterval.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "NSDate+OTPTimeInterval.h"

@implementation NSDate (OTPTimeInterval)

// OTP json dates are in unix epoch milliseconds not the standard seconds
+ (id)dateWithOTPTimeInterval:(NSTimeInterval)timeInterval
{
    return [NSDate dateWithTimeIntervalSince1970:(timeInterval / 1000)];
}

- (NSTimeInterval)otpTimeInterval
{
    return [self timeIntervalSince1970] * 1000;
}

@end
