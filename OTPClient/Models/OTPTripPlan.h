//
//  OTPTripPlan.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OTPPlace;
@class OTPItinerary;

@interface OTPTripPlan : NSObject

@property (strong, nonatomic) NSNumber *dateAsTimeInterval;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) OTPPlace *from;
@property (strong, nonatomic) OTPPlace *to;
@property (strong, nonatomic) NSArray *itineraries;

@property (nonatomic) unsigned int preferredItineraryIndex;
@property (readonly, nonatomic) OTPItinerary *preferredItinerary;

@end
