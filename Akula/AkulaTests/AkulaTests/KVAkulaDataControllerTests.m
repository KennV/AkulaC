/**
 KVAkulaDataControllerTests.m
 AkulaTests
 
 Created by Kenn Villegas on 1/14/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
 
 */

#import <XCTest/XCTest.h>
#import "KVAkulaDataController.h"

@interface KVAkulaDataControllerTests : XCTestCase

@property (strong, nonatomic)NSPersistentStoreCoordinator *inMemPSK;
@property (strong, nonatomic)NSManagedObjectContext *testMOC;

@end

@implementation KVAkulaDataControllerTests
@synthesize inMemPSK = _inMemPSK;
@synthesize testMOC = _testMOC;


- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

@end
