//
//  OTPMappingProvider.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPMappingProvider.h"
#import "OTPResponse.h"
#import "OTPTripPlan.h"
#import "OTPItinerary.h"

@implementation OTPMappingProvider

- (id)init
{
    self = [super init];
    if (self) {
        [self setObjectMapping:[self responseObjectMapping] forResourcePathPattern:@"/plan"];
    }
    
    return self;
}

- (RKObjectMapping *)responseObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPResponse class]];

    [mapping mapKeyPath:@"plan" toRelationship:@"tripPlan" withMapping:[self tripPlanObjectMapping]];
        
    return mapping;
}

- (RKObjectMapping *)tripPlanObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPTripPlan class]];
    [mapping mapKeyPathsToAttributes:@"date", @"dateAsTimeInterval", nil];
    
    [mapping mapKeyPath:@"itineraries" toRelationship:@"itineraries" withMapping:[self itineraryObjectMapping]];
    
    return mapping;
}

- (RKObjectMapping *)itineraryObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPItinerary class]];
    [mapping mapAttributes:@"duration", nil];
    
    return mapping;
}

@end
