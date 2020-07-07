/**
 MasterViewController.m
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/

#import "KVAkulaDataController.h"
#import "KVTasksDataController.h"
#import "KVPrimeTableViewController.h"
#import "KVMapViewController.h"
#import "KDVPersonViewCell.h"

@interface KVPrimeTableViewController ()

@property (strong,nonatomic)CLLocationManager *LocationManager;
/**
 Akula PersonDataController
*/
@property (strong, nonatomic) KVPersonDataController *PDC;
/**
 Akula TaskDataController
*/
@property (strong, nonatomic) KVTasksDataController *TDC;
@property (weak,nonatomic)KVPerson* CurrentPerson;
//20200707
@property (weak,nonatomic)KDVPersonViewCell *pCell;
@end

@implementation KVPrimeTableViewController
@synthesize ADC =_ADC;
@synthesize PDC =_PDC;
@synthesize TDC =_TDC;
@synthesize LocationManager = _LocationManager;
@synthesize CurrentPerson = _CurrentPerson;
#pragma mark -

- (void)setupDataSource; {
  [[self PDC]setMOC:([[self ADC]MOC])];
  [[self PDC]setDelegate:(self)];
  [[self TDC]setMOC:([[self ADC]MOC])];
  [[self TDC]setDelegate:(self)];
}

#pragma mark - GUI Setup Logic.
/**

20200707@1200
okay
OKAY
 Part of this sweep is clearing out shitty old comments. that and organizing the code with more structure and the modules more closely coupled (by location - for understanding)
 THE Larger part is surfacing Bugs and UnImplemented Features
  like the table headers I can do is swift but in here are missing
 THE LARGEST PART Is Scoping and Intra-Process-Comms
and it seems strange but I think that this and the map are more closely coupled thatn it would appear at first and tath is good
THE Map and the TVC can both be on the screen at the same time ¡READ THAT AGAIN!
 
 But beyond the first two screens you are just dealing to a *RootEntity or whatnot and maybe a weak pointer to that objects Controller
 */


- (void)setupGUIState; {
  /**
  If this array is empty then this button should _at the very least_ be inactive
  */
  [[self navigationItem]setLeftBarButtonItem:[self editButtonItem]];

  UIBarButtonItem *addButton =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                target:self
                                                action:@selector(insertNewPerson:)];
  
  [[self navigationItem]setRightBarButtonItem:(addButton)];
  
  [self setMapViewController:(KVMapViewController *)[([[[self splitViewController] viewControllers] lastObject])topViewController]];
  
  [[self MapViewController]setTDC:(self.TDC)];

}

- (KVAkulaDataController *)ADC {
  if (!(_ADC)) _ADC = [[KVAkulaDataController alloc]initAllUp];
  return _ADC;
}

- (KVPersonDataController *)PDC {
  if (!(_PDC)) _PDC = [[KVPersonDataController alloc]initAllUp];
  return (_PDC);
}

- (KVTasksDataController *)TDC {
  if (!(_TDC)) _TDC = [[KVTasksDataController alloc]initAllUp];
  return (_TDC);
}

// FIXME: ¿Is CP S.P.O.T.?
-(KVPerson *)CurrentPerson {
  NSIndexPath* path = [[self tableView]indexPathForSelectedRow];
  KVPerson* person = [[self PDC]getAllEntities][path.row];
  return person;
  // TODO: Logic what if it is not selected?
  // If !cp : [[[self PDC]getAllEntities]first]
  // AND if BOTH are nil then make one
  //  [[self PDC]makeNewPersonInMOC:([[self PDC]MOC])];
  // or run setup()
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self MapViewController]setMA_Delegate:self];
  
  [self setupDataSource];
  
  [self setupCLManager];
  
  [self setupGUIState];
}

- (void)viewWillAppear:(BOOL)animated {
  [self setClearsSelectionOnViewWillAppear:([[self splitViewController]isCollapsed])];
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Insert Person

- (void)insertNewPerson:(id)sender {
  
  [[self tableView]reloadData];
  
  [self willAddPersonInDelegate:self];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  [self.tableView insertRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];

  [[self tableView]selectRowAtIndexPath:indexPath
                               animated:true
                         scrollPosition:UITableViewScrollPositionTop];
  if ([[self PDC]didSaveEntities] == false) {
    NSLog(@"pony sauce");
  }
  
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
  if ([[segue identifier] isEqualToString:@"showDetail"])  {
    KVMapViewController *mapView = (KVMapViewController *)[[segue destinationViewController] topViewController];

    [mapView setPDC:[self PDC]];
    [mapView setMA_Delegate:(self)];
    
    [mapView setCurrentEntity:[self CurrentPerson]];
    
  } else if ([[segue identifier] isEqualToString:@"showEULA"]) {
    NSLog(@"Preparing Application For First Run");
  }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger secCount = 3;
//  if (self.TDC) {
//    secCount++; // HEY I NEED A TASK's CELL (in the XIB) But you still wire thse UP FIRST
//  }
  return secCount; // Should be two going on three
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  /*  SET THIS TO A SWITCH  */

  
  if (section == 0) {
    return ([[[self PDC]getAllEntities]count]);
  } else if (section == 1) {
    return ([[[self TDC]getAllEntities]count]);
  }
  return (0);

}

/**
 Phase 01, make the logic to add the cell then refactor the "Cell" to "personCell" and "taskCell" then make these in the GUI - (Made a custom Cell)
 Phase 02, add the logical stubs for these and the section headers footers and
 Phase 03, Make a getAllEntities that ONLY GETS Tasks For Selected Person!!!
*/

// FIXME: IMPLEMENT viewForHeaderInSection DELEGATEƒ
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//  return nil;
//}
// FIXME: OK I See them but cannot show tasks they init as root-entities
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  __unused NSArray* aArr = [NSArray arrayWithArray:[[self ADC]getAllEntities]];
  __unused NSArray* tArr = [NSArray arrayWithArray:[[self TDC]getAllEntities]];
  NSLog(@"%lu :: %lu",(unsigned long)aArr.count,(unsigned long)tArr.count);


  
  if ([indexPath section] == 0) {
    //
    KDVPersonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"
                                                             forIndexPath:indexPath];
    KVPerson *p = [[self PDC]getAllEntities][indexPath.row];

    NSString *fullName = [[[p lastName]stringByAppendingString:(@" , ")]stringByAppendingString:[p firstName]];
    [[cell nameLabel]setText:fullName];
    [[cell captionLabel]setText:[[p incepDate]description]];
    return cell;
    
  }
  
  else if ([indexPath section] == 1)
  {
    
    UITableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    KVTask *t = [[self TDC]getAllEntities][indexPath.row];
    tCell.textLabel.text = [[t incepDate]description];
    return tCell;
  }
  else if ([indexPath section] == 2) {
    return (nil);
  }
  return (nil);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {

      [[self PDC]deleteEntity:([[[self PDC]getAllEntities]objectAtIndex:(indexPath.row)])];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if ([indexPath row] >= 0) {
      /**
       FIXME: - Select Row?
       A couple of things ALSO need to happen
       I need another selected row
       and the table view needs a new selected entity
       */
    }
    if ([[self PDC]didSaveEntities] == false) {
    }
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

#pragma mark - Map Functions

#pragma mark - Setup Location Manager

- (void)setupCLManager
{
  if (!(_LocationManager))
  {
    _LocationManager = [[CLLocationManager alloc]init];
  }
  [[self LocationManager]setDelegate:(self)];
  [self setupCLAuthState];
  //
  [[self LocationManager]setDistanceFilter:kCLDistanceFilterNone];
  [[self LocationManager]setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
  [[self LocationManager]startUpdatingLocation];
}

- (void)setupCLAuthState {
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
    [[self LocationManager]requestAlwaysAuthorization];
  }
}
/*  TODO: - Update Location */

- (void) findLocation {
  //
  CLLocationCoordinate2D coordinate = [[[self LocationManager]location]coordinate];
  NSLog(@"location ==> Latitude %6f\t %6f ",coordinate.latitude, coordinate.longitude);
  [self foundLocation];
  
}

- (void) foundLocation {
  [[self LocationManager]stopUpdatingLocation];
}

#pragma mark - CONFRMANCE === COMPLIANCE

- (void)willAddPersonInDelegate:(id<KVPersonData>)deli {
  [[self PDC]makeNewPersonInMOC:([[self PDC]MOC])];
  [self findLocation];
  CLLocationCoordinate2D coordinate = [[[self LocationManager]location]coordinate];
  
  KVPerson *p = [[[self PDC]getAllEntities]firstObject];
  
  [[p location]setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
  [[p location]setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
  
  [self foundLocation];
  
  NSLog(@"%@ : %@ ",p.location.latitude.description, p.location.longitude.description);
  //  [self updateEntityLocation:([p location])];//

}

- (BOOL)willAddTaskInDelegate:(id<KVTaskData>)deli {
  // Actually this needs to be my current P*
  KVPerson* person = [[[self PDC]getAllEntities]firstObject];
  //KVRootEntity *object = self.ADC.getAllEntities[indexPath.row];
  BOOL facts = nil;
  KVTask *task = [[self TDC]makeNewTaskInMOC:[[self TDC]MOC]];
//
//  if ([task taskOwner] != person) {
//    [task setTaskOwner:person];
//  }
//  if ([[person taskList]containsObject:task]) {
//    facts = false;
//  } else {
//    [person setTaskList:([NSSet setWithSet:[[person taskList]setByAddingObject:task]])];
//    [[self TDC]didSaveEntities];
//    facts = true;
//  }
//  [[self TDC]didSaveEntities];
  return (facts);
}

- (BOOL)didAddNewPersonFromDelegate:(id<KVMapActions>)deli {
  
  BOOL result = nil;
  
  [self findLocation];//
  
  [self willAddPersonInDelegate:self];
//  [[self MapViewController]setCurrentEntity:p];
//  __unused KVAbstractLocationEntity *tmpZ = [p location];

  result = [[self PDC]didSaveEntities];
//  [[self tableView]reloadData];
//  [[self MapViewController]setCurrentEntity:[[[self PDC]getAllEntities]firstObject]];
  [[self tableView]reloadData];
  
  return (result);
}

- (BOOL)didAddTask:(KVTask*)task To:(KVPerson*)person From:(id<KVMapActions>)delegate {
  BOOL facts = nil;
//  if (!task) {
//    KVTask *task = [[self TDC]makeNewTaskInMOC:[[self TDC]MOC]];
//  }
//  [[self TDC]didSaveEntities];
//  if ([task taskOwner] != person) {
//    [task setTaskOwner:person];
//  }
//  if ([[person taskList]containsObject:task]) {
//    facts = false;
//  } else {
//    [person setTaskList:([NSSet setWithSet:[[person taskList]setByAddingObject:task]])];
//    facts = true;
//  }
  return (facts);
}

- (BOOL)didChangePerson:(id<KVPersonData>)deli withPerson:(KVPerson *)p {
  BOOL st8 = FALSE;
  
  return (st8);
}
- (void)didlAddTaskFrom:(id)sender {
  // Actually this needs to be my current P*
//  KVTask *task =
//  [[self TDC]]
  [[self TDC]makeNewTaskInMOC:[[self TDC]MOC]];
//  [[self TDC]didSaveEntities];
  
  if ([[self TDC]didSaveEntities] == false) {
    NSLog(@"Lawn Loaves");
  }
//  return (false);
}


@end
