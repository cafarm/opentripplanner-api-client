//
//  OTPEncodedPolyline.h
//  OTPClient
//
//  Created by Mark Cafaro on 7/23/12.
//  Copyright (c) 2012 Seven O' Eight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPEncodedPolyline : NSObject

@property (strong, nonatomic) NSString *points;
@property (strong, nonatomic) NSNumber *length;

@end