//
//  OTPItineraryTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"
#import "OTPItinerary.h"
#import "OTPLeg.h"
#import "OTPFare.h"

@interface OTPItineraryTest : SenTestCase
@end

@implementation OTPItineraryTest

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
    return [[[fixtureData valueForKey:@"plan"] valueForKey:@"itineraries"] firstObject];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider itineraryObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfDuration
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"duration" toKeyPath:@"duration" withValue:[NSNumber numberWithDouble:5279000]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfStartTime
{
    OTPItinerary *itinerary = [[OTPItinerary alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self data] destinationObject:itinerary];
    [mappingTest performMapping];
    STAssertTrue([itinerary.startTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343088604]], nil);
}

- (void)testMappingOfEndTime
{
    OTPItinerary *itinerary = [[OTPItinerary alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self data] destinationObject:itinerary];
    [mappingTest performMapping];
    STAssertTrue([itinerary.endTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343093883]], nil);
}

- (void)testMappingOfWalkTime
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"walkTime" toKeyPath:@"walkTime" withValue:[NSNumber numberWithDouble:741]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfTransitTime
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"transitTime" toKeyPath:@"transitTime" withValue:[NSNumber numberWithDouble:3975]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfWaitingTime
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"waitingTime" toKeyPath:@"waitingTime" withValue:[NSNumber numberWithDouble:563]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfWalkDistance
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"walkDistance" toKeyPath:@"walkDistance" withValue:[NSNumber numberWithDouble:975.14642243767]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfTransfers
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"transfers" toKeyPath:@"transfers" withValue:[NSNumber numberWithInt:0]];
    STAssertNoThrow([mappingTest verify], nil);
}

//- (void)testMappingOfFare
//{
//    RKMappingTest *mappingTest = [self mappingTest];
//    [mappingTest expectMappingFromKeyPath:@"fare" toKeyPath:@"fare" withValue:nil];
//    STAssertNoThrow([mappingTest verify], nil);
//}

- (void)testMappingOfLegs
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"legs" toKeyPath:@"legs" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        BOOL isSuccessful = [value isKindOfClass:[NSArray class]] && [value count] == 6;
        for (OTPLeg *leg in value) {
            isSuccessful &= leg.itinerary != nil;
        }
        return isSuccessful;
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

@end
