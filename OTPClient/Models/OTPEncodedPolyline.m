//
//  OTPEncodedPolyline.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "OTPLeg.h"
#import "OTPEncodedPolyline.h"

@implementation OTPEncodedPolyline

@synthesize points = _points;
@synthesize length = _length;

@synthesize polyline = _polyline;

- (MKPolyline *)polyline
{
    if (_polyline == nil) {
        _polyline = [self polylineValue];
    }
    return _polyline;
}

- (MKPolyline *)polylineValue
{
    const char *bytes = [self.points UTF8String];
    NSUInteger length = [self.points lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
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
