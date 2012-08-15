//
//  OTPObjectManager.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/24/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "OTPObjectManager.h"
#import "OTPMappingProvider.h"
#import "OTPResponse.h"
#import "OTPTripPlan.h"
#import "OTPPlannerError.h"
#import "OTPPlace.h"
#import "OTPItinerary.h"
#import "OTPFare.h"
#import "OTPLeg.h"
#import "OTPEncodedPolyline.h"
#import "OTPWalkStep.h"

@interface OTPObjectManager ()

@property (readonly, nonatomic) RKObjectManager *rkObjectManager;

@end


@implementation OTPObjectManager

@synthesize baseURL = _baseURL;

@synthesize rkObjectManager = _rkObjectManager;

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}

-(RKObjectManager *)rkObjectManager
{
    if (_rkObjectManager == nil) {
        _rkObjectManager = [RKObjectManager managerWithBaseURL:self.baseURL];
        _rkObjectManager.mappingProvider = [[OTPMappingProvider alloc] init];
        [_rkObjectManager.client setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    return _rkObjectManager;
}

- (void)loadTripPlanFrom:(CLLocationCoordinate2D)from
                      to:(CLLocationCoordinate2D)to
                    date:(NSDate *)date
          numItineraries:(int)numItineraries
          shouldArriveBy:(BOOL)shouldArriveBy
   requiresAccessibility:(BOOL)requiresAccessibility
         maxWalkDistance:(int)maxWalkDistance
         transferPenalty:(int)transferPenalty
       completionHandler:(OTPTripPlanCompletionHandler)completionHandler
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    
    NSDictionary *queryParameters = [NSDictionary dictionaryWithKeysAndObjects:
                                     @"fromPlace", [NSString stringWithFormat:@"%f,%f", from.latitude, from.longitude],
                                     @"toPlace", [NSString stringWithFormat:@"%f,%f", to.latitude, to.longitude],
                                     @"date", [dateFormatter stringFromDate:date],
                                     @"numItineraries", [NSString stringWithFormat:@"%i", numItineraries],
                                     @"time", [timeFormatter stringFromDate:date],
                                     @"arriveBy", shouldArriveBy ? @"true" : @"false",
                                     @"wheelchair", requiresAccessibility ? @"true" : @"false",
                                     @"transferPenalty", [NSString stringWithFormat:@"%i", transferPenalty],
                                     nil];
    
    NSString *resourcePath = [@"/ws/plan" stringByAppendingQueryParameters:queryParameters];
    
    DLog(@"Request URL: %@%@", [[self rkObjectManager].baseURL absoluteString], resourcePath);
    
    [self.rkObjectManager loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {
        
        loader.onDidLoadObject = ^(id object) {
            OTPResponse *response = (OTPResponse *)object;
            
            OTPTripPlan *tripPlan = response.tripPlan;
            
            NSError *error = nil;
            if (response.plannerError) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:response.plannerError.message forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:@"com.sevenoeight.OTPClient"
                                            code:[response.plannerError.ID intValue]
                                        userInfo:userInfo];
            }
            
            completionHandler(tripPlan, error);
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            completionHandler(nil, error);
        };
    }];
}


- (void)loadTripPlanFrom:(CLLocationCoordinate2D)from
                      to:(CLLocationCoordinate2D)to
       completionHandler:(OTPTripPlanCompletionHandler)completionHandler
{
    [self loadTripPlanFrom:from
                        to:to
                      date:[NSDate date]
            numItineraries:1
            shouldArriveBy:NO
     requiresAccessibility:NO
           maxWalkDistance:800
           transferPenalty:0
         completionHandler:completionHandler];
}

@end
