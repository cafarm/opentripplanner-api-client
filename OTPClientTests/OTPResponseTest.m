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
#import "OTPTripPlan.h"

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

- (RKMappingTest *)mappingTest
{
    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"response.json"];
    
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    RKObjectMapping *mapping = [mappingProvider responseObjectMapping];
    
    return [RKMappingTest testForMapping:mapping object:fixtureData];
}

//- (void)testMappingOfPlan
//{
//    RKMappingTest *mappingTest = [self mappingTest];
//    [mappingTest expectMappingFromKeyPath:@"plan" toKeyPath:@"tripPlan" passingTest:^BOOL(RKObjectAttributeMapping *mapping, id value) {
//        return [value isKindOfClass:[OTPTripPlan class]] && [[value date] isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1342991890000]];
//    }];
//    STAssertNoThrow([mappingTest verify], nil);
//}

@end
