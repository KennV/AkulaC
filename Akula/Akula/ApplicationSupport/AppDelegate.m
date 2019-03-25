/**
  AppDelegate.m
  Akula

  Created by Kenn Villegas on 1/11/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/

/**
OK _At This Time_ the view has data, and it should But where should that come from the View is the application's minion. I should say what happens to the state when it loads or saves
*/

#import "AppDelegate.h"
/**
 Some Ill Shit First I need to know if I have accepted the EULA _Before_ location Management. Then I can do that in a PLIST prolly from here.
 
 https://stackoverflow.com/questions/31203241/how-can-i-use-userdefaults-in-swift/31203348#31203348
 
 In the View I can manually define a seque
typedef enum : NSUInteger {
  appHasRunSetup

} propertyListKeys;

@_z_interface NSUserDefaults ()
{
 
}

@end
 */

@interface AppDelegate () <UISplitViewControllerDelegate>
@property(readonly,nonatomic)KVAkulaDataController *allDataController;
@end

@implementation AppDelegate
@synthesize allDataController = _allDataController;

- (KVAkulaDataController *)allDataController {
  if (_allDataController == (nil)) {
    _allDataController = [[KVAkulaDataController  alloc]initAllUp];
  }
  return _allDataController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
/**
 Override point for customization after application launch.
 Actual Factual I did a few changes and I want to activate test
 What used to be called navCon is now masterNavCon
 I test for Identity and I also test for respondsTo
 */
  UISplitViewController *splitViewController = (UISplitViewController *)[[self window]rootViewController];
  
  [splitViewController setDelegate:self];
  
  KVPrimeTableViewController *masterNavigationController = [[splitViewController viewControllers] lastObject];
  
  if ([masterNavigationController isKindOfClass:([KVPrimeTableViewController class])] && [masterNavigationController respondsToSelector:(@selector(setADC:))])
  {
    /**
     OKay what I want to do at this point is, launch a different detailView than the mapView if -
     Well let's consider the predicates.
     Is appHasRunSetup or such true?
      AND
     Is ADC empty?
    */
    //TODO: - Setup and Test UserDefaults
    //FIXME : setupState
    masterNavigationController.MapViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    [masterNavigationController setADC:[self allDataController]];
    //TODO: Some More.
    /**
     Given the state of the TVC I need to have some private ivars to it and also binding it to the MapView. i.e. a LocationManager that I can use in a callBack w\o it being a global or a singleton. ALSO the ability for the map to easily differentiate between a Person* and an Item*\Person-Place-Thing* 
    */
  }
  //This is to forstall some future setup & test features
  [self appLogicChecks];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  __unused bool j = [[self allDataController]didSaveEntities];
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  __unused bool j = [[self allDataController]didSaveEntities];
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {

  if ([[self allDataController]didSaveEntities]) {
    NSLog(@"App terminated correctly");
  } else {
    NSLog(@"App NOT terminated correctly");
  }
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view
// TODO: - implement UISplitViewController
//#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[KVMapViewController class]] && ([(KVMapViewController *)[(UINavigationController *)secondaryViewController topViewController] currentEntity] == nil))
    {
/*
 OK 'secondaryViewController' is *UINavigationController and its topView *KVMapViewController
 I should set some class / factory methods to setup the view
 
 ## Look at the Tricorder Implementation ##
 */
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

// TODO: - implement Split View logic

- (void)appLogicChecks
{
  if ([[[self allDataController]getAllEntities]count]==0) {
    NSLog(@"Application Contains No Entities");
    NSLog(@"Performing Setup is advised");
  } else {
    NSLog(@"Application Contains %lu Entities",(unsigned long)[[[self allDataController]getAllEntities]count]);
  }
}
@end
