/**
 KDVAbstractDataController.m
 Ajax01
 
 Created by Kenn Villegas on 12/22/17.
 Copyright © 2017 Kenn Villegas. All rights reserved.
 
*/

#import "KDVAbstractDataController.h"

@implementation KDVAbstractDataController

@synthesize applicationName = _applicationName;
@synthesize databaseName = _databaseName;
@synthesize entityClassName = _entityClassName;

@synthesize MOC = _MOC;
@synthesize MOM = _MOM;
@synthesize PSX = _PSX;
@synthesize container = _container;
@synthesize fetchCon = _fetchCon;
@synthesize copyDatabaseIfNotPresent = _copyDatabaseIfNotPresent;

/**
 Default init

 @param a Application Name
 @param d Database Name
 @param c Class EntityClassName
 @return New Entity Controller
*/
- (instancetype)initWithAppName:(NSString*)a
                   databaseName:(NSString*)d
                      className:(NSString*)c
{
  if (!(self = [super init]))
  {
    return (nil);
  }
  _applicationName = a;
  _databaseName = d;
  _entityClassName = c;
  _copyDatabaseIfNotPresent = YES; //newer
  return self;
}

- (instancetype)init
{
  return ([self initWithAppName:(@"Akula")
                   databaseName:(@"Akula.sqlite")
                      className:(@"KVAbstractEntity")]);
}

#pragma mark - Core Data stack
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)MOM
{
  if (_MOM != nil) {
    return _MOM;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:[self applicationName] withExtension:@"momd"];
  _MOM = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _MOM;
}
// Part two of Lightweight Migration
// FIXME: Test and Implement Lightweight Migration
- (NSPersistentStoreCoordinator *)PSX
{
  if (_PSX != nil)
  {
    return _PSX;
  }
  _PSX = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self MOM]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[self databaseName]];
  NSError *error = nil;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  if (![_PSX addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return _PSX;
}

- (NSManagedObjectContext *)MOC
{
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_MOC != nil)
  {
    return _MOC;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self PSX];
  if (!coordinator)
  {
    return nil;
  }
  _MOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [_MOC setPersistentStoreCoordinator:coordinator];
  return _MOC;
}

- (NSPersistentContainer *)container
{
  // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
  @synchronized (self) {
    if (_container == nil) {
      _container = [[NSPersistentContainer alloc] initWithName:[self applicationName]];
      [_container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error != nil) {
          // Replace this implementation with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          
          /*
           Typical reasons for an error here include:
           * The parent directory does not exist, cannot be created, or disallows writing.
           * The persistent store is not accessible, due to permissions or data protection when the device is locked.
           * The device is out of space.
           * The store could not be migrated to the current model version.
           Check the error message to determine what the actual problem was.
           */
          NSLog(@"Unresolved error %@, %@", error, error.userInfo);
          abort();
        }
      }];
    }
  }
  
  return _container;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchCon
{
  NSString *defaultKey = (@"incepDate");
  if (_fetchCon != nil) {
    return _fetchCon;
  }
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate. (Event, RootEntity, ABSTRACT_OBJ)
  NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityClassName inManagedObjectContext:self.MOC];
  
  [fetchRequest setEntity:entity];
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  // Edit the sort key as appropriate.
  // GENERALLY @"incepDate"
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(defaultKey) ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.MOC sectionNameKeyPath:nil cacheName:@"Master"];
  aFetchedResultsController.delegate = self;
  self.fetchCon = aFetchedResultsController;
  
  NSError *error = nil;
  
  if (![self.fetchCon performFetch:&error])
  {
    NSLog(@"It is Fun \nAND Insightful to Know when and Why this happened");
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return _fetchCon;
}

- (void)performAutomaticLightweightMigration 
{
  
  NSError *error;
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", [self databaseName], @".sqlite"]];
  
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                           [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
  
  if (![_PSX addPersistentStoreWithType:NSSQLiteStoreType
                          configuration:nil
                                    URL:storeURL
                                options:options
                                  error:&error]){
    // Handle the error.
  }
}


@end
