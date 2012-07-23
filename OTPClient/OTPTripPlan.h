//
//  OTPTripPlan.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPTripPlan : NSObject

@property (strong, nonatomic) NSNumber *dateAsTimeInterval;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *itineraries;

@end
