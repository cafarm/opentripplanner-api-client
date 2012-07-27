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
#import "OTPPlannerError.h"

@implementation OTPObjectManager
{
    RKObjectManager *_rkObjectManager;
}

+ (OTPObjectManager *)sharedManager
{
    static OTPObjectManager *sharedManager = nil;
    if (!sharedManager) {
        sharedManager = [[super allocWithZone:nil] init];
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (void)setBaseURL:(NSURL *)baseURL
{
    [self createRKObjectManagerWithBaseURL:baseURL];
}

- (NSURL *)baseURL
{
    return [self rkObjectManager].baseURL;
}

- (void)createRKObjectManagerWithBaseURL:(NSURL *)baseURL
{
    _rkObjectManager = [RKObjectManager managerWithBaseURL:baseURL];
    _rkObjectManager.mappingProvider = [[OTPMappingProvider alloc] init];
    [_rkObjectManager.client setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

- (RKObjectManager *)rkObjectManager
{
    if (!_rkObjectManager) {
        [self createRKObjectManagerWithBaseURL:[NSURL URLWithString:@"http://127.0.0.1:4567"]];
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
          withCompletion:(void (^)(OTPTripPlan *tripPlan, NSError *error))block
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
    
    [[self rkObjectManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader *loader) {        
        loader.onDidLoadObject = ^(id object) {
            OTPResponse *response = (OTPResponse *)object;
            
            OTPTripPlan *tripPlan = response.tripPlan;
            
            NSError *error = nil;
            if (response.plannerError) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:response.plannerError.message forKey:NSLocalizedDescriptionKey];
                error = [NSError errorWithDomain:@"domain" code:200 userInfo:userInfo];
            }
            
            block(tripPlan, error);
        };
        
        loader.onDidFailWithError = ^(NSError *error) {
            block(nil, error);
        };
    }];
}


- (void)loadTripPlanFrom:(CLLocationCoordinate2D)from
                      to:(CLLocationCoordinate2D)to
          withCompletion:(void (^)(OTPTripPlan *, NSError *))block
{
    [self loadTripPlanFrom:from
                        to:to
                      date:[NSDate date]
            numItineraries:1
            shouldArriveBy:NO
     requiresAccessibility:NO
           maxWalkDistance:800
           transferPenalty:0
            withCompletion:block];
}

@end
