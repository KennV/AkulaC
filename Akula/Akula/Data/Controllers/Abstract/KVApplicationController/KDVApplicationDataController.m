/**
  KDVApplicationDataController.m
  Ajax01

  Created by Kenn Villegas on 12/23/17.
  Copyright © 2017 Kenn Villegas. All rights reserved.

*/

/**
Yeah there are a lot of fetches that I do not use but they only impact coverage by >5%
Soo I _could_ cover them or delete them
Let these be the last five pct that I chase
FWIW the subroutines in question are not nor have they ever been used in production ~BUT they may be useful in the OLDER Cocoa-Bindings where they came from (i.e. In a multi column view where the filter was on the topic of a given column)
*/

#import "KDVApplicationDataController.h"

@implementation KDVApplicationDataController
@synthesize fetchCon = _fetchCon;

- (instancetype)initAllUp {
  self = [self initWithAppName:@"Akula"
                  databaseName:@"Akula.sqlite"
                     className:@"KVAbstractEntity"];
  if (self) {
    
  }
  return self;
}
#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchCon {
  NSString *defaultKey = (@"incepDate");
  if (_fetchCon != nil) {
    return _fetchCon;
  }
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  /**
  Edit the entity name as appropriate. (Event, RootEntity, ABSTRACT_OBJ)
  */
  NSEntityDescription *entity =
  [NSEntityDescription entityForName:[self entityClassName]
              inManagedObjectContext:[self MOC]];
  [fetchRequest setEntity:entity];
  /**
  Set the batch size to a suitable number.
  */
  [fetchRequest setFetchBatchSize:20];
  /**
   Edit the sort key as appropriate.
   GENERALLY @"incepDate"
  */
  NSSortDescriptor *sortDescriptor =
  [[NSSortDescriptor alloc] initWithKey:(defaultKey)
                              ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];
  /**
  Edit the section name key path and cache name if appropriate.
  nil for section name key path means "no sections".
  */
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:([self MOC]) sectionNameKeyPath:nil cacheName:@"Master"];
  aFetchedResultsController.delegate = (self);
  self.fetchCon = aFetchedResultsController;
  
  NSError *error = nil;
  if (![[self fetchCon] performFetch:&error]) {
    NSLog(@"It is Fun \nAND Insightful to Know when and Why this happened");
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return _fetchCon;
}

- (NSMutableArray *)getEntities:(NSString *)entityName
                       sortedBy:(NSSortDescriptor *)sortDescriptor
              matchingPredicate:(NSPredicate *)predicate {
  
  NSError *error = nil;
  /**
  Create the request object
  */
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  /**
  Set the entity type to be fetched
  */
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self MOC]];
  [request setEntity:entity];
  
  /**
  Set the predicate if specified
  */
  if (predicate) {
    [request setPredicate:predicate];
  }
  
  /**
  Set the sort descriptor if specified
  */
  if (sortDescriptor) {
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
  }
  // Execute the fetch
  NSMutableArray *mutableFetchResults = [[[self MOC] executeFetchRequest:request error:&error] mutableCopy];
  if (mutableFetchResults == nil) {
    // Handle the error.
  }
  
  return mutableFetchResults;
}

- (NSMutableArray *)getAllEntities {
  return [self getEntities:[self entityClassName] sortedBy:nil matchingPredicate:nil];
}

- (NSMutableArray *)getEntitiesMatchingPredicate: (NSPredicate *)p {
  return [self getEntities:([self entityClassName]) sortedBy:nil matchingPredicate:p];
}

- (NSMutableArray *)getEntitiesMatchingPredicateString: (NSString *)predicateString, ...; {
  va_list variadicArguments;
  va_start(variadicArguments, predicateString);
  NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString
                                                  arguments:variadicArguments];
  va_end(variadicArguments);
  return [self getEntities:([self entityClassName]) sortedBy:nil matchingPredicate:predicate];
}

- (NSMutableArray *)getEntitiesSortedBy:(NSSortDescriptor *)sortDescriptor
                      matchingPredicate:(NSPredicate *)predicate {
  return [self getEntities:([self entityClassName]) sortedBy:sortDescriptor matchingPredicate:predicate];
}

- (NSMutableArray *)getEntities:(NSString *)entityName
                       sortedBy:(NSSortDescriptor *)sortDescriptor
        matchingPredicateString:(NSString *)predicateString, ...; {
  va_list variadicArguments;
  va_start(variadicArguments, predicateString);
  NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString
                                                  arguments:variadicArguments];
  va_end(variadicArguments);
  return [self getEntities:entityName sortedBy:sortDescriptor matchingPredicate:predicate];
}

#pragma mark - utilities

- (void)deleteEntity:(NSManagedObject *)e  {
  [[self MOC] deleteObject:e];
}

@end
