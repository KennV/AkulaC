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

20200707@1030
Yay I got suckered into Swift/SwiftUI and liked it less than I did before it seems to bee too much like a fun and easy way to build uninspired apps and SO I started to clone this in SwiftUI and didn't like it, so I was going to re-do it in Modern-ObjC but that was still all CopyPasta from my own work. So I took the most RECENT BITCH-FIX build and merged it into master. Then forked that out to 01-020 which is this. I do NOT have a buglist or a TODO for it and these need to be in place hella soon
20200708@1430
WELL That Was a Sprint and I just refactored the Protocol/Delegate to reflect a better appreciation of reality. (*and that old-ass-adage that 75% of programming is choosing the right names*)
So While I am not using SwiftUI I do Like the Idea of being able to bang out interfaces And the level of refactoring niceness is NOICE
 */
#import "KVMapViewController.h"

@interface KVMapViewController ()

- (void)setupButtonsForApplicationState;

@property(weak,nonatomic)IBOutlet UILabel *entityDescriptionLabel;

@property(weak,nonatomic)IBOutlet MKMapView *MapView;

@property(weak,nonatomic)KVPinItem *PinItem;

@property (weak, nonatomic) IBOutlet UIToolbar *ToolBar;

@end

@implementation KVMapViewController
@synthesize ADC = _ADC;
@synthesize TDC = _TDC;
@synthesize KVMapViewEntity = _KVMapViewEntity;
@synthesize entityDescriptionLabel = _entityDescriptionLabel;
@synthesize MapView = _MapView;
@synthesize PinItem = _PinItem;
@synthesize ToolBar = _ToolBar;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setCameraView:[[KVCameraViewController alloc]init]];
  if (!([[[self MapView]delegate] isEqual:(self)])) {
    [[self MapView]setDelegate:self];
  }
  
  [self setupGUIState];
  [self setupMapView];
//  [self setCameraView:[[KVCameraViewController alloc]initWithDataCon:(self.PDC) Persron:(KVPerson*)self.currentEntity]];

}

- (void)viewWillAppear:(BOOL)animated {
  [self configureView];

}

- (void)configureView {
  if ([self KVMapViewEntity]) {
    [[self entityDescriptionLabel]setText:[[self KVMapViewEntity]description]];
    [self setupMapViewWith:[self KVMapViewEntity]];
  }
  //CoreData: warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass
  // it does not happen here but it happens over there
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if (([[segue identifier] isEqualToString:@"ShowCameraView"])) {
    [[self CameraView]setTitle:(@"Camera")];
    [self setupCameraScene];
  }
/*
CAN I REUSE THAT NAME showEULA -> gotoEULA
*/
  if (([[segue identifier] isEqualToString:@"showEULA"])) {
    ;
  }
}

#pragma mark - Managing the detail item
/**
 my entity

 @param newEntity KVRootEntity
*/
- (void)setKVMapViewEntity:(KVRootEntity *)newEntity {
  if (_KVMapViewEntity != newEntity) {
    _KVMapViewEntity = newEntity;
    [[self CameraView]setCurrentPerson:(KVPerson*)_KVMapViewEntity];
  }
  //Always ConfView on Set?
  [self configureView];
}

#pragma mark - Setup GUI State

- (void)setupGUIState; {
  self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
  self.navigationItem.leftItemsSupplementBackButton = YES;
  self.CameraView = [[KVCameraViewController alloc]init];
}

- (void)setupCameraScene {
  [[self CameraView]setPDC:[self PDC]];
  KVPerson* p = (KVPerson*)[self KVMapViewEntity];
  [[self CameraView]setCurrentPerson:p];
}

- (void)setupButtonsForApplicationState {

}

#pragma mark BUGFIX: NEW VUE

- (IBAction)addPerson:(UIBarButtonItem *)sender {
  //TODO: MAKE A SELECTION BOUNCE BACK TO THE MAP
//  [[self MA_Delegate]]
  if ([[self KVMapDataSrc]didAddNewPersonFromDelegate:[self KVMapDataSrc]]) {
//    NSLog(@"Deli Powa");
  }
}

- (IBAction)addTaskForPerson:(UIBarButtonItem *)sender {
  [[self KVMapDataSrc]didAddTaskFrom:self];
}

#pragma mark - Improved

- (void)setupMapView {
  [[self MapView]setMapType:MKMapTypeStandard];
//  [[self MapView]setMapType:MKMapTypeHybrid]; //was MKMapTypeStandard
  [[self MapView]setShowsBuildings:(false)];
  [[self MapView]setShowsCompass:(false)];
  [[self MapView]setShowsPointsOfInterest:(true)];
  [[self MapView]setShowsScale:(true)];
  [[self MapView]setShowsTraffic:(false)];
  [[self MapView]setShowsUserLocation:(true)];
}

- (void)setupMapViewWith:(KVRootEntity*)currentEntity {
  
  [self setupMapView];
  
  CLLocationCoordinate2D center = CLLocationCoordinate2DMake(([[[currentEntity location]latitude]doubleValue]), ([[[currentEntity location]longitude]doubleValue]));
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 500, 500);
  
  [[self MapView]setRegion:region animated:false];
  [[self MapView]setCamera:[self setupMapCamAtLocation:(center)] animated:false];
  
  [self setupNotationPins];
}

- (MKMapCamera *)setupMapCamAtLocation:(CLLocationCoordinate2D)loc {
  MKMapCamera *cam = [[MKMapCamera alloc]init];
  [cam setPitch:(70)];
  [cam setAltitude:440];
  [cam setCenterCoordinate:loc];
  return (cam);
}

#pragma mark - Setup Pin View
- (void)setupNotationPins {
  /**
   I _bet_ this is where i get it wrong.
  */
  KVAkulaDataController *allDataCon = [[KVAkulaDataController alloc]init];

  NSArray *allItems = [allDataCon getAllEntities];

  for (KVRootEntity *e in allItems) {
//    ¿SHOULD I MAKE A pinItems[KVPinItem]???
    if ([e isMemberOfClass:[KVPerson class]]) {
      KVAbstractLocationEntity * l = e.location;
      CLLocationCoordinate2D loc2D = CLLocationCoordinate2DMake(l.latitude.doubleValue, l.longitude.doubleValue);

      KVPinItem *pin = [[KVPinItem alloc]initNewPinItemFor:e At:loc2D];
      [pin setTitle:[e hexID]];
//      NSLog(@"\n adding pin at: %.9f and %.9f", loc2D.latitude, loc2D.longitude);
      [[self MapView]addAnnotation:pin];
    }
    
    if ([e isMemberOfClass:[KVRootEntity class]]) {
      NSLog(@"Not an Impossible Pony");
    }

  }

}

@end
