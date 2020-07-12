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
#import "KDVBasicViewCell.h"

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
@property (weak,nonatomic)KVPerson* selectedPerson;
//20200707
@property (weak,nonatomic)KDVBasicViewCell *pCell;
@end

@implementation KVPrimeTableViewController
@synthesize ADC =_ADC;
@synthesize PDC =_PDC;
@synthesize TDC =_TDC;
@synthesize LocationManager = _LocationManager;
@synthesize selectedPerson = _selectedPerson;
#pragma mark -
// TODO: Test & Verify
- (void)setupDataSource; {
  [[self PDC]setMOC:([[self ADC]MOC])];
  [[self PDC]setDelegate:(self)];
  [[self TDC]setMOC:([[self ADC]MOC])];
  [[self TDC]setDelegate:(self)];
}

#pragma mark - GUI Setup Logic.
/**
20200707@1200

 A CORRECT BRANCH
 (*and I will not *)
Would include massive changes to the UI I want the PVTC to be hidden by default and drive the first two screems I want a debugger button that doesn't stop the app but let's me inspect an Entity in real time
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

- (KVPerson *)selectedPerson {
  // OK So here is an insight. If I make a change in the selected obj on map (unimplemented) I need to have that bounce back to here
  NSIndexPath* path = [[self tableView]indexPathForSelectedRow];
  KVPerson* person = [[self PDC]getAllEntities][path.row];
  return person;
  /**
  Thurr Furr
  If Selected No Selected Object let me ask for PDC.IsEmpty etc…
  */
  // TODO: if [person] isEmpty.true then push to setup seque!!!
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [[self MapViewController]setKVMapDataSrc:self];
  
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

  [self willAddPersonInDelegate:self];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  [self.tableView insertRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationAutomatic];

  [[self tableView]selectRowAtIndexPath:indexPath
                               animated:true
                         scrollPosition:UITableViewScrollPositionTop];
  if ([[self PDC]didSaveEntities] == false) {
    NSLog(@"You should Break on this error? Or just not test it");
  }
  [[self tableView]reloadData];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
  if ([[segue identifier] isEqualToString:@"showDetail"])  {
    KVMapViewController *mapView = (KVMapViewController *)[[segue destinationViewController] topViewController];

    [mapView setPDC:[self PDC]];
    [mapView setKVMapDataSrc:(self)];
    
    [mapView setKVMapViewEntity:[self selectedPerson]];
    
  } else if ([[segue identifier] isEqualToString:@"showEULA"]) {
    NSLog(@"Preparing Application For First Run");
  }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger secCount = 3;
//  if (self.TDC) {
//    secCount++; // HEY I NEED A TASK's CELL (in the XIB) But you still wire thse UP FIRST
// Should be two going on three
//}
  return secCount; //
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
 Phase 01, Make a getAllEntities that ONLY GETS Tasks For Selected Person!!!
*/
#pragma mark - Table Updates

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *hedVue = [[UIView alloc]initWithFrame:(CGRectMake(0, 0  , (self.tableView.visibleSize.width), 0))];
  UIButton * secButton = [[UIButton alloc]initWithFrame:(CGRectMake( 0, 0, 128, 22))];
  [hedVue setBackgroundColor:UIColor.grayColor];
  [[secButton titleLabel]setTextColor:(UIColor.blueColor)];

  switch (section) {
      case 0:
      [secButton setTitle:(@"Person +") forState:(UIControlStateNormal)];
//      [secButton setImage:[UIImage imageNamed:@"image.png"] forState:UIControlStateNormal];
      [secButton addTarget:self action:@selector(insertNewPerson:) forControlEvents:UIControlEventTouchUpInside];

      break;
    case 1:
//      [secLabel setText:(@"task")];
      //didAddTaskFrom:
      [secButton setTitle:(@"Task +") forState:(UIControlStateNormal)];
      [secButton addTarget:self action:@selector(didAddTaskFrom:) forControlEvents:UIControlEventTouchUpInside];

      break;
    case 2:
//    [secLabel setText:(@"Event")];
    [secButton setTitle:(@"Event +") forState:(UIControlStateNormal)];
    break;
      
    default:
      break;
  }
  [hedVue addSubview:(secButton)];
//  [hedVue addSubview:(secLabel)];
  return hedVue;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  UIView *nilVue = [[UIView alloc]initWithFrame:(CGRectMake(0, 0  , (self.tableView.visibleSize.width), 0))];
  
  return nilVue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath section] == 0) {

    KDVBasicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
    KVPerson *p = [[self PDC]getAllEntities][indexPath.row];

    NSString *fullName = [[[p firstName]stringByAppendingString:(@" , ")]stringByAppendingString:[p lastName]];
    [[cell nameLabel]setText:fullName];
    [[cell captionLabel]setText:[[p incepDate]description]];
    return cell;
    
  }
  // TODO: This should show Tasks for selectedPerson
  /*
  20200712@0830
  Took an array accessor error yesterday. not the kind that really bugged me but it does make me think about objects, memory, retain release and all of that low level beauty and complexity that Swift and CocoaARC hide. Imagine if I had to have all of that newVar.retain oldVar.release return(newVar) types of pattersn
   AND Do Not think that it isn'e going on Just the same in swift. BC all types of <T> are fully Objects. and when we make a struct it is Just a struct of objects that are bing slapped around by reference anyway again with the ARC hidden.
   It is not that much overhead to have to deal with knowing what my data is and how deep in memeory it is. - - IF I DIDN'T KNOW THIS - - Debugging it would have been a huge PITA
   The Fix is to have the task be a _cascading delete in the .XCDataModel
   AND then when I delete the selectep Person from the table I set the .taskList:(nil)
   */
  else if ([indexPath section] == 1)
  {
    KDVBasicViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];

    KVTask *t = [[self TDC]getAllEntities][indexPath.row];
//    [[tCell nameLabel]setTextColor:(UIColor.cyanColor)];
//    [[tCell captionLabel]setTextColor:(UIColor.greenColor)];
    [[tCell nameLabel]setText:([[t taskOwner]firstName])];
    [[tCell captionLabel]setText:([t taskMemo])];
    return tCell;
  }
  else if ([indexPath section] == 2) {
    KDVBasicViewCell *mCell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];

    KVTask *t = [[self TDC]getAllEntities][indexPath.row];
    mCell.textLabel.text = [[t incepDate]description];
    return mCell;

  }
  return (nil);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    KVPerson *p = [[[self PDC]getAllEntities]objectAtIndex:(indexPath.row)];
      [p setTaskList:(nil)]; // Or Else I will crash like a bitch
      [[self PDC]deleteEntity:p];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  [[self tableView]reloadData];
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

#pragma mark - Setup Location Manager

- (void)setupCLManager{
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
/**
SO WITH the top two coming from the EntityDC interface()
THEN the Intra Application Communcation (IAC) is view::view and the data is view::>dc OR dc::>dc
Intra Application Data (IAD) is the dc::>dc comms and dc::>vc is IAC (un)surprisingly the protocol points the wrong way

Protocol Ethics
THE First Setp is to have all of these dataKhans producing and saving the entity types. That is not hard. As a matter of fact that is in the nature how they are seperated. But that is just about all that I want a DC protocol to do MAYBE but it's an early and end lifecycle thing 'MAYBE' set up a strong link to a dataSrc. So Constructors and LIGHT Mutators should be the norm in this.
See I can and *do* enjoy class methods, Hell I can make these DCs +BlinkyEntity or some initAllUp:withBells:withWhistles and that is NOT off of the table HOWEVER what happens when I compose these so that I am no longer relying or depending or even asking VC::VC Delegates to know where that shit comes FROM. And as I saw in a refactor it is prefectly acceptable to return nil on these functions.
NVM I will advance the Initializer Projections. Actually having been done this before that ain't so bad
What comes next is the behavior of these entities. literally 6-12 likes of code that cache the old state set the new one and queue it for writing Piece of Cake.
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
}

- (void)didAddTaskFrom:(id<KVTaskData>)sender {
//KVPerson *p = [[[self PDC]getAllEntities]firstObject];
  
  if ([[[self PDC]getAllEntities]count] == 0) {
    [self willAddPersonInDelegate:self];
  }
  
  [[self TDC]makeNewTaskInMOC:([[self TDC]MOC])
                   withPerson:[self selectedPerson]];
  if ([[self TDC]didSaveEntities] != true) {
//  Do I Hit this BP Y/N
    NSLog(@"Lawn Loaves");
  }
  [[self tableView]reloadData];

}

- (BOOL)didAddTaskInDelegate:(id<KVTaskData>)sender {

  BOOL facts = nil;
  return (facts);
}

- (BOOL)didAddNewPersonFromDelegate:(id<KDVMapDataProtocol>)deli {
  [self willAddPersonInDelegate:self];
  [[self tableView]reloadData];
  return ([[self PDC]didSaveEntities]);
}

- (BOOL)didAddTask:(KVTask*)task
                To:(KVPerson*)person
              From:(id<KDVMapDataProtocol>)delegate {
  BOOL facts = nil;
  return (facts);
}

- (BOOL)didChangePerson:(id<KVPersonData>)deli
             withPerson:(KVPerson *)p {
  BOOL st8 = false;
  
  return (st8);
}


@end
