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
@end

@implementation KVAbstractControllerTests
/*
I have pulled all of the extra setup and inMemoryController from here it is not an enhancement of the system
*/
@synthesize SUT = _SUT;

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [self setSUT:(nil)];
  [super tearDown];
}

/*
This test Asserts that the KDVAbstractDataController inits with the correct state. In practice I could also set the SUT to KDVAbstractDataController and test from there
*/
- (void)testAbstractInitializerResults {
  KDVAbstractDataController * tOne = [[KDVAbstractDataController alloc]init];
  XCTAssertNotNil(tOne);
  XCTAssertTrue([tOne copyDatabaseIfNotPresent]);
  XCTAssertNotNil([tOne applicationName]);
  XCTAssertNotNil([tOne databaseName]);
  XCTAssertNotNil([tOne MOM]);
  XCTAssertNotNil([tOne PCONT]);
  XCTAssertNotNil([tOne PSK]);
  XCTAssertNotNil([tOne MOC]);
  XCTAssertNotNil([tOne fetchCon]);
  XCTAssert([[tOne applicationName] isEqualToString:(@"Akula")]);
  XCTAssert([[tOne databaseName]isEqualToString:(@"Akula.sqlite")]);
  XCTAssertTrue([[tOne entityClassName]isEqualToString:@"KVAbstractEntity"]);
}

@end
