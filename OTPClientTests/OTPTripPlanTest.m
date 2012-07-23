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

- (RKMappingTest *)mappingTest
{
    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"response.json"];
    NSDictionary *tripPlanData = [fixtureData valueForKey:@"plan"];
    
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    RKObjectMapping *mapping = [mappingProvider tripPlanObjectMapping];
    
    return [RKMappingTest testForMapping:mapping object:tripPlanData];
}

- (void)testMappingOfDateAsTimeInterval
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"date" toKeyPath:@"dateAsTimeInterval" withValue:[NSNumber numberWithLongLong:1342991890000]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfDate
{
    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"response.json"];
    NSDictionary *tripPlanData = [fixtureData valueForKey:@"plan"];
    
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    RKObjectMapping *mapping = [mappingProvider tripPlanObjectMapping];
    
    OTPTripPlan *tripPlan = [[OTPTripPlan alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping sourceObject:tripPlanData destinationObject:tripPlan];
    [mappingTest performMapping];
    
    STAssertTrue([tripPlan.date isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1342991890]], nil);
}

@end
