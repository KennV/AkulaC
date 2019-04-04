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

*/

#import "KVAkulaDataController.h"
#import "KVTasksDataController.h"
#import "KVPrimeTableViewController.h"
#import "KVMapViewController.h"

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
// making this private here affects test lines:482…492
@property (weak,nonatomic)KVPerson* CurrentPerson;
@end

@implementation KVPrimeTableViewController

@synthesize ADC =_ADC;
@synthesize PDC =_PDC;
@synthesize TDC =_TDC;

@synthesize LocationManager = _LocationManager;
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

@synthesize CurrentPerson = _CurrentPerson;
#pragma mark - DataSource
/**
 */
/**
dont look to if:else
look to if(n==True)
if(n==False)
more molecular, more modular
*/
/**
Now Where the Rubber Meets the Road;
AAMOF it is a refactoring and long awaited. I need the current visible TVueSection to be hte currentGuy OKizzily
#BUUUT# then there are second and third order display / report effects
CHIEFLY - UNSET 4 pin's title
*/
- (void)setupAppState; {
  
}
/**
Additional to this I need to
 keep the ADC Private
 moave the person to another ivar
 have person gen a qname
 have pin exec a hexname
And about 3 more for 7 - 10 -/+1 features
#BEFORE ANY FUK'N INTEGRATION!??!??!#
@MAD_AF
*/
- (void)setupDataSource; {
  [[self PDC]setMOC:([[self ADC]MOC])];
  [[self PDC]setDelegate:(self)];
  [[self TDC]setMOC:([[self ADC]MOC])];
  [[self TDC]setDelegate:(self)];
}

#pragma mark - GUI Setup Logic.

/**
 Okay, if the array is empty then the '+' button Should read setup
 BOTH HERE AND -SetupMode in the MapView
 
 Set up the left/edit button the right/addPerson button
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
  /**
  ALSO this should be a local addButton/RightBarButtonItem No, a Right_Side_BarButtonItem : RightBarButtonItem
  THEN attach Similar Logic
  */
  [[self navigationItem]setRightBarButtonItem:(addButton)];
  
  [self setMapViewController:(KVMapViewController *)[[[[self splitViewController]viewControllers] lastObject] topViewController]];
  [[self MapViewController]setMA_Delegate:(self)];
  /**
  LASTLY Call a Similar Setup on the Map View - either by Jive or Delegate, It just needs to do what tricorder:Swift does for setupButton and Jive
  */
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

  //TODO: - Need a fuckin  Current Person!

-(KVPerson *)CurrentPerson {
  NSIndexPath* path = [[self tableView]indexPathForSelectedRow];
  KVPerson* person = [[self PDC]getAllEntities][path.row];
  return person;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //see ALSO: Conformance is Compliance
  [[self MapViewController]setMA_Delegate:self];
  
  [self setupDataSource];
  
  [self setupCLManager];
  
  [self setupGUIState];
  
}

- (void)viewWillAppear:(BOOL)animated {
  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Insert Person

- (void)insertNewPerson:(id)sender {
  // reload here
  [[self tableView]reloadData];
  /**
  if ([self didAddNewPersonFromDelegate:self]) {
  This will error here because of the number of rows in the VC is Invalid / Inconsistant
  }
  */
  [self willAddPersonInDelegate:self];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

  [[self tableView]selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
  if ([[segue identifier] isEqualToString:@"showDetail"])  {
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    KVRootEntity *object = [[self ADC]getAllEntities][indexPath.row];
    KVMapViewController *mapView = (KVMapViewController *)[[segue destinationViewController] topViewController];
// FIXME: _ALWAYS_USE_PDC_ in Map View
    [mapView setPDC:[self PDC]];
    [mapView setMA_Delegate:(self)];
    [mapView setCurrentEntity:[self CurrentPerson]];
    
  } else if ([[segue identifier] isEqualToString:@"showEULA"]) {
    NSLog(@"Preparing Application For First Run");
  }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger secCount = 1;
  if (self.TDC) {
    secCount++; // HEY I NEED A TASK's CELL (in the XIB) But you still wire thse UP FIRST
  }
  return secCount; // Should be three
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (section == 0) {
    return ([[[self PDC]getAllEntities]count]);
  } else if (section == 1) {
    return ([[[self TDC]getAllEntities]count]);
  }
  return (0);

}
//FIXME: - Make a correct Custom Cell
/**
 Phase 01, make the logic to add the cell then reaf the "Cell" to "personCell" and "taskCell" then make these in the GUI
 Phase 02, add the logical stubs for these and the section headers footers and
 Phase 03, Make a getAllEntities that ONLY GETS Tasks For Selected Person!!!
 
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if ([indexPath section] == 0) {
    //
    UITableViewCell *pCell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
    
    KVPerson *p = [[self PDC]getAllEntities][indexPath.row];
    /** Always set the MapView's entity to the current one
     */
    [[self MapViewController]setCurrentEntity:p];
    NSString *t1 = [[[p lastName]stringByAppendingString:(@" , ")]stringByAppendingString:[p firstName]];
    [[pCell textLabel]setText:t1];
    
    return pCell;
  } else if ([indexPath section] == 1)
  {
    UITableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    KVTask *t = [[self TDC]getAllEntities][indexPath.row];
    tCell.textLabel.text = [[t incepDate]description];
    return tCell;
  }  else if ([indexPath section] == 2) {
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
    id deletrix = [[[self PDC]getAllEntities]objectAtIndex:(indexPath.row)];

    if (deletrix != nil) {
      //NSLog(@"Deleting %@ at index %ld", [deletrix description],(long)indexPath.row);
      [[self PDC]deleteEntity:(deletrix)];
      
    } else {
      NSLog(@"Error trying to delete Nil-Item");
    }
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
//TODO: - Update Location

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

/*
 Actually by stubbing out these two fairly useless callbacks I am able to get a lot of extra work done
 There will be a branch to sort of explore what I can really do with a callback versus what I can do with a block
 
Or optionally as a non-optional protocol what can I do `didAddNewPersonFor:deli` is a great example And I wrote this definfition before writing the declaration and tested it before using it
 ~ in theory it shoult not affect my coverage (it went from practical 59 to practical 56) because this new code is wrapped in results. I am testing the behavior
 
 */
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

  if ([task taskOwner] != person) {
    [task setTaskOwner:person];
  }
  if ([[person taskList]containsObject:task]) {
    facts = false;
  } else {
    [person setTaskList:([NSSet setWithSet:[[person taskList]setByAddingObject:task]])];
    [[self TDC]didSaveEntities];
    facts = true;
  }
  [[self TDC]didSaveEntities];
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
  [[self MapViewController]setCurrentEntity:[[[self PDC]getAllEntities]firstObject]];
  [[self tableView]reloadData];
  
  return (result);
}

- (BOOL)didAddTask:(KVTask*)task To:(KVPerson*)person From:(id<KVMapActions>)delegate {
  BOOL facts = nil;
//  if (!task) {
//    KVTask *task = [[self TDC]makeNewTaskInMOC:[[self TDC]MOC]];
//  }
  [[self TDC]didSaveEntities];
  if ([task taskOwner] != person) {
    [task setTaskOwner:person];
  }
  if ([[person taskList]containsObject:task]) {
    facts = false;
  } else {
    [person setTaskList:([NSSet setWithSet:[[person taskList]setByAddingObject:task]])];
    facts = true;
  }
  return (facts);
}

- (BOOL)didChangePerson:(id<KVPersonData>)deli withPerson:(KVPerson *)p {
  BOOL st8 = FALSE;
  
  return (st8);
}

@end
