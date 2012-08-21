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
@property (nonatomic) NSUInteger maxWalkDistance;
@property (nonatomic) NSUInteger transferPenalty;

- (void)fetchTripPlanWithCompletionHandler:(OTPTripPlanCompletionHandler)completionHandler;

@end
