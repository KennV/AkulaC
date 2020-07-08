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

@protocol KVMapActions

/**
 Currently these will be optional
 I STRONGLY SUSPECT that I will be implementing these in the actual controller for person; Or that somehow, and likely quite obvious; I will be a delegate of a delegate in this
 _Theory-WIse_ what it is, is that I have all of the basic db-like functions {actual or swift-proto's} but that is not what the application is. It is the actual behavior of these things. AND I certainly do not want to be doing these here. Rather I should be hitting them off in the ClassController [20180619@1100]
 OK I have a nice and tidy API here that is actually implemented in the parent controller and it will be shunted over to the Nav controller when this level of matutrity is warrented, but that is not the point at this time. the actual thing is that _future_chain_ meand that didAddNewPerson… MUST be a PDC.delegate and I must conform to it
 today it is not an issue but soon it will be.
 */

- (BOOL)didAddNewPersonFromDelegate:(id<KVMapActions>)deli;

- (void)didAddTaskFrom:(id)sender;

- (BOOL)didAddTask:(KVTask*)task To:(KVPerson*)person From:(id<KVMapActions>)delegate;
@optional

//- (void)willRunSetupFrom:(id<MapViewActionsProtocol>)deli;

@end

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KVPrimeTableViewController.h"
#import "KVCameraViewController.h"
#import "KVPinItem.h"

@interface KVMapViewController : UIViewController <MKMapViewDelegate>
//
@property(strong, nonatomic)id <KVMapActions> MA_Delegate;

@property (strong, nonatomic) KVAkulaDataController *ADC;
@property (strong, nonatomic) KVPersonDataController *PDC;
@property (strong, nonatomic) KVTasksDataController *TDC;


@property(strong,nonatomic)KVRootEntity *currentEntity;

@property (strong, nonatomic)KVCameraViewController* CameraView;

- (void)setupGUIState;
- (void)setCurrentEntity:(KVRootEntity *)newEntity;
@end

