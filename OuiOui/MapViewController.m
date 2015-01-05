//
//  MapViewController.m
//  OuiOui
//
//  Created by Paul Heijmans on 16-12-14.
//  Copyright (c) 2014 Vontura. All rights reserved.
//

#import "MapViewController.h"
#import "Parse/Parse.h"
#import "Annotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)viewDidAppear:(BOOL)animated{
    [self retrieveFollowers];
    
    // Get data
    [self retrieveData:@"false"];
    
    self.mapView.delegate = (id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)retrieveFollowers{
    
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get followers query
    PFQuery *followers = [PFQuery queryWithClassName:@"Follow"];
    [followers whereKey:@"user1" equalTo:user];
    
    [followers orderByDescending:@"createdAt"];
    
    [followers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            self.followersArray = [[NSMutableArray alloc] initWithArray:objects];
            
            // Set object id's in array
            NSMutableArray *rawData=[NSMutableArray new];
            [rawData addObject:user];
            for (int i = 0; i < [self.followersArray count]; i++){
                [rawData addObject:[[self.followersArray objectAtIndex:i] valueForKey:@"user2"]];
            }
            self.users = rawData;
        }
    }];
}


-(void)retrieveData:(NSString *)inputType{
    
    // Get current user
    PFUser *user = [PFUser currentUser];
    
    // Get ouiItems query
    PFQuery *ouiItems = [PFQuery queryWithClassName:@"OuiItem"];
    
    if(self.followersArray){
        [ouiItems whereKey:@"user" containedIn:self.users];
    }else{
        [ouiItems whereKey:@"user" equalTo:user];
    }
    
    // Check if type is true
    if([inputType isEqualToString:@"true"]){
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:YES]];
    }else{
        [ouiItems whereKey:@"checked" equalTo:[NSNumber numberWithBool:NO]];
    }
    
    [ouiItems orderByDescending:@"createdAt"];
    [ouiItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects){
            
            // Array voor alle locaties in te stoppen
            NSMutableArray *locations = [[NSMutableArray alloc] init];
            
            // Set objects in ouItemsDB array
            self.items = [[NSMutableArray alloc] initWithArray:objects];

            // Maak locatie aan
            CLLocationCoordinate2D location;
            
            // Maak myAnn aan
            Annotation *myAnn;
            
            // Doorlopen van alle verkregen data
            for(NSDictionary *data in self.items){
 
                if([data objectForKey:@"latitude"] && [data objectForKey:@"longitude"]){
                    
                    // Set locatie in longitude en latitude
                    location.latitude = [[data objectForKey:@"latitude"] floatValue];
                    location.longitude = [[data objectForKey:@"longitude"] floatValue];
                    
                    // Set data van ann
                    myAnn = [[Annotation alloc] init];
                    myAnn.coordinate = location;
                    myAnn.title = [data objectForKey:@"title"];
                    
                    self.allItems = [NSMutableArray array];
                    [self.allItems addObject:[data objectForKey:@"longitude"]];
                    [locations addObject:myAnn];
                  
                    [self.mapView addAnnotations:locations];
                }
            }
        }
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[annotation class]]){
        
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        // Set marker voor supermarkten
        CGSize imageSize = CGSizeMake(45, 50);
        UIGraphicsBeginImageContext(imageSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [pinView.image = [UIImage imageNamed:@"annotationIcon"] drawInRect:imageRect];

        if (!pinView){
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.canShowCallout = YES;
            pinView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndPDFContext();
            // If appropriate, customize the callout by adding accessory views (code not shown).
        }
        else
            pinView.annotation = annotation;
        pinView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndPDFContext();
        return pinView;
    }
    
    return nil;
}



@end
