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
    STAssertTrue(leg.mode == OTPLegTraverseModeWalk, nil);
}

- (void)testMappingOfBusMode
{
    OTPLeg *leg = [[OTPLeg alloc] init];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[self mapping] sourceObject:[self transitData] destinationObject:leg];
    [mappingTest performMapping];
    STAssertTrue(leg.mode == OTPLegTraverseModeBus, nil);
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

- (void)testCreationOfPolyline
{
    // TODO: Move to fixture file
    
    OTPLeg *leg = [[OTPLeg alloc] init];
    
    leg.legGeometry = [[OTPEncodedPolyline alloc] init];
    leg.legGeometry.points = @"ivzaHp|siVAjDEnFAfAClD?nE?^hGBl@?zDDfF@f@?~F@bGB?~@?lDAlF?dA?|@?nDA`FW|CKxACRCPI`AQbBMjAS"
    "nCkApNAL?D?BkApNLCB?TA~BKRAd@Cr@?nB?`A?p@?|@B^?r@?V?D?F?D?^?H?t@?fA?TCd@SLGLMFGNORW`@o@HIp@uAt@kBp@cCDMDMb@{AVm@Tk@"
    "b@k@`@_@^[dDmCl@e@PIJGPEvF_@VETCb@Kz@UtCo@~EeAl@Sj@YjAi@`EsBbCkA^OPCJCpC?bE?nB?pA?V?rB?dA?jB?dD@lD@nNBP?nD@jD?n@@~@"
    "@R?D?B?N?L?P?tF@pB?vB@d@?`E?hFB|C@jA?p@?T?XGXS\\]rAwCr@bALPbAtA`ArA`AvA`ArA`AvAFFHPp@|@`ArAd@_ALWdBkDvCeGnCsFHOxCaG"
    "xByBv@w@l@k@vCiCfEsD";
    
    // Generated by online polyline encoder:
    // http://facstaff.unca.edu/mcmcclur/GoogleMaps/EncodePolyline/decode.html
    
    CLLocationCoordinate2D coordinates[154] = {{47.655570000000004, -122.33177},
        {47.65558, -122.33263000000001},
        {47.65561, -122.33383},
        {47.655620000000006, -122.33419},
        {47.655640000000005, -122.33506000000001},
        {47.655640000000005, -122.33610000000002},
        {47.655640000000005, -122.33626000000001},
        {47.65431, -122.33628000000002},
        {47.65408, -122.33628000000002},
        {47.65314, -122.33631000000001},
        {47.65198, -122.33632000000001},
        {47.65178, -122.33632000000001},
        {47.6505, -122.33633},
        {47.6492, -122.33635000000001},
        {47.6492, -122.33667000000001},
        {47.6492, -122.33754},
        {47.649210000000004, -122.33873000000001},
        {47.649210000000004, -122.33908000000001},
        {47.649210000000004, -122.33939000000001},
        {47.649210000000004, -122.34027},
        {47.64922000000001, -122.34140000000001},
        {47.64934, -122.34219000000002},
        {47.64940000000001, -122.34264},
        {47.649420000000006, -122.34274},
        {47.649440000000006, -122.34283},
        {47.64949000000001, -122.34316000000001},
        {47.64958000000001, -122.34366000000001},
        {47.64965, -122.34404},
        {47.649750000000004, -122.34476000000001},
        {47.650130000000004, -122.34725000000002},
        {47.65014, -122.34732000000001},
        {47.65014, -122.34735},
        {47.65014, -122.34737000000001},
        {47.65052000000001, -122.34986},
        {47.650450000000006, -122.34984000000001},
        {47.65043000000001, -122.34984000000001},
        {47.65032, -122.34983000000001},
        {47.649680000000004, -122.34977},
        {47.64958000000001, -122.34976},
        {47.649390000000004, -122.34974000000001},
        {47.64913000000001, -122.34974000000001},
        {47.64857000000001, -122.34974000000001},
        {47.64824, -122.34974000000001},
        {47.64799000000001, -122.34974000000001},
        {47.64768, -122.34976},
        {47.64752000000001, -122.34976},
        {47.64726, -122.34976},
        {47.64714000000001, -122.34976},
        {47.647110000000005, -122.34976},
        {47.64707000000001, -122.34976},
        {47.647040000000004, -122.34976},
        {47.64688, -122.34976},
        {47.64683, -122.34976},
        {47.64656, -122.34976},
        {47.64620000000001, -122.34976},
        {47.64609, -122.34974000000001},
        {47.645900000000005, -122.34964000000001},
        {47.645830000000004, -122.34960000000001},
        {47.64576, -122.34953000000002},
        {47.645720000000004, -122.34949},
        {47.64564000000001, -122.34941},
        {47.645540000000004, -122.34929000000001},
        {47.64537000000001, -122.34905},
        {47.645320000000005, -122.349},
        {47.645070000000004, -122.34857000000001},
        {47.644800000000004, -122.34803000000001},
        {47.64455, -122.34737000000001},
        {47.64452000000001, -122.3473},
        {47.644490000000005, -122.34723000000001},
        {47.644310000000004, -122.34677},
        {47.64419, -122.34654},
        {47.64408, -122.34632},
        {47.6439, -122.3461},
        {47.643730000000005, -122.34594000000001},
        {47.643570000000004, -122.34580000000001},
        {47.64274, -122.34509000000001},
        {47.64251, -122.34490000000001},
        {47.64242, -122.34485000000001},
        {47.642360000000004, -122.34481000000001},
        {47.64227, -122.34478000000001},
        {47.64103, -122.34462},
        {47.640910000000005, -122.34459000000001},
        {47.640800000000006, -122.34457},
        {47.640620000000006, -122.34451000000001},
        {47.64032, -122.34440000000001},
        {47.639570000000006, -122.34416000000002},
        {47.638450000000006, -122.34381},
        {47.638220000000004, -122.34371000000002},
        {47.638000000000005, -122.34358000000002},
        {47.637620000000005, -122.34337000000001},
        {47.63665, -122.34279000000001},
        {47.63599000000001, -122.34241000000002},
        {47.635830000000006, -122.34233},
        {47.635740000000006, -122.34231000000001},
        {47.63568, -122.34229},
        {47.63495, -122.34229},
        {47.633970000000005, -122.34229},
        {47.633410000000005, -122.34229},
        {47.633, -122.34229},
        {47.63288000000001, -122.34229},
        {47.6323, -122.34229},
        {47.63195, -122.34229},
        {47.63141, -122.34229},
        {47.63058, -122.34230000000001},
        {47.62971, -122.34231000000001},
        {47.627230000000004, -122.34233},
        {47.627140000000004, -122.34233},
        {47.62626, -122.34234000000001},
        {47.625400000000006, -122.34234000000001},
        {47.62516, -122.34235000000001},
        {47.624840000000006, -122.34236000000001},
        {47.62474, -122.34236000000001},
        {47.62471000000001, -122.34236000000001},
        {47.62469, -122.34236000000001},
        {47.624610000000004, -122.34236000000001},
        {47.62454, -122.34236000000001},
        {47.62445, -122.34236000000001},
        {47.62322, -122.34237000000002},
        {47.62265000000001, -122.34237000000002},
        {47.62205, -122.34238},
        {47.621860000000005, -122.34238},
        {47.62089, -122.34238},
        {47.61972, -122.34240000000001},
        {47.618930000000006, -122.34241000000002},
        {47.618550000000006, -122.34241000000002},
        {47.618300000000005, -122.34241000000002},
        {47.618190000000006, -122.34241000000002},
        {47.61806000000001, -122.34237000000002},
        {47.61793, -122.34227000000001},
        {47.61778, -122.34212000000001},
        {47.617360000000005, -122.34136000000001},
        {47.6171, -122.3417},
        {47.61703000000001, -122.34179},
        {47.616690000000006, -122.34222000000001},
        {47.61636000000001, -122.34264},
        {47.61603, -122.34308000000001},
        {47.615700000000004, -122.3435},
        {47.615370000000006, -122.34394},
        {47.61533000000001, -122.34398000000002},
        {47.615280000000006, -122.34407000000002},
        {47.615030000000004, -122.34438000000002},
        {47.614700000000006, -122.3448},
        {47.61451, -122.34448},
        {47.61444, -122.34436000000001},
        {47.61393, -122.3435},
        {47.613170000000004, -122.34219000000002},
        {47.61245, -122.34097000000001},
        {47.6124, -122.34089000000002},
        {47.611630000000005, -122.3396},
        {47.61102, -122.33899000000001},
        {47.61074000000001, -122.33871},
        {47.610510000000005, -122.33849000000001},
        {47.609750000000005, -122.33780000000002},
        {47.60875, -122.33690000000001}};
    
    MKPolyline *expectedPolyline = [MKPolyline polylineWithCoordinates:coordinates count:154];
    MKPolyline *actualPolyline = leg.polyline;
    
    STAssertTrue(actualPolyline.pointCount == expectedPolyline.pointCount, nil);
    
    for (int i = 0; i < actualPolyline.pointCount; i++) {
        CLLocationCoordinate2D expectedCoordinate = MKCoordinateForMapPoint(expectedPolyline.points[i]);
        NSLog(@"e:%i {%f,%f}", i, expectedCoordinate.latitude, expectedCoordinate.longitude);
        
        CLLocationCoordinate2D actualCoordinate = MKCoordinateForMapPoint(actualPolyline.points[i]);
        NSLog(@"a:%i {%f,%f}", i, actualCoordinate.latitude, actualCoordinate.longitude);
        
        STAssertTrue(fabs(actualCoordinate.latitude - expectedCoordinate.latitude) < 0.000005
                     && fabs(actualCoordinate.longitude - expectedCoordinate.longitude) < 0.000005, nil);
    }
}

@end
