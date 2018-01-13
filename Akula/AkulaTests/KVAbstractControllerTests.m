/**
  KVAbstractControllerTests.m
  AkulaTests

  Created by Kenn Villegas on 1/12/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.

*/

#import <XCTest/XCTest.h>
#import "KDVAbstractDataController.h"

@interface KVAbstractControllerTests : XCTestCase
@property (strong, nonatomic)KDVAbstractDataController *SUT;
@property (strong, nonatomic)NSPersistentStoreCoordinator *inMemPSK;
@property (strong, nonatomic)NSManagedObjectContext *testMOC;
@end

@implementation KVAbstractControllerTests
//
@synthesize SUT = _SUT;
@synthesize inMemPSK = _inMemPSK;
@synthesize testMOC = _testMOC;

- (void)setupInMemPSK {
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
}

- (void)tearDown {
  //
  [self setTestMOC:(nil)];
  [self setInMemPSK:(nil)];
  [self setSUT:(nil)];
  
    [super tearDown];
}

- (void)testAbstractInitializerResults {
  KDVAbstractDataController * tOne = [[KDVAbstractDataController alloc]init];
  XCTAssertNotNil(tOne);
  XCTAssertNotNil([tOne applicationName]);
  XCTAssertNotNil([tOne databaseName]);
  XCTAssertNotNil([tOne PCONT]);
  XCTAssertNotNil([tOne PSK]);
  XCTAssertNotNil([tOne MOC]);
  XCTAssertNotNil([tOne fetchCon]);
  XCTAssert([[tOne applicationName] isEqualToString:(@"Akula")]);
  XCTAssert([[tOne databaseName]isEqualToString:(@"Akula.sqlite")]);
  XCTAssertTrue([[tOne entityClassName]isEqualToString:@"KVAbstractEntity"]);
  
  
}

@end
