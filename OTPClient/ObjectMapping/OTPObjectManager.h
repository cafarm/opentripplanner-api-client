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

@interface OTPObjectManager : NSObject

@property (strong, readonly, nonatomic) NSURL *baseURL;

+ (OTPObjectManager *)sharedManager;

- (id)initWithBaseURL:(NSURL *)baseURL;

- (void)loadTripPlanFrom:(CLLocationCoordinate2D)from
                      to:(CLLocationCoordinate2D)to
                    date:(NSDate *)date
          numItineraries:(int)numItineraries
          shouldArriveBy:(BOOL)shouldArriveBy
   requiresAccessibility:(BOOL)requiresAccessibility
         maxWalkDistance:(int)maxWalkDistance
         transferPenalty:(int)transferPenalty
          withCompletion:(void (^)(OTPTripPlan *tripPlan, NSError *error))block;

- (void)loadTripPlanFrom:(CLLocationCoordinate2D)from
                      to:(CLLocationCoordinate2D)to
          withCompletion:(void (^)(OTPTripPlan *tripPlan, NSError *error))block;

@end
