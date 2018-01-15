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

//
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
  XCTAssertTrue([[zEntity hexID] isEqualToString:defOne]);
  
  XCTAssertNotNil([zEntity graphics]);
  XCTAssertTrue([[[zEntity graphics]caption] isEqualToString:defOne]);
  XCTAssertTrue([[[zEntity graphics]photoFileName] isEqualToString:defOne]);
  
  XCTAssertNotNil([zEntity physics]);
  XCTAssertTrue([[[zEntity physics]massKG] isEqualToNumber:defZero]);
  XCTAssertTrue([[[zEntity physics]xLong] isEqualToNumber:defZero]);
  XCTAssertTrue([[[zEntity physics]yWide] isEqualToNumber:defZero]);
  XCTAssertTrue([[[zEntity physics]zTall] isEqualToNumber:defZero]);
  
  
  XCTAssertNotNil([zEntity location]);
  XCTAssertTrue([[[zEntity location]altitude] isEqualToNumber:defZero]);
  XCTAssertTrue([[[zEntity location]latitude] isEqualToNumber:defZero]);
  XCTAssertTrue([[[zEntity location]longitude] isEqualToNumber:defZero]);
  // NOTE DETECTED BUG : HEADING WAS SCALAR
  XCTAssertTrue([[[zEntity location]heading] isEqualToNumber:defZero]);
  
}

@end
