/**
  KVAbstractControllerTests.m
  AkulaTests

  Created by Kenn Villegas on 1/12/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas


*/

#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "KDVApplicationDataController.h"

@interface KVAbstractControllerTests : XCTestCase
@property (strong, nonatomic)id<UIApplicationDelegate> SUT;
@property (strong, nonatomic)KVPrimeTableViewController *TVC;

@end

@implementation KVAbstractControllerTests

@synthesize SUT = _SUT;
@synthesize TVC = _TVC;

- (void)setUp {
  [super setUp];
  [self setSUT:[[UIApplication sharedApplication]delegate]];
  [self setTVC:[[KVPrimeTableViewController alloc]init]];
}

- (void)tearDown {
//  [self setSUT:(nil)];
  [super tearDown];
}
/*
This test Asserts that the KDVAbstractDataController inits with the correct state. In practice I could also set the SUT to KDVAbstractDataController and test from there
*/

//#pragma mark - Folding
#pragma mark - THIS IS _HELLA_ IMPORTANT

- (void)testAkulaAppDelegate {
//  id<UIApplicationDelegate> appDel = [[UIApplication sharedApplication]delegate];
  
  XCTAssert([[self SUT] isKindOfClass:[AppDelegate class]]);
  XCTAssertNotNil([[self SUT] window]);
  
  XCTAssertTrue([[self SUT] application:((UIApplication*)[self SUT]) didFinishLaunchingWithOptions:nil]);
  
  UISplitViewController *rootView = (UISplitViewController<UISplitViewControllerDelegate>*)[[[self SUT] window]rootViewController];
  XCTAssertNotNil([[rootView viewControllers]lastObject]);
  /**
   Expected Results
   */
}

- (void)testAkulaVue {

  XCTAssertNotNil([[self TVC]ADC]);

  [[self TVC] viewDidLoad];
  XCTAssertNotNil([[self TVC] ADC]);
  XCTAssertNotNil([[[self TVC] ADC]MOM]);
  XCTAssertNotNil([[[self TVC] ADC]PSX]);
  XCTAssertNotNil([[[self TVC] ADC]MOC]);
  
  /**
   Expected Results
   */
  
}

@end
