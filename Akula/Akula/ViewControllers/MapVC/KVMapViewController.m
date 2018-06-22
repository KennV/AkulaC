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

@end

@implementation KVMapViewController

- (void)configureView {
  // Update the user interface for the detail item.
  if (self.currentEntity) {
      self.entityDescriptionLabel.text = [self.currentEntity description];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupMapView];
  // Do any additional setup after loading the view, typically from a nib.
  [self configureView];
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
//TODO: add camera
- (void)setupMapView {
  [[self MapView]setDelegate:self];
//  MKMapCamera * cam = [[MKMapCamera alloc]init];
  
  [[self MapView]setMapType:MKMapTypeHybrid];
  [[self MapView]setShowsScale:false];

  if (self.currentEntity == nil ) {
    if (self.PDC.getAllEntities.firstObject) {
      [self setCurrentEntity:(self.PDC.getAllEntities.firstObject)];
    }
  } else {
    CLLocationCoordinate2D objLocation =
    CLLocationCoordinate2DMake([[[_currentEntity location]latitude]doubleValue],
                               [[[_currentEntity location]longitude]doubleValue]);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(objLocation, 500, 500);
    [[self MapView]setRegion:region animated:TRUE];
  }
  
//  [[self MapView]setNeedsDisplay];
  
//  [[self MapView]setCamera:cam];
}
#pragma mark - Setup Pin View

@end
