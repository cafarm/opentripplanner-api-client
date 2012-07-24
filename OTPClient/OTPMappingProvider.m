//
//  OTPMappingProvider.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPMappingProvider.h"
#import "OTPResponse.h"
#import "OTPRequestParameters.h"
#import "OTPTripPlan.h"
#import "OTPPlace.h"
#import "OTPAgencyAndID.h"
#import "OTPPlannerError.h"
#import "OTPItinerary.h"
#import "OTPFare.h"
#import "OTPLeg.h"
#import "OTPEncodedPolyline.h"
#import "OTPWalkStep.h"

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

    [mapping mapKeyPath:@"requestParameters" toRelationship:@"requestParameters" withMapping:[self requestParametersObjectMapping]];
    [mapping mapKeyPath:@"plan" toRelationship:@"tripPlan" withMapping:[self tripPlanObjectMapping]];
    [mapping mapKeyPath:@"error" toRelationship:@"plannerError" withMapping:[self plannerErrorObjectMapping]];
        
    return mapping;
}

- (RKObjectMapping *)requestParametersObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPRequestParameters class]];
    
    [mapping mapAttributes:@"fromPlace", @"toPlace", @"date", @"time", @"arriveBy", @"wheelchair", @"maxWalkDistance",
     @"mode", @"min", @"minTransferTime", @"numItineraries", @"transferPenalty", @"maxTransfers", nil];
    
    return mapping;
}

- (RKObjectMapping *)tripPlanObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPTripPlan class]];
    
    [mapping mapKeyPathsToAttributes:@"date", @"dateAsTimeInterval", nil];
    
    [mapping mapKeyPath:@"from" toRelationship:@"from" withMapping:[self placeObjectMapping]];
    [mapping mapKeyPath:@"to" toRelationship:@"to" withMapping:[self placeObjectMapping]];
    [mapping mapKeyPath:@"itineraries" toRelationship:@"itineraries" withMapping:[self itineraryObjectMapping]];
    
    return mapping;
}

- (RKObjectMapping *)placeObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPPlace class]];
    
    [mapping mapAttributes:@"name", @"stopCode", nil];
    [mapping mapKeyPathsToAttributes:
     @"lon", @"longitude",
     @"lat", @"latitude",
     @"arrival", @"arrivalAsTimeInterval",
     @"departure", @"depatureAsTimeInterval",
     nil];
    
    [mapping mapKeyPath:@"stopId" toRelationship:@"stopID" withMapping:[self agencyAndIDObjectMapping]];
    
    return mapping;
}

- (RKObjectMapping *)agencyAndIDObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPAgencyAndID class]];
    
    [mapping mapKeyPathsToAttributes:
     @"id", @"ID",
     @"agencyId", @"agencyID",
     nil];
    
    return mapping;
}

- (RKObjectMapping *)plannerErrorObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPPlannerError class]];
    
    [mapping mapAttributes:@"noPath", nil];    
    [mapping mapKeyPathsToAttributes:
     @"id", @"ID",
     @"msg", @"message",
     nil];
    
    return mapping;
}

- (RKObjectMapping *)itineraryObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPItinerary class]];
    
    [mapping mapAttributes:@"duration", @"walkTime", @"transitTime", @"waitingTime", @"walkDistance", @"transfers", nil];
    [mapping mapKeyPathsToAttributes:
     @"startTime", @"startTimeAsTimeInterval",
     @"endTime", @"endTimeAsTimeInterval",
     nil];
    
    [mapping mapKeyPath:@"fare" toRelationship:@"fare" withMapping:[self fareObjectMapping]];
    [mapping mapKeyPath:@"legs" toRelationship:@"legs" withMapping:[self legObjectMapping]];
    
    return mapping;
}

- (RKObjectMapping *)fareObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPFare class]];

    return mapping;
}

- (RKObjectMapping *)legObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPLeg class]];

    [mapping mapAttributes:@"mode", @"route", @"interlineWithPreviousLeg", @"tripShortName", @"headsign", @"distance",
     @"duration", nil];
    [mapping mapKeyPathsToAttributes:
     @"tripId", @"tripID",
     @"startTime", @"startTimeAsTimeInterval",
     @"endTime", @"endTimeAsTimeInterval",
     nil];
    
    [mapping mapKeyPath:@"from" toRelationship:@"from" withMapping:[self placeObjectMapping]];
    [mapping mapKeyPath:@"to" toRelationship:@"to" withMapping:[self placeObjectMapping]];
    [mapping mapKeyPath:@"legGeometry" toRelationship:@"legGeometry" withMapping:[self encodedPolylineObjectMapping]];
    [mapping mapKeyPath:@"steps" toRelationship:@"walkSteps" withMapping:[self walkStepObjectMapping]];
    
    return mapping;
}

- (RKObjectMapping *)encodedPolylineObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPEncodedPolyline class]];

    [mapping mapAttributes:@"points", @"length", nil];

    return mapping;
}

- (RKObjectMapping *)walkStepObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[OTPWalkStep class]];
    
    [mapping mapAttributes:@"distance", @"relativeDirection", @"streetName", @"absoluteDirection", @"exit", @"stayOn",
     @"bogusName", nil];
    [mapping mapKeyPathsToAttributes:
     @"lon", @"longitude",
     @"lat", @"latitude",
     nil];
    
    return mapping;
}

@end
