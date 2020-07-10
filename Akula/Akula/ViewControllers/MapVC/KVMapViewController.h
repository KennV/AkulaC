/**
 DetailViewController.h
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas
 
*/

#import "KVPinItem.h"
#import "Akula+CoreDataModel.h"
#import "KVPersonDataController.h"

@protocol KDVMapDataProtocol

/**
 
 AHAHAHAHAHAH
 JustChange The Name To KDVMapDataProtocol
 AANNDDDDD
 Use it to supply these Arrays
 
 */

- (BOOL)didAddNewPersonFromDelegate:(id<KDVMapDataProtocol>)deli;

- (void)didAddTaskFrom:(id)sender;

@optional
- (BOOL)didAddTask:(KVTask*)task To:(KVPerson*)person From:(id<KDVMapDataProtocol>)delegate;
-(void)willRunSetupFrom:(id<KDVMapDataProtocol>)deli;

@end

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KVPrimeTableViewController.h"
#import "KVCameraViewController.h"
#import "KVPinItem.h"

@interface KVMapViewController : UIViewController <MKMapViewDelegate>
//
@property(strong, nonatomic)id <KDVMapDataProtocol> KVMapDataSrc;
@property (strong, nonatomic) KVAkulaDataController *ADC;
@property (strong, nonatomic) KVPersonDataController *PDC;
@property (strong, nonatomic) KVTasksDataController *TDC;

@property(strong,nonatomic)KVRootEntity *KVMapViewEntity;

@property (strong, nonatomic)KVCameraViewController* CameraView;

- (void)setupGUIState;
- (void)setKVMapViewEntity:(KVRootEntity *)newEntity;

@end

