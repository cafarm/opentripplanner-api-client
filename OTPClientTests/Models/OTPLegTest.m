//
//  OTPLegTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/24/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"
#import "OTPPlace.h"
#import "OTPLeg.h"
#import "OTPEncodedPolyline.h"
#import "OTPWalkStep.h"

@interface OTPLegTest : SenTestCase
@end

@implementation OTPLegTest

- (void)setUp
{
    [RKTestFactory setUp];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
}

- (id)walkData
{
    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"response.json"];
    return [[[[[fixtureData valueForKey:@"plan"] valueForKey:@"itineraries"] firstObject] valueForKey:@"legs"] firstObject];
}

- (id)transitData
{
    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"response.json"];
    return [[[[[fixtureData valueForKey:@"plan"] valueForKey:@"itineraries"] firstObject] valueForKey:@"legs"] objectAtIndex:1];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider legObjectMapping];
}

- (RKMappingTest *)walkMappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self walkData]];
}

- (RKMappingTest *)transitMappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self transitData]];
}

- (void)testMappingOfWalkMode
{
    OTPLeg *leg = [[OTPLeg alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self walkData] destinationObject:leg];
    [mappingTest performMapping];
    STAssertTrue(leg.mode == OTPWalk, nil);
}

- (void)testMappingOfBusMode
{
    OTPLeg *leg = [[OTPLeg alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self transitData] destinationObject:leg];
    [mappingTest performMapping];
    STAssertTrue(leg.mode == OTPBus, nil);
}

- (void)testMappingOfRoute
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"route" toKeyPath:@"route" withValue:@"68"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfInterlineWithPreviousLeg
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"interlineWithPreviousLeg" toKeyPath:@"interlineWithPreviousLeg" withValue:nil];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfIsInterlinedWithPreviousLeg
{
    OTPLeg *leg = [[OTPLeg alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self walkData] destinationObject:leg];
    [mappingTest performMapping];
    STAssertTrue(leg.isInterlinedWithPreviousLeg == NO, nil);
}

- (void)testMappingOfTripShortName
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"tripShortName" toKeyPath:@"tripShortName" withValue:@"LOCAL"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfHeadsign
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"headsign" toKeyPath:@"headsign" withValue:@"UNIVERSITY DISTRICT UNIVERSITY VILLAGE"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfTripID
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"tripId" toKeyPath:@"tripID" withValue:@"18195843"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfStartTime
{
    OTPLeg *leg = [[OTPLeg alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self walkData] destinationObject:leg];
    [mappingTest performMapping];
    STAssertTrue([leg.startTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343088604]], nil);
}

- (void)testMappingOfEndTime
{
    OTPLeg *leg = [[OTPLeg alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self walkData] destinationObject:leg];
    [mappingTest performMapping];
    STAssertTrue([leg.endTime isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343089144]], nil);
}

- (void)testMappingOfDistance
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"distance" toKeyPath:@"distance" withValue:[NSNumber numberWithDouble:1735.5847097489]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfFrom
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"from" toKeyPath:@"from" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPPlace class]] && [((OTPPlace *)value).name isEqualToString:@"25TH AVE NE & NE 47TH ST"] && ((OTPPlace *)value).leg != nil;
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfTo
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"to" toKeyPath:@"to" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPPlace class]] && [((OTPPlace *)value).name isEqualToString:@"NE 40TH ST & 7TH AVE NE"] && ((OTPPlace *)value).leg != nil;
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfLegGeometry
{
    RKMappingTest *mappingTest = [self transitMappingTest];
    [mappingTest expectMappingFromKeyPath:@"legGeometry" toKeyPath:@"legGeometry" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPEncodedPolyline class]] && [((OTPEncodedPolyline *)value).length isEqualToNumber:[NSNumber numberWithInt:75]] && ((OTPEncodedPolyline *)value).leg != nil;
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfWalkSteps
{
    RKMappingTest *mappingTest = [self walkMappingTest];
    [mappingTest expectMappingFromKeyPath:@"steps" toKeyPath:@"walkSteps" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        BOOL isSuccessful = [value isKindOfClass:[NSArray class]] && [value count] == 3;
        for (OTPWalkStep *walkStep in value) {
            isSuccessful &= walkStep.leg != nil;
        }
        return isSuccessful;
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfDuration
{
    RKMappingTest *mappingTest = [self walkMappingTest];
    [mappingTest expectMappingFromKeyPath:@"duration" toKeyPath:@"duration" withValue:[NSNumber numberWithDouble:540000]];
    STAssertNoThrow([mappingTest verify], nil);
}

@end
