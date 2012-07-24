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

//- (RKMappingTest *)mappingTest
//{
//    id fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"plan.json"];
//    NSDictionary *itineraryData = [[fixtureData valueForKey:@"plan"] valueForKey:@"itineraries"];
//    
//    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
//    RKObjectMapping *mapping = [mappingProvider itineraryObjectMapping];
//    
//    return [RKMappingTest testForMapping:mapping object:itineraryData];
//}
//
//- (void)testMappingOfDuration
//{
//    RKMappingTest *mappingTest = [self mappingTest];
//    [mappingTest expectMappingFromKeyPath:@"duration" toKeyPath:@"duration"];
//    STAssertNoThrow([mappingTest verify], nil);
//}

@end
