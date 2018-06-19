/**
 DetailViewController.h
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas
 
*/
#import "Akula+CoreDataModel.h"
/*
 Currently these will be optional
 I STRONGLY SUSPECT that I will be implementing these in the actual controller for person; Or that somehow, and likely quite obvious; I will be a delegate of a delegate in this
 _Theory-WIse_ what it is, is that I have all of the basic db-like functions {actual or swift-proto's} but that is not what the application is. It is the actual behavior of these things. AND I certainly do not want to be doing these here. Rather I should be hitting them off in the ClassController [20180619@1100]
 */
@protocol MapViewActionsProtocol

@optional


- (bool)didChangePerson:(id<MapViewActionsProtocol>)deli withPerson:(KVPerson*)p;

- (void)willRunSetupFrom:(id<MapViewActionsProtocol>)deli;

@end


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KVPrimeTableViewController.h"


@interface KVMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) id<MapViewActionsProtocol> MA_Delegate;
@property (strong, nonatomic) KVRootEntity *currentEntity;
@property (weak, nonatomic) IBOutlet UILabel *entityDescriptionLabel;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@end

