/**
 MasterViewController.m
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/

/**
Okay this is where the rubber meets the road.

- I have an NSMutableArray of objects
- This needs to be an NSArray of RootEntities or better
 - Non Mutable

 
Hella trippy
• I thought I had a bug,
• Worse YET I don't have a save() routine in here so I can't tell if I am writing to a real db. B\C I am not even working with a db in this state of the template.

*thus* the next step is to write a save function

I NEED +Colors and effects, {See Accesessory Views Folder}
 
isVisibleIfYes(Bool)

Different Types of controllers for sections
number of sections
 (* OIC *)
 sectionCount. { %KVCDataCon%:getAllEntities.count}

THEN after all of that I might want a protocol for this controller. Jeppers

WOW I thought I did a commit, I was about to add an appDataCon and probably a getter for akulaEntities helping me decide if it is mutable or not.

*/

#import "KVPrimeTableViewController.h"
#import "KVMapViewController.h"

@interface KVPrimeTableViewController ()

// HEY THIS switched from mutable akulaEntities to the product of an extensible array
@property (weak, nonatomic)NSArray *akulaEntities;
/// Groovy Location Sense
@property (strong,nonatomic)CLLocationManager *locationManager;

// so for expediancy I made a cheap CLUT without the table or dict even
@property (weak,nonatomic)UIColor* baseColor00;
@property (weak,nonatomic)UIColor* baseColor01;
@property (weak,nonatomic)UIColor* baseColor02;
@property (weak,nonatomic)UIColor* baseColor03;

@property (weak,nonatomic)UIColor* tableSectionColor;
@property (weak,nonatomic)UIColor* tableBackgroundColor;
@property (weak,nonatomic)UIColor* tableAltBackgroundColor;
@property (weak,nonatomic)UIColor* tableSectionTextColor;

@property (weak,nonatomic)UIColor* buttonBaseColor;
@property (weak,nonatomic)UIColor* buttonSelectedColor;
@property (weak,nonatomic)UIColor* buttonTextColor;
@property (weak,nonatomic)UIColor* buttonTextAltColor;

@property (weak,nonatomic)UIColor* altTextColor;
@property (weak,nonatomic)UIColor* baseTextColor;
@property (weak,nonatomic)UIColor* hilightTextColor;
@property (weak,nonatomic)UIColor* specialTextColor;
//I expect that these will also be refactored into sensible names


@end

@implementation KVPrimeTableViewController

@synthesize ADC = _ADC;
@synthesize PDC =_PDC;
@synthesize akulaEntities = _akulaEntities;
@synthesize locationManager = _locationManager;
// Them colors
@synthesize baseColor00 = _baseColor00;
@synthesize baseColor01 = _baseColor01;
@synthesize baseColor02 = _baseColor02;
@synthesize baseColor03 = _baseColor03;

@synthesize tableSectionColor = _tableSectionColor;
@synthesize tableBackgroundColor = _tableBackgroundColor;
@synthesize tableAltBackgroundColor = _tableAltBackgroundColor;
@synthesize tableSectionTextColor = _tableSectionTextColor;

@synthesize buttonBaseColor = _buttonBaseColor;
@synthesize buttonSelectedColor = _buttonSelectedColor;
@synthesize buttonTextColor = _buttonTextColor;
@synthesize buttonTextAltColor = _buttonTextAltColor;

@synthesize altTextColor = _altTextColor;
@synthesize baseTextColor = _baseTextColor;
@synthesize hilightTextColor = _hilightTextColor;
@synthesize specialTextColor = _specialTextColor;


#pragma mark - DataSource
/**
 */

- (NSArray *)akulaEntities {
  return([[self ADC] getAllEntities]);
}
- (KVAkulaDataController *)ADC {
  if (!(_ADC)) _ADC = [[KVAkulaDataController alloc]initAllUp];
  
  return _ADC;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // TODO: Customization Point for this controller
  self.navigationItem.leftBarButtonItem = self.editButtonItem;

  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
//  self.mapViewController =
  [self setMapViewController:(KVMapViewController *)[[self.splitViewController.viewControllers lastObject] topViewController]];
  [self setupCLManager];
}

- (void)viewWillAppear:(BOOL)animated {
  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
// TODO: - Replace This with a controller function preferably from a delegate
- (void)insertNewObject:(id)sender {
//[[self PDC]createPersoninMOC:[[self ADC]MOC]];
  [self.ADC createEntityInMOC:[self.ADC MOC]];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    KVRootEntity *object = self.ADC.getAllEntities[indexPath.row];
    KVMapViewController *mapView = (KVMapViewController *)[[segue destinationViewController] topViewController];
    [mapView setMA_Delegate:(self)];
    [mapView setCurrentEntity:object];
    mapView.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    mapView.navigationItem.leftItemsSupplementBackButton = YES;
  }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1; // Should be three
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self akulaEntities]count];
}
  // TODO: - Make a correct Custom Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  KVRootEntity *object = [self akulaEntities][indexPath.row];
  cell.textLabel.text = [[object incepDate]description];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
//    KVRootEntity *deletrix = [[self akulaEntities]objectAtIndex:(indexPath.row)];
//    [ADC deleteEntity:deletrix];
    [[self ADC]deleteEntity:[[self akulaEntities]objectAtIndex:(indexPath.row)]];
//      [self.akulaEntities removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([[self ADC]didSaveEntities]) {
      
    }
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

#pragma mark - Map Functions
- (void) setupCLManager
{
  if (!(_locationManager))
  {
    _locationManager = [[CLLocationManager alloc]init];
  }
  [[self locationManager]setDelegate:(self)];
  [self setupCLAuthState];
  //
  [[self locationManager]setDistanceFilter:kCLDistanceFilterNone];
  [[self locationManager]setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
  [[self locationManager]startUpdatingLocation];
}

- (void)setupCLAuthState {
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
    [[self locationManager]requestAlwaysAuthorization];
  }
}

- (void) findLocation {
  //
  
}
- (void) foundLocation {
  
}

@end
