//
//  OTPItinerary.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class OTPFare;
@class OTPLeg;
@class OTPTripPlan;

@interface OTPItinerary : NSObject

@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSNumber *startTimeAsTimeInterval;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSNumber *endTimeAsTimeInterval;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSNumber *walkTime;
@property (strong, nonatomic) NSNumber *transitTime;
@property (strong, nonatomic) NSNumber *waitingTime;
@property (strong, nonatomic) NSNumber *walkDistance;
@property (strong, nonatomic) NSNumber *transfers;
@property (strong, nonatomic) OTPFare *fare;
@property (strong, nonatomic) NSArray *legs;

@property (weak, nonatomic) OTPTripPlan *tripPlan;

@property (readonly, nonatomic) MKMapRect boundingMapRect;

@end
