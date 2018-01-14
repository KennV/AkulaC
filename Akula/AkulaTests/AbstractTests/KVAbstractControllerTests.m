/**
  KVAbstractControllerTests.m
  AkulaTests

  Created by Kenn Villegas on 1/12/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.

*/

#import <XCTest/XCTest.h>
#import "KDVAbstractDataController.h"
#import "KDVApplicationDataController.h"

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
- (void)testAbstractControllerInitializerResults {
  KDVAbstractDataController * absCon = [[KDVAbstractDataController alloc]init];
  XCTAssertNotNil(absCon);
  XCTAssertTrue([absCon copyDatabaseIfNotPresent]);
  XCTAssertNotNil([absCon applicationName]);
  XCTAssertNotNil([absCon databaseName]);
  XCTAssertNotNil([absCon MOM]);
  XCTAssertNotNil([absCon PCONT]);
  XCTAssertNotNil([absCon PSK]);
  XCTAssertNotNil([absCon MOC]);
  XCTAssertNotNil([absCon fetchCon]);
  XCTAssert([[absCon applicationName] isEqualToString:(@"Akula")]);
  XCTAssert([[absCon databaseName]isEqualToString:(@"Akula.sqlite")]);
  XCTAssertTrue([[absCon entityClassName]isEqualToString:@"KVAbstractEntity"]);
}
/**
Then to be a weirdo I added the Basic AppCon to this test
*/
- (void)testAppControllerInitializerResults {
  KDVAbstractDataController * appCon = [[KDVApplicationDataController alloc]initAllUp];
  XCTAssertNotNil(appCon);
  XCTAssertTrue([appCon copyDatabaseIfNotPresent]);
  XCTAssertNotNil([appCon applicationName]);
  XCTAssertNotNil([appCon databaseName]);
  XCTAssertNotNil([appCon MOM]);
  XCTAssertNotNil([appCon PCONT]);
  XCTAssertNotNil([appCon PSK]);
  XCTAssertNotNil([appCon MOC]);
  XCTAssertNotNil([appCon fetchCon]);
  XCTAssert([[appCon applicationName] isEqualToString:(@"Akula")]);
  XCTAssert([[appCon databaseName]isEqualToString:(@"Akula.sqlite")]);
  XCTAssertTrue([[appCon entityClassName]isEqualToString:@"KVAbstractEntity"]);
}
/**
The next set cannot be completed without a inMemMOC, which I removed from this test module
*/
@end
