//
//  OTPLeg.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "OTPLeg.h"
#import "OTPEncodedPolyline.h"
#import "NSDate+OTPTimeInterval.h"

@implementation OTPLeg

@synthesize mode;
@synthesize route;
@synthesize interlineWithPreviousLeg;
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

@synthesize polyline = _polyline;

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

- (MKPolyline *)polyline
{
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
    
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:coordinateIndex];
    free(coordinates);
    
    return polyline;
}

@end
