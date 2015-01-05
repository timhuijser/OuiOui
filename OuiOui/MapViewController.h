//
//  MapViewController.h
//  OuiOui
//
//  Created by Paul Heijmans on 16-12-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, readwrite) NSMutableArray *followersArray;
@property (retain, readwrite) NSMutableArray *users;
@property (retain, readwrite) NSMutableArray *items;
@property (retain, readwrite) NSMutableArray *allItems;

@end
