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
#import "KVPrimeTableViewController.h"
#import "KVMapViewController.h"
//
#import "KVAkulaDataController.h"

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
  UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
  
  [splitViewController setDelegate:self];
  
  KVPrimeTableViewController *masterNavigationController = [splitViewController.viewControllers lastObject];
  
  if ([masterNavigationController isKindOfClass:([KVPrimeTableViewController class])] &&
      [masterNavigationController respondsToSelector:(@selector(setADC:))])
  {
    masterNavigationController.mapViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    [masterNavigationController setADC:[self allDataController]];
  }
  
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
  __unused bool j = [[self allDataController]didSaveEntities];
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view
// TODO: - implement setup logic
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[KVMapViewController class]] && ([(KVMapViewController *)[(UINavigationController *)secondaryViewController topViewController] currentEntity] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
