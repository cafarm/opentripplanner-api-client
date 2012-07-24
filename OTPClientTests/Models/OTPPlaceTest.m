//
//  OTPPlaceTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"
#import "OTPPlace.h"
#import "OTPAgencyAndID.h"

@interface OTPPlaceTest : SenTestCase
@end

@implementation OTPPlaceTest

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
    return [[fixtureData valueForKey:@"plan"] valueForKey:@"from"];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider placeObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfName
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"name" toKeyPath:@"name" withValue:@"Montlake Boulevard Northeast"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfStopID
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"stopId" toKeyPath:@"stopID" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPAgencyAndID class]] && [((OTPAgencyAndID *)value).ID isEqualToString:@"23925"];
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfStopCode
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"stopCode" toKeyPath:@"stopCode" withValue:nil];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfLongitude
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"lon" toKeyPath:@"longitude" withValue:[NSNumber numberWithDouble:-122.30179994748]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfLatitude
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"lat" toKeyPath:@"latitude" withValue:[NSNumber numberWithDouble:47.65683068757]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfArrival
{
    OTPPlace *place = [[OTPPlace alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self data] destinationObject:place];
    [mappingTest performMapping];
    STAssertTrue([place.arrival isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343089145]], nil);
}

- (void)testMappingOfDeparture
{
    OTPPlace *place = [[OTPPlace alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self data] destinationObject:place];
    [mappingTest performMapping];
    STAssertTrue([place.departure isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343089145]], nil);
}

@end
