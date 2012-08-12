//
//  OTPEncodedPolylineTest.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/24/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "OTPMappingProvider.h"
#import "OTPEncodedPolyline.h"

@interface OTPEncodedPolylineTest : SenTestCase
@end

@implementation OTPEncodedPolylineTest

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
    return [[[[[[fixtureData valueForKey:@"plan"] valueForKey:@"itineraries"] firstObject] valueForKey:@"legs"] firstObject] valueForKey:@"legGeometry"];
}

- (RKObjectMapping *)mapping
{
    OTPMappingProvider *mappingProvider = [[OTPMappingProvider alloc] init];
    return [mappingProvider encodedPolylineObjectMapping];
}

- (RKMappingTest *)mappingTest
{
    return [RKMappingTest testForMapping:[self mapping] object:[self data]];
}

- (void)testMappingOfPoints
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"points" toKeyPath:@"points" withValue:@"e~zaHfaniVuFgAgBe@uAi@i@Ia@?m@GyCSSLUAcAAuA?wA?}B?iC?"];
    STAssertNoThrow([mappingTest verify], nil);
}

- (void)testMappingOfLength
{
    RKMappingTest *mappingTest = [self mappingTest];
    [mappingTest expectMappingFromKeyPath:@"length" toKeyPath:@"length" withValue:[NSNumber numberWithInt:15]];
    STAssertNoThrow([mappingTest verify], nil);
}

@end
