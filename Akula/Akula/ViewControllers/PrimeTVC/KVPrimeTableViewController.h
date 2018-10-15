/**
 MasterViewController.h
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas
 
*/

#import <UIKit/UIKit.h>
//
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class KVMapViewController;
@class KVTasksDataController;
@class KVAkulaDataController;

#import "KVMapViewController.h"

@interface KVPrimeTableViewController : UITableViewController <CLLocationManagerDelegate, MapViewActionsProtocol,PersonActionProtocol,TasksActionProtocol>

@property (strong, nonatomic) KVMapViewController *MapViewController;

/**
 Akula AllDataController
 */
@property (strong, nonatomic) KVAkulaDataController *ADC;
//@property (strong, nonatomic) KVPersonDataController *PDC;



@end

