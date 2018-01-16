/**
 KVAkulaDataControllerTests.m
 AkulaTests
 
 Created by Kenn Villegas on 1/14/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
 
 */

#import <XCTest/XCTest.h>
#import "KVAkulaDataController.h"

@interface KVAkulaDataControllerTests : XCTestCase
@property (strong, nonatomic)KVAkulaDataController * SUT;
@property (strong, nonatomic)NSPersistentStoreCoordinator *inMemPSK;
@property (strong, nonatomic)NSManagedObjectContext *testMOC;

@end

@implementation KVAkulaDataControllerTests
@synthesize SUT;
@synthesize inMemPSK = _inMemPSK;
@synthesize testMOC = _testMOC;

- (void)setupInMemPSK
{
  //https://stackoverflow.com/questions/43625748/unit-testing-with-core-data-in-objective-c
  //xcdatamodel
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Akula" withExtension:@"momd"];
  //  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Anubis" withExtension:@"xcdatamodel"];
  NSManagedObjectModel *_mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  NSPersistentStoreCoordinator *_psk = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_mom];
  XCTAssertTrue([_psk addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
  
  NSManagedObjectContext *_ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  _ctx.persistentStoreCoordinator = _psk;
  [self setInMemPSK:(_psk)];
  [self setTestMOC:(_ctx)];
}

- (void)setUp {
  [super setUp];
  [self setupInMemPSK];
  [self setSUT:[[KVAkulaDataController alloc]initAllUp]];
  [[self SUT]setMOC:([self testMOC])];
}

- (void)tearDown {
  [self setSUT:(nil)];
  [self setTestMOC:(nil)];
  [self setInMemPSK:(nil)];
  [super tearDown];
}

- (void)testTestingRig01 {

  XCTAssertNotNil([self inMemPSK]);
  XCTAssertNotNil([self testMOC]);
  XCTAssertNotNil([self SUT]);
  XCTAssertNotNil([[self SUT]PCONT]);
  XCTAssertNotNil([[self SUT]PSK]);
  XCTAssertNotNil([[self SUT]MOM]);
  XCTAssertNotNil([[self SUT]MOC]);
  XCTAssertEqual([self testMOC], [[self SUT]MOC]);

  XCTAssertTrue([[[self SUT]applicationName] isEqualToString:(@"Akula")]);
  XCTAssertTrue([[[self SUT]databaseName] isEqualToString:(@"Akula.sqlite")]);
  XCTAssertTrue([[[self SUT]entityClassName] isEqualToString:(@"KVRootEntity")]);
}

- (void)testSUTAndEntity {
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
  // NOTE DETECTED BUG : HEADING WAS SCALAR
  XCTAssertTrue([[[zEntity location]heading] isEqualToNumber:(defZero)]);
  
}
/**
 Demonstration of Documentation
 Those 99 lines of code did not increase coverage at all, and AAMOF it could also fail when I add new code in production it may likely fail. This is secondary
 By Proving the RootEntity, its SubEntities and All of their ivars (*well not including Photo*) I can confidently move to testing fetches and saves.
*/
- (void)testFour {
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
//  [[self SUT]createEntity];
//  [[self SUT]createEntityInMOC:([self testMOC])];
  [[self SUT]createEntityInMOC:(nil)];
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (1));
  [[self SUT]deleteEntity:[[[self SUT]getAllEntities]lastObject]];
  XCTAssertEqual(([[[self SUT]getAllEntities]count]), (0));
}

- (void)testBaseRandomizer {
  int flow = 100000;
  int rolls = 1;
  int sides = 20;
  do {
    XCTAssertGreaterThanOrEqual((int)[SUT makeRandomNumber:100], 1);
    XCTAssertGreaterThanOrEqual((int)[SUT makeRandomNumberCurve:(rolls) :(sides)], (rolls));
    XCTAssertLessThanOrEqual((int)[SUT makeRandomNumberCurve:(rolls) :(sides)], ( (sides) * (rolls) ));
    flow -= 1;
  } while (flow > 0);
}

- (void)testComplexRandomizer {
  int flow = 100000;
  int rolls = 7;    // Prime 1
  int sides = 199;  // Largest Prime < 200
  do {
  XCTAssert((int)[SUT makeRandomNumber:100] >= 0);
  XCTAssertGreaterThanOrEqual((int)[SUT makeRandomNumberCurve:(rolls) : (sides)], (rolls));
  XCTAssertLessThanOrEqual((int)[SUT makeRandomNumberCurve:(rolls) : (sides)], ( (sides) * (rolls) ));
    flow -= 1;
  } while (flow > 0);
}



@end
