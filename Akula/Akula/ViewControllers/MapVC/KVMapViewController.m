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

@property(weak,nonatomic)IBOutlet UILabel *entityDescriptionLabel;

@property(weak,nonatomic)IBOutlet MKMapView *MapView;

@end

@implementation KVMapViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupMapView];
  // Do any additional setup after loading the view, typically from a nib.
  [self configureView];
//  if (!(self.view.isHidden)) {
//    NSLog(@"\nBlink\n");
//  }
}

- (void)configureView {
  // Update the user interface for the detail item.
  if (self.currentEntity) {
    self.entityDescriptionLabel.text = [self.currentEntity description];
    [self setupNotationPins];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
    [self configureView];
  }
}

#pragma mark - Setup GUI State

#pragma mark - Setup Map View

- (void)setupMapView {
  [[self MapView]setDelegate:self];
  MKMapCamera * cam = [[MKMapCamera alloc]init];
  
  [[self MapView]setMapType:MKMapTypeStandard]; //was MKMapTypeHybrid
  [[self MapView]setShowsScale:false];

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
  
//  [[self MapView]setNeedsDisplay];
  
  [[self MapView]setCamera:cam];
}

#pragma mark - Setup Pin View
- (void)setupNotationPins {
  KVAkulaDataController *allDataCon = [[KVAkulaDataController alloc]init];

  NSArray *jiveArr = allDataCon.getAllEntities;

  for (KVRootEntity *jiveItem in jiveArr) {
    if ([jiveItem isKindOfClass:[KVRootEntity class]]) {
      NSLog(@"I am a Kind of Root Entity");
    }
    if ([jiveItem isMemberOfClass:[KVPerson class]]) {
      NSLog(@"Specifically a Person\n");
    }
    if ([jiveItem isMemberOfClass:[KVRootEntity class]]) {
      NSLog(@"Not an Impossible Pony");
    }
  }
}

@end
