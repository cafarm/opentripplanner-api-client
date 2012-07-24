//
//  OTPAgencyAndIDTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"

@interface OTPAgencyAndIDTest : SenTestCase
@end

@implementation OTPAgencyAndIDTest

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
    return [[[fixtureData valueForKey:@"plan"] valueForKey:@"from"] valueForKey:@"stopId"];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider agencyAndIDObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfID
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"id" toKeyPath:@"ID" withValue:@"23925"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfAgencyID
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"agencyId" toKeyPath:@"agencyID" withValue:@"EOS"];
    STAssertNoThrow([mappingTest verify], nil);
}

@end
