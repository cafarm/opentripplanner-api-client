//
//  OTPPlace.m
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import "OTPPlace.h"
#import "OTPAgencyAndID.h"
#import "NSDate+OTPTimeInterval.h"

@implementation OTPPlace

@synthesize name;
@synthesize stopID;
@synthesize stopCode;
@synthesize longitude;
@synthesize latitude;
@synthesize arrival;
@synthesize departure;

@synthesize leg;

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

- (MKMapPoint)mapPoint
{
    return MKMapPointForCoordinate(self.coordinate);
}

// Add parent place reference to stopID
- (BOOL)validateStopID:(id *)ioValue error:(NSError **)outError
{
    OTPAgencyAndID *stopIDValue = (OTPAgencyAndID *)*ioValue;
    stopIDValue.place = self;
    return YES;
}

- (void)setArrivalAsTimeInterval:(NSNumber *)arrivalAsTimeInterval
{
    self.arrival = [NSDate dateWithOTPTimeInterval:[arrivalAsTimeInterval doubleValue]];
}

- (NSNumber *)arrivalAsTimeInterval
{
    return [NSNumber numberWithDouble:[self.arrival otpTimeInterval]];
}

- (void)setDepatureAsTimeInterval:(NSNumber *)depatureAsTimeInterval
{
    self.departure = [NSDate dateWithOTPTimeInterval:[depatureAsTimeInterval doubleValue]];
}

- (NSNumber *)depatureAsTimeInterval
{
    return [NSNumber numberWithDouble:[self.departure otpTimeInterval]];
}

@end
