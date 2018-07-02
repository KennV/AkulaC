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


@interface KVAkulaDataControllerTests : XCTestCase

@property (strong, nonatomic)NSPersistentStoreCoordinator *inMemoryCoordinator;
@property (strong, nonatomic)NSManagedObjectContext *testMOC;

@property (strong, nonatomic)KVAkulaDataController * SUT;
@property (strong, nonatomic)KVPersonDataController *PDC;
@end

@implementation KVAkulaDataControllerTests
@synthesize SUT = _SUT;
@synthesize PDC = _PDC;
@synthesize inMemoryCoordinator = _inMemoryCoordinator;
//@synthesize inMemContext = _inMemContext;

- (void)setupInMemoryCoordinator {
  //https://stackoverflow.com/questions/43625748/unit-testing-with-core-data-in-objective-c
  //xcdatamodel
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Akula" withExtension:@"momd"];
  //  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Anubis" withExtension:@"xcdatamodel"];
  NSManagedObjectModel *_mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  NSPersistentStoreCoordinator *_psk = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_mom];
  XCTAssertTrue([_psk addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
  
  NSManagedObjectContext *_ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  _ctx.persistentStoreCoordinator = _psk;
//  [self setInMemPSK:(_psk)];
  [self setInMemoryCoordinator:(_psk)];
  [self setTestMOC:(_ctx)];
}

- (void)setUp {
  [super setUp];

  [self setupInMemoryCoordinator];
  [[self SUT]setPSK:[self inMemoryCoordinator]];
  
  [self setSUT:[[KVAkulaDataController alloc]initAllUp]];
  [[self SUT]setMOC:[self testMOC]];
  
  [self setPDC:([[KVPersonDataController alloc]initAllUp])];
  [[self PDC] setMOC:[[self SUT]MOC]];
  
}

- (void)tearDown {
  [[self SUT]setPSK:(nil)];
  [self setTestMOC:(nil)];
  [self setInMemoryCoordinator:(nil)];
  
  [[self PDC]setMOC:(nil)];
  [self setPDC:(nil)];
  
  [[self SUT]setMOC:(nil)];
  [self setSUT:(nil)];
  [super tearDown];
}

- (void)testTestingRig01 {
  /**
   This test set determines: The initial state of my test rig.
  */
  XCTAssertNotNil([self inMemoryCoordinator]);
  XCTAssertNotNil([self inMemoryCoordinator]);
  XCTAssertNotNil([self SUT]);
  XCTAssertNotNil([[self SUT]container]);
  XCTAssertNotNil([[self SUT]PSK]);
  XCTAssertNotNil([[self SUT]MOM]);
  XCTAssertNotNil([[self SUT]MOC]);

  XCTAssertTrue([[[self SUT]applicationName] isEqualToString:(@"Akula")]);
  XCTAssertTrue([[[self SUT]databaseName] isEqualToString:(@"Akula.sqlite")]);
  XCTAssertTrue([[[self SUT]entityClassName] isEqualToString:(@"KVRootEntity")]);
  
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
}
/**
 Demonstration of Documentation
 Those 99 lines of code did not increase coverage at all, and AAMOF it could also fail when I add new code in production it may likely fail. This is secondary
 By Proving the RootEntity, its SubEntities and All of their ivars (*well not including Photo*) I can confidently move to testing fetches and saves.
*/

- (void)testCreateAndDelete {
  /**
  This test set determines: that the SUT can create and delete entities, and that it will have the correct count of entities in the SUT's getAllEntities()
   
  BASE TEST Altered as Such
  If I use nil like createEntityInMOC:(nil)]; in createEntityInMOC:([SUT MOC])]; then later tests in the PDC will use the wrong context
  */

  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  
  [[self SUT]createEntityInMOC:([[self SUT] MOC])];
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (1));
  
  [[self SUT]deleteEntity:[[[self SUT]getAllEntities]lastObject]];
  
  XCTAssertTrue([[self SUT]didSaveEntities]);
  
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  
  XCTAssertTrue([[self SUT]didSaveEntities]);
}

- (void)testSUTAndEntity {
  /**
   This test set determines:
   
  Testing that the SUT makes a Blank KVRootEntity
  */
  NSString * defOne = (@"unset");
  NSNumber * defZero = (@0);
  
  KVRootEntity * zEntity = [[self SUT]createEntityInMOC:([self testMOC])];
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

- (void)testPDC {
  /**
   This test set determines:
   */
  NSString * defOne = (@"unset");
  NSNumber * defZero = (@0);
//  KVPersonDataController *PDC = [[KVPersonDataController alloc]initAllUp];
//  [PDC setMOC:[[self SUT]MOC]];
  //
  KVPerson * tmpPerson = [[self PDC] createEntityInMOC:([self testMOC])];
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
}

- (void)testEntityMutability {
  /**
   This test set determines:
   */
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  
  [[self PDC]createEntityInMOC:([[self SUT] MOC])];
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (1));
  /***/
  KVPerson *jiveP = [[[self PDC]getAllEntities]lastObject];
  XCTAssertTrue([@"unset" isEqualToString:[jiveP firstName]]);
  [jiveP setFirstName:(@"Joe")];
  XCTAssertTrue([[self SUT]didSaveEntities]);
  XCTAssertTrue([@"Joe" isEqualToString:[[[[self PDC]getAllEntities]lastObject]firstName]]);
  [[self PDC]deleteEntity:[[[self SUT]getAllEntities]lastObject]];
  XCTAssertTrue([[self SUT]didSaveEntities]);
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  XCTAssertTrue([[self SUT]didSaveEntities]);
  
}

- (void)testArrayMutability {
  /**
   This test set determines:
   */
  UInt16 kMax = 32;
  
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
  /***/
  for (UInt16 k = 0; k < kMax; k+=1) {
    [[self PDC]createEntityInMOC:([[self SUT] MOC])];
  }
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (kMax));
  /**
   THis Array is non-mutable but it's members are
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
}

- (void)nonTestMemo {
  /**
  OK I Can edit them indivitually, and also ed. them in a non-mutable arr
  SO
  CAN I make an ARR, then parse/process them out of that, then save and have the effect still in place on the [self SUT]getAllEntities]
  */
}

@end
