//
//  OTPTripPlanTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"
#import "OTPTripPlan.h"
#import "OTPPlace.h"
#import "OTPItinerary.h"

@interface OTPTripPlanTest : SenTestCase
@end

@implementation OTPTripPlanTest

- (void)setUp
{
    [RKTestFactory setUp];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
}

- (id)data
{
    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"response.json"];
    return [fixtureData valueForKey:@"plan"];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider tripPlanObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfDate
{    
    OTPTripPlan *tripPlan = [[OTPTripPlan alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self data] destinationObject:tripPlan];
    [mappingTest performMapping];
    STAssertTrue([tripPlan.date isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343086320]], nil);
}

- (void)testMappingOfFrom
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"from" toKeyPath:@"from" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPPlace class]] && [((OTPPlace *)value).name isEqualToString:@"Montlake Boulevard Northeast"];
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfTo
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"to" toKeyPath:@"to" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPPlace class]] && [((OTPPlace *)value).name isEqualToString:@"East Marginal Way South"];
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfItineraries
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"itineraries" toKeyPath:@"itineraries" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[NSArray class]] && [value count] == 3;
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

@end
