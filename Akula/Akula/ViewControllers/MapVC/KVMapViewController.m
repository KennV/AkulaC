/**
 DetailViewController.m
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/
/**
A Few things are missing in here

FIRST OF ALL, the map view centers somplace 00.00,00.00 and it renders at the correct place so that is one to FUCKING FIX YESTERDAY
~hell there are obviusly other items but I have recently moved development back onto the phone and it is better.
OKAY before I make a nav controller I need to decide what gets pitched up to there and part of it would be the behavior of the detail view which is currently this but should be better utilized as one of MANY possible segues.
 ~rather than build that I will continue to abstract this
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
  if (!([[[self MapView]delegate] isEqual:(self)])) {
    [[self MapView]setDelegate:self];
    /**
     It is set in the XIB but it makes sense to failsafe it here
     */
  }
  [self setupGUIState];

}

- (void)viewWillAppear:(BOOL)animated {
  [self configureView];
}

- (void)configureView {
  if ([self currentEntity]) {
    [[self entityDescriptionLabel]setText:[[self currentEntity]description]];
    [self setupMapViewWith:[self currentEntity]];
  }
}

#pragma mark - Managing the detail item
/**
 my entity

 @param newEntity KVRootEntity
*/
- (void)setCurrentEntity:(KVRootEntity *)newEntity {
  if (_currentEntity != newEntity) {
    _currentEntity = newEntity;
    [self configureView];
  }
}

#pragma mark - Setup GUI State

- (void)setupGUIState; {
  self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)setupButtonsForApplicationState; {

}

#pragma mark BUGFIX: NEW VUE

#pragma mark - Improved

- (void)setupMapView {

  [[self MapView]setMapType:MKMapTypeHybrid]; //was MKMapTypeStandard
  [[self MapView]setShowsBuildings:(FALSE)];
  [[self MapView]setShowsCompass:(FALSE)];
  [[self MapView]setShowsPointsOfInterest:(FALSE)];
  [[self MapView]setShowsScale:(FALSE)];
  [[self MapView]setShowsTraffic:(FALSE)];
  [[self MapView]setShowsUserLocation:(TRUE)];
}

- (void)setupMapViewWith:(KVRootEntity*)currentEntity {
  
  [self setupMapView];
  
  CLLocationCoordinate2D center = CLLocationCoordinate2DMake(([[[currentEntity location]latitude]doubleValue]), ([[[currentEntity location]longitude]doubleValue]));
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 500, 500);
  
  [self setupNotationPins];
  
  [[self MapView]setRegion:region animated:FALSE];
  
  [[self MapView]setCamera:[self makeCameraWithLocation:center] animated:FALSE];
}

- (MKMapCamera*)makeCameraWithLocation:(CLLocationCoordinate2D)loc {
  MKMapCamera * cam = [[MKMapCamera alloc]init];
  cam.centerCoordinate = loc;

  return cam;
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
      NSLog(@"\n adding pin \n");
      [[self MapView]addAnnotation:pin];
    }
    if ([e isMemberOfClass:[KVRootEntity class]]) {
      NSLog(@"Not an Impossible Pony");
    }

  }

}

@end
