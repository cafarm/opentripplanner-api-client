//
//  OTPLeg.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class OTPPlace;
@class OTPEncodedPolyline;
@class OTPItinerary;

typedef enum {
    OTPLegTraverseModeWalk,
    OTPLegTraverseModeBus,
    OTPLegTraverseModeTram,
    OTPLegTraverseModeRail,
    OTPLegTraverseModeFerry
} OTPLegTraverseMode;

@interface OTPLeg : NSObject

@property (nonatomic) OTPLegTraverseMode mode;
@property (strong, nonatomic) NSString *route;
@property (strong, nonatomic) NSNumber *interlineWithPreviousLeg;
@property (readonly, nonatomic) BOOL isInterlinedWithPreviousLeg;
@property (strong, nonatomic) NSString *tripShortName;
@property (strong, nonatomic) NSString *headsign;
@property (strong, nonatomic) NSString *tripID;

@property (strong, nonatomic) NSNumber *startTimeAsTimeInterval;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSNumber *endTimeAsTimeInterval;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) OTPPlace *from;
@property (strong, nonatomic) OTPPlace *to;
@property (strong, nonatomic) OTPEncodedPolyline *legGeometry;
@property (strong, nonatomic) NSArray *walkSteps;
@property (strong, nonatomic) NSNumber *duration;

@property (weak, nonatomic) OTPItinerary *itinerary;

@property (readonly, nonatomic) MKPolyline *polyline;
@property (readonly, nonatomic) MKMapRect boundingMapRect;

@end
