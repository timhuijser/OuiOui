//
//  Annotation.h
//  OuiOui
//
//  Created by Paul Heijmans on 16-12-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end
