//
//  NSDate+OTPTimeInterval.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (OTPTimeInterval)

+ (id)dateWithOTPTimeInterval:(NSTimeInterval)timeInterval;

- (NSTimeInterval)otpTimeInterval;

@end
