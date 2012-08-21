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

@synthesize from = _from;
@synthesize to = _to;
@synthesize date = _date;
@synthesize numItineraries = _numItineraries;
@synthesize shouldArriveBy = _shouldArriveBy;
@synthesize requiresAccessibility = _requiresAccessibility;
@synthesize maxWalkDistance = _maxWalkDistance;
@synthesize transferPenalty = _transferPenalty;

@synthesize rkObjectManager = _rkObjectManager;

- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
        
        _date = [NSDate date];
        _numItineraries = 3;
        _shouldArriveBy = NO;
        _requiresAccessibility = NO;
        _maxWalkDistance = 800;
        _transferPenalty = 0;
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
