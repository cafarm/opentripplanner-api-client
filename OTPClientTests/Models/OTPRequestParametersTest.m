//
//  OTPRequestParametersTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"
#import "OTPRequestParameters.h"

@interface OTPRequestParametersTest : SenTestCase
@end

@implementation OTPRequestParametersTest

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
    return [fixtureData valueForKey:@"requestParameters"];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider requestParametersObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfDate
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"date" toKeyPath:@"date" withValue:@"7/23/2012"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfTransferPenalty
{
    OTPRequestParameters *requestParameters = [[OTPRequestParameters alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self data] destinationObject:requestParameters];
    [mappingTest performMapping];
    STAssertNoThrow([requestParameters.transferPenalty isEqualToString:@""], nil);
}

@end