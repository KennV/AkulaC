/**
 DetailViewController.m
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/

#import "KVMapViewController.h"

@interface KVMapViewController ()

- (void)setupButtonsForApplicationState;
- (void)setupGUIForApplicationState;
- (void)setupMapGUIState;

@property(weak,nonatomic)IBOutlet UILabel *entityDescriptionLabel;

@property(weak,nonatomic)IBOutlet MKMapView *MapView;

@property(weak,nonatomic)KVPinView *AnnotationView;


@end

@implementation KVMapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupGUIState];
  [self setupMapView];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
  [self setupMapGUIState];
  [self configureView];
}

- (void)configureView {
  // Update the user interface for the detail item.
  if (self.currentEntity) {
    self.entityDescriptionLabel.text = [self.currentEntity description];
    [self setupNotationPins];
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
    // Update the view.
//    [self configureView];
  }
}

#pragma mark - Setup GUI State
- (void)setupGUIState; {
  self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  
  self.navigationItem.leftItemsSupplementBackButton = YES;
  NSLog(@"~sup GUI\n");
}

- (void)setupButtonsForApplicationState; {
  NSLog(@"~sup Buttons\n");
}

- (void)setupGUIForApplicationState; {
  //toolbar
  //back/breadcrumb button (to Master)
  //keyed segues
  NSLog(@"~sup GUI for State\n");
}

#pragma mark - Setup Map View

- (void)setupMapGUIState; {
  [[self MapView]setDelegate:self];
  MKMapCamera * cam = [[MKMapCamera alloc]init];
  
  [[self MapView]setMapType:MKMapTypeStandard]; //was MKMapTypeHybrid
  [[self MapView]setShowsScale:false];

  [[self MapView]setCamera:cam];
}

- (void)setupMapView {
  
  if (self.currentEntity == nil ) {
    if (self.PDC.getAllEntities.firstObject) {
      [self setCurrentEntity:(self.PDC.getAllEntities.firstObject)];
    }
  } else {
    // We do have a proper currentEntity
    CLLocationCoordinate2D objLocation =
    CLLocationCoordinate2DMake([[[_currentEntity location]latitude]doubleValue],
                               [[[_currentEntity location]longitude]doubleValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(objLocation, 500, 500);
    // ¿bp? ## Observer that at this point the _currEnt is fully fetched with no faults
    [[self MapView]setRegion:region animated:TRUE];
  }
  
}

#pragma mark - Setup Pin View
- (void)setupNotationPins {
  KVAkulaDataController *allDataCon = [[KVAkulaDataController alloc]init];

  NSArray *jiveArr = allDataCon.getAllEntities;

  for (KVRootEntity *jiveItem in jiveArr) {
    
    CLLocationCoordinate2D pinLoc =
    CLLocationCoordinate2DMake([[[jiveItem location]latitude]doubleValue],
                               [[[jiveItem location]longitude]doubleValue]);
    
    if ([jiveItem isKindOfClass:[KVRootEntity class]]) {
      NSLog(@"I am a Kind of Root Entity");
    }
    if ([jiveItem isMemberOfClass:[KVPerson class]]) {
      NSLog(@"Specifically a Person\n");
      NSLog(@"@ %.6f and %.6f", pinLoc.latitude, pinLoc.longitude);
    }
    if ([jiveItem isMemberOfClass:[KVRootEntity class]]) {
      NSLog(@"Not an Impossible Pony");
    }
  }
}

@end
