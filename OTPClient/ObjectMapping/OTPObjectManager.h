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

- (void)loadTripPlanFrom:(CLLocationCoordinate2D)from
                      to:(CLLocationCoordinate2D)to
                    date:(NSDate *)date
          numItineraries:(int)numItineraries
          shouldArriveBy:(BOOL)shouldArriveBy
   requiresAccessibility:(BOOL)requiresAccessibility
         maxWalkDistance:(int)maxWalkDistance
         transferPenalty:(int)transferPenalty
       completionHandler:(OTPTripPlanCompletionHandler)completionHandler;

- (void)loadTripPlanFrom:(CLLocationCoordinate2D)from
                      to:(CLLocationCoordinate2D)to
       completionHandler:(OTPTripPlanCompletionHandler)completionHandler;

@end
