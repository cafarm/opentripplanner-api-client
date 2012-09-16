//
//  OTPObjectManager.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/24/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class OTPPlace;
@class OTPTripPlan;

typedef enum {
    OTPObjectManagerOptimizeBestRoute,
    OTPObjectManagerOptimizeFewerTransfers,
    OTPObjectManagerOptimizeLessWalking
} OTPObjectManagerOptimize;

typedef void (^OTPTripPlanCompletionHandler)(OTPTripPlan *tripPlan, NSError *error);

@interface OTPObjectManager : NSObject

- (id)initWithBaseURL:(NSURL *)baseURL;

@property (readonly, nonatomic) NSURL *baseURL;

@property (nonatomic) CLLocationCoordinate2D from;
@property (nonatomic) CLLocationCoordinate2D to;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) NSUInteger numItineraries;
@property (nonatomic) BOOL shouldArriveBy;
@property (nonatomic) BOOL requiresAccessibility;

// This is our own implementation of optimize using a mixture of max walking distance and transfer penalty
@property (nonatomic) OTPObjectManagerOptimize optimize;

- (void)fetchTripPlanWithCompletionHandler:(OTPTripPlanCompletionHandler)completionHandler;

@end
