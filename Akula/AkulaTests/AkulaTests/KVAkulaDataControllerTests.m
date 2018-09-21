/**
 KVAkulaDataControllerTests.m
 AkulaTests
 
 Created by Kenn Villegas on 1/14/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/

#import <XCTest/XCTest.h>
@class KVAkulaDataController;
#import "KVAkulaDataController.h" //added model to test
#import "KVPersonDataController.h"
//
#import "AppDelegate.h"


@interface KVAkulaDataControllerTests : XCTestCase <PersonActionProtocol>

@property (strong, nonatomic)NSPersistentStoreCoordinator *inMemoryCoordinator;
@property (strong, nonatomic)NSManagedObjectContext *testMOC;

@property (strong, nonatomic)KVAkulaDataController * SUT;
@property (strong, nonatomic)KVPersonDataController *PDC;
@property (strong, nonatomic)KVTasksDataController *TDC;
@end

@implementation KVAkulaDataControllerTests
@synthesize SUT = _SUT;
@synthesize PDC = _PDC;
@synthesize TDC = _TDC;
@synthesize inMemoryCoordinator = _inMemoryCoordinator;
// Lightweight Migration
// https://stackoverflow.com/questions/8881453/the-model-used-to-open-the-store-is-incompatible-with-the-one-used-to-create-the
// FIXME: Add Lightweight Migration like THIS
- (void)setupInMemoryCoordinator {
  //https://stackoverflow.com/questions/43625748/unit-testing-with-core-data-in-objective-c
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Akula" withExtension:@"momd"]; //xcdatamodel
  NSManagedObjectModel *_mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  NSPersistentStoreCoordinator *_psk = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_mom];
  XCTAssertTrue([_psk addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store"); // ** Note I _prefer_ the longhand version of this

  NSManagedObjectContext *_ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  _ctx.persistentStoreCoordinator = _psk;

  [self setInMemoryCoordinator:(_psk)];
  [self setTestMOC:(_ctx)];
  /**
   Expected Results
   */
}

/**
 
 20180915@2145
 SO my base class is KVRootEntity. and if I were to add classFunctions to that Controller, *KVRootEntityController then it would be simple to +(void/bool)add/delete#RootEntity
 BECAUSE THE SUT.entityClassName is @"KVRootEntity"
 ¿Can I send These <BLIND>?

*/


- (void)setUp {
  [super setUp];

  [self setupInMemoryCoordinator];
  
  [[self SUT]setPSX:[self inMemoryCoordinator]];
  
  [self setSUT:[[KVAkulaDataController alloc]initAllUp]];
  [[self SUT]setMOC:[self testMOC]];
  
  [self setPDC:([[KVPersonDataController alloc]initAllUp])];
  [[self PDC] setMOC:[[self SUT]MOC]];
  
  [self setTDC:([[KVTasksDataController alloc]initAllUp])];
  [[self TDC]setMOC:[[self SUT]MOC]];
  /**
   Expected Results
   */
}

- (void)tearDown {
  [[self SUT]setPSX:(nil)];
  [self setTestMOC:(nil)];
  [self setInMemoryCoordinator:(nil)];
  
  [[self PDC]setMOC:(nil)];
  [self setPDC:(nil)];
  
  [[self SUT]setMOC:(nil)];
  [self setSUT:(nil)];
  [super tearDown];
  /**
   Expected Results
   */
}

- (void)testTestingRig01 {
  /**
   This test set determines: The initial state of my test rig.
  */
  XCTAssertNotNil([self inMemoryCoordinator]);
  XCTAssertNotNil([self inMemoryCoordinator]);
  XCTAssertNotNil([self SUT]);
  XCTAssertNotNil([[self SUT]container]);
  XCTAssertNotNil([[self SUT]PSX]);
  XCTAssertNotNil([[self SUT]MOM]);
  XCTAssertNotNil([[self SUT]MOC]);

  XCTAssertTrue([[[self SUT]applicationName] isEqualToString:(@"Akula")]);
  XCTAssertTrue([[[self SUT]databaseName] isEqualToString:(@"Akula.sqlite")]);
  XCTAssertTrue([[[self SUT]entityClassName] isEqualToString:(@"KVRootEntity")]);
  /**
   Expected Results
   */
}

- (void)testEntityMutability {
  /**
   This test set determines:
   */
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  
  [[self PDC]makeNewPersonInMOC:([[self SUT] MOC])];
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (1));
  /***/
  KVPerson *jiveP = [[[self PDC]getAllEntities]lastObject];
  XCTAssertFalse([@"unset" isEqualToString:[jiveP firstName]]);
  [jiveP setFirstName:(@"Joe")];
  XCTAssertTrue([[self SUT]didSaveEntities]);
  XCTAssertTrue([@"Joe" isEqualToString:[[[[self PDC]getAllEntities]lastObject]firstName]]);
  [[self PDC]deleteEntity:[[[self SUT]getAllEntities]lastObject]];
  XCTAssertTrue([[self SUT]didSaveEntities]);
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  XCTAssertTrue([[self SUT]didSaveEntities]);
  /**
   Expected Results
   */
}

- (void)testArrayMutability {
  /**
   This test set determines:
   */
  UInt16 kMax = 32;
  
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  /***/
  for (UInt16 k = 0; k < kMax; k+=1) {
    [[self PDC]makeNewPersonInMOC:([[self SUT] MOC])];
  }
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (kMax));
  /**
   This Array is non-mutable but it's members are
   */
  NSArray *somePeople = [[self PDC]getAllEntities];
  
  for (KVPerson *personX in somePeople) {
    [personX setFirstName:@"Tony"];
  }
  
  XCTAssertEqual(kMax, [[[self PDC]getAllEntities]count]);
  XCTAssertTrue([[self PDC]didSaveEntities]);
  
  for (KVPerson *personX in somePeople) {
    XCTAssertFalse([[personX firstName]isEqualToString:@"unset"]);
    XCTAssertTrue([[personX firstName]isEqualToString:@"Tony"]);
  }
  XCTAssertTrue([[self PDC]didSaveEntities]);
  
  while ([[[self PDC]getAllEntities]count]!=0) {
    [[self PDC]deleteEntity:[[[self PDC]getAllEntities]lastObject]];
  }
  XCTAssertTrue([[self PDC]didSaveEntities]);
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  /**
   Expected Results
   */
}

- (void)testBaseRandomizer {
  /**
   This test set determines: My ability to make a single random value between one and twenty
   */
  int flow = 100000;
  int rolls = 1;
  int sides = 20;
  do {
    XCTAssertGreaterThanOrEqual((int)[[self SUT] makeRandomNumber:100], 1);
    XCTAssertGreaterThanOrEqual((int)[[self SUT]makeRandomNumberCurve:(rolls) :(sides)], (rolls));
    XCTAssertLessThanOrEqual((int)[[self SUT]makeRandomNumberCurve:(rolls) :(sides)], ((sides) * (rolls)));
    flow -= 1;
  } while (flow > 0);
  /**
   Expected Results
   */
}

- (void)testComplexRandomizer {
  /**
   This test set determines: My ability to make a complex random value between 1 and 199
   multiplied by seven
   */
  int flow = 100000;
  int rolls = 7;    // Prime 1
  int sides = 199;  // Largest Prime < 200
  do {
  XCTAssert((int)[[self SUT] makeRandomNumber:100] >= 0);
  XCTAssertGreaterThanOrEqual((int)[[self SUT]makeRandomNumberCurve:(rolls) : (sides)], (rolls));
  XCTAssertLessThanOrEqual((int)[[self SUT]makeRandomNumberCurve:(rolls) : (sides)], ((sides) * (rolls)));
    flow -= 1;
  } while (flow > 0);
  /**
   Expected Results
   */
}

- (void)testAbstractDataController {
  id j = [[KDVAbstractDataController alloc]init];
  XCTAssertNotNil(j);
  if ([j isMemberOfClass:[KDVAbstractDataController class]]) {
    XCTAssertNotNil([j fetchCon]);
    
  }
  /**
   Expected Results
   */
}

- (void)testCreateAndDelete {
  /**
  This test set determines: that the SUT can create and delete entities, and that it will have the correct count of entities in the SUT's getAllEntities()
   
  BASE TEST Altered as Such
  If I use nil like createEntityInMOC:(nil)]; in createEntityInMOC:([SUT MOC])]; then later tests in the PDC will use the wrong context
  */

  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  
  [[self SUT]makeNewPersonInMOC:([[self SUT] MOC])];
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (1));
  
  [[self SUT]deleteEntity:[[[self SUT]getAllEntities]lastObject]];
  
  XCTAssertTrue([[self SUT]didSaveEntities]);
  
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  
  XCTAssertTrue([[self SUT]didSaveEntities]);
  /**
   Expected Results
   */
}

- (void)testSUTAndEntity {
  /**
   This test set determines:
   
  Testing that the SUT makes a Blank KVRootEntity
  */
  NSString * defOne = (@"unset");
  NSNumber * defZero = (@0);
  
  KVRootEntity * zEntity = [[self SUT]makeNewPersonInMOC:([[self SUT]MOC])];
  XCTAssertNotNil(zEntity);
  XCTAssertTrue([[zEntity hexID] isEqualToString:(defOne)]);
  XCTAssertTrue([[zEntity qName] isEqualToString:(defOne)]);
  XCTAssertTrue([[zEntity type] isEqualToString:(defOne)]);
  XCTAssertTrue([[zEntity status] isEqualToNumber:(defZero)]);
  // NOTE WILL HAVE TO ADD GRAPHICS
  XCTAssertNotNil([zEntity graphics]);
  XCTAssertTrue([[[zEntity graphics]caption] isEqualToString:(defOne)]);
  XCTAssertTrue([[[zEntity graphics]photoFileName] isEqualToString:(defOne)]);
  
  XCTAssertNotNil([zEntity physics]);
  XCTAssertTrue([[[zEntity physics]massKG] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[zEntity physics]xLong] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[zEntity physics]yWide] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[zEntity physics]zTall] isEqualToNumber:(defZero)]);
  
  XCTAssertNotNil([zEntity location]);
  XCTAssertTrue([[[zEntity location]altitude] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[zEntity location]latitude] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[zEntity location]longitude] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[zEntity location]heading] isEqualToNumber:(defZero)]);
}

- (void)testSubEntities {
  XCTAssertNotNil([[self SUT]makeGraphicsSubEntityFor:nil In:[[self SUT]MOC]]);
  XCTAssertNotNil([[self SUT]makeLocationSubEntityFor:nil In:[[self SUT]MOC]]);
  XCTAssertNotNil([[self SUT]makePhysSubEntityFor:nil In:[[self SUT]MOC]]);
  /**
   Expected Results
   */
}

- (void)testPDC {
  [self setPDC:(nil)];
  XCTAssertNil([self PDC]);
  
  XCTAssertNotNil([[KVPersonDataController alloc]init], @"Nper");
  
  [self setPDC:(nil)];
  XCTAssertNil([self PDC]);
  
  XCTAssertNotNil([[KVPersonDataController alloc]initAllUp], @"Nper");
  /**
   Expected Results
   */
}

- (void)testPerson {
  /**
   This test set determines:
   */
  NSString * defOne = (@"unset");
  NSNumber * defZero = (@0);
//  KVPersonDataController *PDC = [[KVPersonDataController alloc]initAllUp];
//  [PDC setMOC:[[self SUT]MOC]];
  //
  KVPerson * tmpPerson = [[self PDC] makeNewPersonInMOC:([[self SUT]MOC])];
  XCTAssertNotNil(tmpPerson);
  XCTAssertTrue([[tmpPerson hexID] isEqualToString:(defOne)]);
  XCTAssertTrue([[tmpPerson qName] isEqualToString:(defOne)]);
  XCTAssertTrue([[tmpPerson type] isEqualToString:(defOne)]);
  XCTAssertTrue([[tmpPerson status] isEqualToNumber:(defZero)]);
  // NOTE WILL HAVE TO ADD GRAPHICS
  XCTAssertNotNil([tmpPerson graphics]);
  XCTAssertTrue([[[tmpPerson graphics]caption] isEqualToString:(defOne)]);
  XCTAssertTrue([[[tmpPerson graphics]photoFileName] isEqualToString:(defOne)]);
  
  XCTAssertNotNil([tmpPerson physics]);
  XCTAssertTrue([[[tmpPerson physics]massKG] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[tmpPerson physics]xLong] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[tmpPerson physics]yWide] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[tmpPerson physics]zTall] isEqualToNumber:(defZero)]);
  
  XCTAssertNotNil([tmpPerson location]);
  XCTAssertTrue([[[tmpPerson location]altitude] isEqualToNumber:(defZero)]);
  XCTAssertFalse([[[tmpPerson location]latitude] isEqualToNumber:(defZero)]);
  XCTAssertFalse([[[tmpPerson location]longitude] isEqualToNumber:(defZero)]);
  XCTAssertTrue([[[tmpPerson location]heading] isEqualToNumber:(defZero)]);
  /**
   Expected Results
   */
}

- (void)testNameFunctions {
//  XCTAssertFalse(@"" isEqualToString:[PDC cre])
  KVPerson * p = [[self PDC] makeNewPersonInMOC:([[self SUT]MOC])];
  XCTAssertNotNil([p gender]);
  XCTAssertNotNil([p firstName]);
  XCTAssertNotNil([p middleName]);
  XCTAssertNotNil([p lastName]);
  XCTAssertNotNil([p gender]);
  XCTAssertFalse([(@"unset") isEqualToString:[p firstName]]);
  XCTAssertFalse([(@"unset") isEqualToString:[p lastName]]);
  XCTAssertFalse([(@"unset") isEqualToString:[p middleName]]);
  XCTAssertFalse([(@"unset") isEqualToString:[p gender]]);

  [[self PDC] randomizePersonName:p];//
  
  XCTAssertFalse([(@"unset") isEqualToString:[p firstName]]);
  XCTAssertFalse([(@"unset") isEqualToString:[p lastName]]);
  XCTAssertFalse([(@"unset") isEqualToString:[p middleName]]);
  XCTAssertFalse([(@"unset") isEqualToString:[p gender]]);

  XCTAssertFalse([(@"Edit-Me") isEqualToString:[p firstName]]);
  XCTAssertFalse([(@"Edit-Me") isEqualToString:[p lastName]]);
  XCTAssertFalse([(@"Edit-Me") isEqualToString:[p middleName]]);
  XCTAssertFalse([(@"Edit-Me") isEqualToString:[p gender]]);

  [[self PDC]resetDefaultPerson:p];
  
  XCTAssertTrue([(@"Edit-Me") isEqualToString:[p firstName]]);
  XCTAssertTrue([(@"Edit-Me") isEqualToString:[p lastName]]);
  XCTAssertTrue([(@"Edit-Me") isEqualToString:[p middleName]]);
  XCTAssertTrue([(@"Edit-Me") isEqualToString:[p gender]]);
  /**
   Expected Results
   */
}

- (void)nonTestMemo {
  /**
  OK I Can edit them indivitually, and also ed. them in a non-mutable arr
  SO
  CAN I make an ARR, then parse/process them out of that, then save and have the effect still in place on the [self SUT]getAllEntities]
  */
}

- (void)testFetchesAndJunk {
  XCTAssertNotNil([[KDVApplicationDataController alloc]initAllUp]);
  KDVApplicationDataController *khan = [[KDVApplicationDataController alloc]initAllUp];
  [khan setMOC:[[self SUT]MOC]];
  XCTAssertNotNil([khan fetchCon]);
  
  KVRootEntity * tEntity = [NSEntityDescription insertNewObjectForEntityForName:(@"KVRootEntity")inManagedObjectContext:([khan MOC])];
  XCTAssertNotNil(tEntity);
  
  NSError *error = nil;
  //  NSManagedObjectContext *managedObjectContext = self.MOC;
  if ([khan MOC] != nil) {
    if ([[khan MOC] hasChanges] && ![[khan MOC] save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }

    XCTAssertTrue([[khan getAllEntities]count] != 0);
  }
  /**
   Expected Results
   */
}

#pragma mark - profiling

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
    // Put the code you want to measure the time of here.
  }];
}

#pragma mark - MiniTweek
- (void)testClassFetch {
  /**
   This test is six percent of the current test load
   */
  XCTAssertNotNil([[[[self SUT] makeNewPersonInMOC:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[[self PDC] makeNewPersonInMOC:([[self SUT]MOC])] class]fetchRequest]);

  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractPhysics") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractGraphicsEntity") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractLocationEntity") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractEntity") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVAppointment") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVEntity") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVEvent") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVItem") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
//
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVAppointment") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVMedication") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVMessage") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVPackage") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  XCTAssertNotNil([[[NSEntityDescription insertNewObjectForEntityForName:(@"KVTask") inManagedObjectContext:([[self SUT]MOC])] class]fetchRequest]);
  /**
   Expected Results
   */
}

#pragma mark - Folding

- (void)testAkulaAppDelegate {
  id<UIApplicationDelegate> appDel = [[UIApplication sharedApplication]delegate];
  
  XCTAssert([appDel isKindOfClass:[AppDelegate class]]);
  XCTAssertNotNil([appDel window]);
  
  XCTAssertTrue([appDel application:((UIApplication*)appDel) didFinishLaunchingWithOptions:nil]);
  
  UISplitViewController *rootView = (UISplitViewController<UISplitViewControllerDelegate>*)[[appDel window]rootViewController];
  XCTAssertNotNil([[rootView viewControllers]lastObject]);
  /**
   Expected Results
   */
  
}

- (void)testAkulaVue {
  KVPrimeTableViewController *j = [[KVPrimeTableViewController alloc]init];
  XCTAssertNotNil(j.ADC);
  
  [j viewDidLoad];
  XCTAssertNotNil([j ADC]);
  XCTAssertNotNil([[j ADC]MOM]);
  XCTAssertNotNil([[j ADC]PSX]);
  XCTAssertNotNil([[j ADC]MOC]);
  
  XCTAssertNotNil([j PDC]);
  XCTAssertNotNil([[j PDC]MOM]);
  XCTAssertNotNil([[j PDC]PSX]);
  XCTAssertNotNil([[j PDC]MOC]);
  
  XCTAssertTrue([[[j PDC]MOM]isEqual:[[j ADC]MOM]]);
  XCTAssertEqual([[j PDC]MOC], [[j ADC]MOC]);
  XCTAssertFalse([[[j PDC]PSX]isEqual:[[j ADC]PSX]]);
  /**
   Expected Results
   */
  
}

#pragma mark - ProtocolTests
/**
 Yups this is sum Wiley Coyote Level Nice;
 Test the behavior of the Controller and the Entity
 Or the ViewController of the controller of the entity.
 THEN I can use these protocols in the EntityCon and the VueCon
 */
/**
20180914@0030
 # Tests and Testable Protocols #
 
 Judging by the extant structure of this code below. with the _expected_result_ right there in the function, it seem as if I have been planning this at least subliminially in my mind for a while.
 
 Everything in a protocol affects state.
 And I want to mke this much more transparent at a class level by using protocol inheritance.

 */


- (BOOL)didChangePerson:(id<PersonActionProtocol>)deli
             withPerson:(KVPerson *)p {
  BOOL result = FALSE;
/**
 nope, this does not go here, but it does, the deli in this instance should be the ViewController
 
 */
  return (result);
  /**
   Expected Results
   */
}

- (BOOL)didModifyTasksForPerson:(id<PersonActionProtocol>)deli
                   withTasksCon:(KVTasksDataController *)tkon
                         person:(KVPerson *)p {
  return FALSE;
  /**
   Expected Results
   */
}
// OOOh xcode just added this b/c I added it _elsewhere_
- (void)willAddPersonInDelegate:(id<PersonActionProtocol>)deli {
//  <#code#>
}

- (void)testAddTask {
  XCTAssertFalse([self didModifyTasksForPerson:self
                                  withTasksCon:nil
                                        person:nil]);
  /**
   Expected Results
   */
}
/**
20180914@0030
Also this may be a great opportunity to test some of the different boilerplate fetches that are performed
 Lets look at the types of parameters that they take
DO I have these properly documented
*/
#pragma mark - TKON
- (void)testZOner {
//  XCTAssertNotNil(self.)
  XCTAssertNotNil([self TDC]);
  XCTAssertNotNil([[self PDC]makeNewPersonInMOC:nil]);
  //
//  XCTAssertEqual((@"KVTask"), [[self TDC]entityClassName]);
  
//  KVPerson * p = [[self PDC]makeNewPersonInMOC:[[self SUT]MOC]];
//  KVTask * t = [NSEntityDescription insertNewObjectForEntityForName:<#(nonnull NSString *)#> inManagedObjectContext:<#(nonnull NSManagedObjectContext *)#>]
  
}


@end
