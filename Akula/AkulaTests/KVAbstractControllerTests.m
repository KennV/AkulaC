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

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
