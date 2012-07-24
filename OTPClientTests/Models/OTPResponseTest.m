//
//  OTPResponseTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/22/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"
#import "OTPRequestParameters.h"
#import "OTPTripPlan.h"
#import "OTPPlannerError.h"

@interface OTPResponseTest : SenTestCase
@end

@implementation OTPResponseTest

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
   return [RKTestFixture parsedObjectWithContentsOfFixture:@"response.json"];
}

- (id)dataWithError
{
    return [RKTestFixture parsedObjectWithContentsOfFixture:@"responseWithError.json"];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider responseObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (RKMappingTest *)mappingTestWithError
{
    return [RKMappingTest testForMapping:[self mapping] object:[self dataWithError]];
}

- (void)testMappingOfRequestParameters
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"requestParameters" toKeyPath:@"requestParameters" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPRequestParameters class]] && [((OTPRequestParameters *)value).date isEqualToString:@"7/23/2012"];
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfTripPlan
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"plan" toKeyPath:@"tripPlan" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPTripPlan class]] && [((OTPTripPlan *)value).date isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1343086320]];
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfPlannerError
{
    RKMappingTest *mappingTest = [self mappingTestWithError];
    [mappingTest expectMappingFromKeyPath:@"error" toKeyPath:@"plannerError" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
        return [value isKindOfClass:[OTPPlannerError class]] && [((OTPPlannerError *)value).ID isEqualToNumber:[NSNumber numberWithInt:400]];
    }];
    STAssertNoThrow([mappingTest verify], nil);
}

@end
