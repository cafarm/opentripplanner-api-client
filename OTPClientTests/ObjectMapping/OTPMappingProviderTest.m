//
//  OTPMappingProviderTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/24/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "OTPMappingProvider.h"
#import "OTPResponse.h"
#import "OTPTripPlan.h"

@interface OTPMappingProviderTest : SenTestCase
@end

@implementation OTPMappingProviderTest

- (void)setUp
{
    [RKTestFactory setUp];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
}

// These tests require sinatra to be running
// Go to project root directory
// rvm gemset create RestKit
// rvm use 1.9.2@RestKit
// gem install bundler
// bundle
// rake server

- (void)testLoadingOfResponse
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    RKTestResponseLoader *responseLoader = [RKTestResponseLoader responseLoader];
    RKURL *url = [[RKTestFactory baseURL] URLByAppendingResourcePath:@"/ws/plan"];
    RKObjectLoader *objectLoader = [RKObjectLoader loaderWithURL:url mappingProvider:mappingProvider];
    objectLoader.delegate = responseLoader;
    [objectLoader sendAsynchronously];
    [responseLoader waitForResponse];
    
    STAssertEquals(YES, responseLoader.wasSuccessful, nil);
    OTPResponse *response = [responseLoader.objects objectAtIndex:0];
    STAssertNotNil(response, @"Expected response not to be nil");
    STAssertEqualObjects(response.tripPlan.date, [NSDate dateWithTimeIntervalSince1970:1343086320], nil);
}

@end
