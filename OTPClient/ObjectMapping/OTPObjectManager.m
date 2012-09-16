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

// Use optimize to setting routing preferences
@property (nonatomic) NSUInteger maxWalkDistance;
@property (nonatomic) NSUInteger transferPenalty;

@end


@implementation OTPObjectManager

@synthesize baseURL = _baseURL;

@synthesize from = _from;
@synthesize to = _to;
@synthesize date = _date;
@synthesize numItineraries = _numItineraries;
@synthesize shouldArriveBy = _shouldArriveBy;
@synthesize requiresAccessibility = _requiresAccessibility;
@synthesize optimize = _optimize;

@synthesize rkObjectManager = _rkObjectManager;

@synthesize transferPenalty = _transferPenalty;
@synthesize maxWalkDistance = _maxWalkDistance;

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        
        _date = [NSDate date];
        _numItineraries = 3;
        _shouldArriveBy = NO;
        _requiresAccessibility = NO;
        _optimize = OTPObjectManagerOptimizeBestRoute;
        _transferPenalty = 0;
        _maxWalkDistance = 800;
    }
    return self;
}

- (RKObjectManager *)rkObjectManager
{
    if (_rkObjectManager == nil) {
        _rkObjectManager = [RKObjectManager managerWithBaseURL:self.baseURL];
        _rkObjectManager.mappingProvider = [[OTPMappingProvider alloc] init];
        [_rkObjectManager.client setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    return _rkObjectManager;
}

- (void)setOptimize:(OTPObjectManagerOptimize)optimize
{
    switch (optimize) {
        case OTPObjectManagerOptimizeBestRoute:
            self.maxWalkDistance = 800;
            self.transferPenalty = 0;
            break;
        case OTPObjectManagerOptimizeFewerTransfers:
            self.maxWalkDistance = 800;
            self.transferPenalty = 600;
            break;
        case OTPObjectManagerOptimizeLessWalking:
            self.maxWalkDistance = 400;
            self.transferPenalty = 300;
            break;
    }
    _optimize = optimize;
}

- (void)fetchTripPlanWithCompletionHandler:(OTPTripPlanCompletionHandler)completionHandler
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    
    NSDictionary *queryParameters = [NSDictionary dictionaryWithKeysAndObjects:
                                     @"fromPlace", [NSString stringWithFormat:@"%f,%f", self.from.latitude, self.from.longitude],
                                     @"toPlace", [NSString stringWithFormat:@"%f,%f", self.to.latitude, self.to.longitude],
                                     @"date", [dateFormatter stringFromDate:self.date],
                                     @"numItineraries", [NSString stringWithFormat:@"%i", self.numItineraries],
                                     @"time", [timeFormatter stringFromDate:self.date],
                                     @"arriveBy", self.shouldArriveBy ? @"true" : @"false",
                                     @"wheelchair", self.requiresAccessibility ? @"true" : @"false",
                                     @"transferPenalty", [NSString stringWithFormat:@"%i", self.transferPenalty],
                                     @"maxWalkDistance", [NSString stringWithFormat:@"%i", self.maxWalkDistance],
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

@end
