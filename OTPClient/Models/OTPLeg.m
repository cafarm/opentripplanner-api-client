//
//  OTPLeg.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPLeg.h"
#import "OTPPlace.h"
#import "OTPEncodedPolyline.h"
#import "OTPWalkStep.h"
#import "NSDate+OTPTimeInterval.h"

@implementation OTPLeg

@synthesize mode;
@synthesize route;
@synthesize interlineWithPreviousLeg;
@synthesize isInterlinedWithPreviousLeg;
@synthesize tripShortName;
@synthesize headsign;
@synthesize tripID;

@synthesize startTime;
@synthesize endTime;
@synthesize distance;
@synthesize from;
@synthesize to;
@synthesize legGeometry;
@synthesize walkSteps;
@synthesize duration;

@synthesize itinerary;

@synthesize boundingMapRect = _boundingMapRect;
@synthesize polyline = _polyline;

- (MKPolyline *)polyline
{
    if (_polyline == nil) {
        const char *bytes = [self.legGeometry.points UTF8String];
        NSUInteger length = [self.legGeometry.points lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        NSUInteger index = 0;
        
        NSUInteger count = length / 4;
        CLLocationCoordinate2D *coordinates = calloc(count, sizeof(CLLocationCoordinate2D));
        NSUInteger coordinateIndex = 0;
        
        float latitude = 0;
        float longitude = 0;
        while (index < length) {
            char byte = 0;
            int result = 0;
            char shift = 0;
            
            do {
                byte = bytes[index++] - 63;
                result |= (byte & 0x1F) << shift;
                shift += 5;
            } while (byte >= 0x20);
            
            float deltaLatitude = ((result & 1) ? ~(result >> 1) : (result >> 1));
            latitude += deltaLatitude;
            
            shift = 0;
            result = 0;
            
            do {
                byte = bytes[index++] - 63;
                result |= (byte & 0x1F) << shift;
                shift += 5;
            } while (byte >= 0x20);
            
            float deltaLongitude = ((result & 1) ? ~(result >> 1) : (result >> 1));
            longitude += deltaLongitude;
            
            float finalLatitude = latitude * 1E-5;
            float finalLongitude = longitude * 1E-5;
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLatitude, finalLongitude);
            coordinates[coordinateIndex++] = coord;
            
            if (coordinateIndex == count) {
                NSUInteger newCount = count + 10;
                coordinates = realloc(coordinates, newCount * sizeof(CLLocationCoordinate2D));
                count = newCount;
            }
        }
        
        _polyline = [MKPolyline polylineWithCoordinates:coordinates count:coordinateIndex];
        free(coordinates);
    }
    return _polyline;
}

- (MKMapRect)boundingMapRect
{
    return self.polyline.boundingMapRect;
}

- (BOOL)isInterlinedWithPreviousLeg
{
    return [interlineWithPreviousLeg boolValue];
}

// Add leg reference to from
- (BOOL)validateFrom:(id *)ioValue error:(NSError **)outError
{
    OTPPlace *fromValue = (OTPPlace *)*ioValue;
    fromValue.leg = self;
    return YES;
}

// Add leg reference to to
- (BOOL)validateTo:(id *)ioValue error:(NSError **)outError
{
    OTPPlace *toValue = (OTPPlace *)*ioValue;
    toValue.leg = self;
    return YES;
}

// Add leg reference to legGeometry
- (BOOL)validateLegGeometry:(id *)ioValue error:(NSError **)outError
{
    OTPEncodedPolyline *legGeometryValue = (OTPEncodedPolyline *)*ioValue;
    legGeometryValue.leg = self;
    return YES;
}

// Add leg reference to walkSteps
- (BOOL)validateWalkSteps:(id *)ioValue error:(NSError **)outError
{
    NSArray *walkStepsValue = (NSArray *)*ioValue;
    for (OTPWalkStep *walkStep in walkStepsValue) {
        walkStep.leg = self;
    }
    return YES;
}

// Convert mode string to mode type prior to assignment
- (BOOL)validateMode:(id *)ioValue error:(NSError **)outError
{
    NSString *stringValue = (NSString *)*ioValue;
    
    if ([stringValue isEqualToString:@"WALK"]) {
        *ioValue = [NSNumber numberWithInt:OTPLegTraverseModeWalk];
    } else if ([stringValue isEqualToString:@"BUS"]) {
        *ioValue = [NSNumber numberWithInt:OTPLegTraverseModeBus];
    } else if ([stringValue isEqualToString:@"TRAM"]) {
        *ioValue = [NSNumber numberWithInt:OTPLegTraverseModeTram];
    } else if ([stringValue isEqualToString:@"RAIL"]) {
        *ioValue = [NSNumber numberWithInt:OTPLegTraverseModeRail];
    } else if ([stringValue isEqualToString:@"FERRY"]) {
        *ioValue = [NSNumber numberWithInt:OTPLegTraverseModeFerry];
    } else {
        return NO;
    }
    return YES;
}

- (void)setStartTimeAsTimeInterval:(NSNumber *)startTimeAsTimeInterval
{
    self.startTime = [NSDate dateWithOTPTimeInterval:[startTimeAsTimeInterval doubleValue]];
}

- (NSNumber *)startTimeAsTimeInterval
{
    return [NSNumber numberWithDouble:[self.startTime otpTimeInterval]];
}

- (void)setEndTimeAsTimeInterval:(NSNumber *)endTimeAsTimeInterval
{
    self.endTime = [NSDate dateWithOTPTimeInterval:[endTimeAsTimeInterval doubleValue]];
}

- (NSNumber *)endTimeAsTimeInterval
{
    return [NSNumber numberWithDouble:[self.endTime otpTimeInterval]];
}

@end
