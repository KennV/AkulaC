/**
 DetailViewController.m
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/

#import "KVMapViewController.h"
#import "KVPinItem.h"

@interface KVMapViewController ()

- (void)setupButtonsForApplicationState;

@property(weak,nonatomic)IBOutlet UILabel *entityDescriptionLabel;

@property(weak,nonatomic)IBOutlet MKMapView *MapView;

@property(weak,nonatomic)KVPinItem *PinItem;

@property (weak, nonatomic) IBOutlet UIToolbar *ToolBar;

@end


@implementation KVMapViewController
@synthesize currentEntity = _currentEntity;
@synthesize entityDescriptionLabel = _entityDescriptionLabel;
@synthesize MapView = _MapView;
@synthesize PinItem = _PinItem;
@synthesize ToolBar = _ToolBar;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupGUIState];
  [self setupMapView];

}

- (void)viewWillAppear:(BOOL)animated {
  [self configureView];
}

- (void)configureView {
  // Update the user interface for the detail item.
  if (self.currentEntity) {
    self.entityDescriptionLabel.text = [self.currentEntity description];
//    if (!(_MapView)) [self setupMapView];
    [self setupMapView];
//    [self setupNotationPins];
  }
}

#pragma mark - Managing the detail item
/**
 my entity

 @param newEntity KVRootEntity
*/
- (void)setCurrentEntity:(KVRootEntity *)newEntity {
  if (_currentEntity != newEntity) {
    //
    // set a private location here.
    //
    _currentEntity = newEntity;
    // Update the view.
    [self configureView];
  }
}

#pragma mark - Setup GUI State
- (void)setupGUIState; {
  self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  self.navigationItem.leftItemsSupplementBackButton = YES;

}

- (void)setupButtonsForApplicationState; {
//  NSLog(@"~sup Buttons\n");

}

// #pragma mark - Setup Map View

- (void)setupMapView {
  [[self MapView]setDelegate:self];
  MKMapCamera * cam = [[MKMapCamera alloc]init];
  
  [[self MapView]setMapType:MKMapTypeHybrid]; //was MKMapTypeStandard
//  [[self MapView]setShowsBuildings:(FALSE)];
//  [[self MapView]setShowsCompass:(TRUE)];
//  [[self MapView]setShowsPointsOfInterest:(FALSE)];
//  [[self MapView]setShowsScale:(TRUE)];
//  [[self MapView]setShowsTraffic:(TRUE)];
//  [[self MapView]setShowsUserLocation:(TRUE)];
  
  if (self.currentEntity == nil ) {
    if (self.PDC.getAllEntities.firstObject) {
    }
  } else {
    [self setCurrentEntity:(self.PDC.getAllEntities.firstObject)];
    // We do have a proper currentEntity
    CLLocationCoordinate2D objLocation =
    CLLocationCoordinate2DMake([[[_currentEntity location]latitude]doubleValue],
                               [[[_currentEntity location]longitude]doubleValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(objLocation, 500, 500);
    // ¿bp? ## Observer that at this point the _currEnt is fully fetched with no faults
    [self setupNotationPins];
    [[self MapView]setRegion:region animated:TRUE];
  }
  [[self MapView]setCamera:cam];

}

#pragma mark - Setup Pin View
- (void)setupNotationPins {
  KVAkulaDataController *allDataCon = [[KVAkulaDataController alloc]init];

  NSArray *allItems = allDataCon.getAllEntities;

  for (KVRootEntity *e in allItems) {
    
    if ([e isKindOfClass:[KVRootEntity class]]) {

      
    }
    if ([e isMemberOfClass:[KVPerson class]]) {

      CLLocationCoordinate2D loc2D =
      CLLocationCoordinate2DMake([[[e location]latitude]doubleValue],
                                 [[[e location]longitude]doubleValue]);
      NSLog(@"\n@ %.6f and %.6f", loc2D.latitude, loc2D.longitude);
      KVPinItem *pin = [[KVPinItem alloc]initNewPinItemFor:e At:loc2D];
//      NSLog(@"\n adding pin \n");
      [[self MapView]addAnnotation:pin];
    }
    if ([e isMemberOfClass:[KVRootEntity class]]) {
      NSLog(@"Not an Impossible Pony");
    }
  }
//  mapView.addAnnotation(pin);
  

}

@end
