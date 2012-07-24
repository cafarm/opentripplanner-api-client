//
//  OTPWalkStepTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/24/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"

@interface OTPWalkStepTest : SenTestCase
@end

@implementation OTPWalkStepTest

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
    return [[[[[[[fixtureData valueForKey:@"plan"] valueForKey:@"itineraries"] firstObject] valueForKey:@"legs"] firstObject] valueForKey:@"steps"] firstObject];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider walkStepObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfDistance
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"distance" toKeyPath:@"distance" withValue:[NSNumber numberWithDouble:140.01481400225]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfRelativeDirection
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"relativeDirection" toKeyPath:@"relativeDirection" withValue:nil];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfStreetName
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"streetName" toKeyPath:@"streetName" withValue:@"Montlake Boulevard Northeast"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfAbsoluteDirection
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"absoluteDirection" toKeyPath:@"absoluteDirection" withValue:@"NORTH"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfExit
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"exit" toKeyPath:@"exit" withValue:nil];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfStayOn
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"stayOn" toKeyPath:@"stayOn" withValue:[NSNumber numberWithBool:NO]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfBogusName
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"bogusName" toKeyPath:@"bogusName" withValue:[NSNumber numberWithBool:NO]];
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

@end
