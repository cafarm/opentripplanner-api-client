//
//  OTPPlannerErrorTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"

@interface OTPPlannerErrorTest : SenTestCase
@end

@implementation OTPPlannerErrorTest

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
    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"responseWithError.json"];
    return [fixtureData valueForKey:@"error"];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider plannerErrorObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfID
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"id" toKeyPath:@"ID" withValue:[NSNumber numberWithInt:400]];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfMessage
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"msg" toKeyPath:@"message" withValue:@"Trip is not possible.  You might be trying to plan a trip outside the map data boundary."];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfNoPath
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"noPath" toKeyPath:@"noPath" withValue:[NSNumber numberWithBool:YES]];
    STAssertNoThrow([mappingTest verify], nil);
}

@end
