/**
  KDVApplicationDataController.m
  Ajax01

  Created by Kenn Villegas on 12/23/17.
  Copyright © 2017 Kenn Villegas. All rights reserved.

*/

#import "KDVApplicationDataController.h"

@implementation KDVApplicationDataController

@synthesize fetchCon = _fetchCon;

- (instancetype)initAllUp
{
  if (!(self = [self initWithAppName:@"Akula"
                        databaseName:@"Akula.sqlite"
                           className:@"KVAbstractEntity"]))
  {
    NSLog(@"Class %@ failed to init",[self description]);
    return(nil);
  }
  return self;
}
#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchCon {
  NSString *defaultKey = (@"incepDate");
  if (_fetchCon != nil)
  {
    return _fetchCon;
  }
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  NSEntityDescription *entity =
  [NSEntityDescription entityForName:[self entityClassName]
              inManagedObjectContext:[self MOC]];
  [fetchRequest setEntity:entity];

  [fetchRequest setFetchBatchSize:20]; // batch size to a suitable number.
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

- (void)deleteEntity:(NSManagedObject *)e
{
  [[self MOC] deleteObject:e];
}

#pragma mark - Numerical Utilities

- (int)makeRandomNumber:(int)range {
  //  return arc4random_uniform(range);
  if (range <= 0)
  {
    return 1; // I shall not return 0
  }
  int candidate = arc4random_uniform(range);
  if (candidate > range)
  {
    return range; // Nor Return Greater than Range
  }
  if (candidate <= 0)
  {
    // And if I attempt to return 0
    candidate = 1; // I shall not return 0
  }
  return candidate;
}

- (int)makeRandomNumberCurve:(int)rolls :(int)range {
  int result = 0;
  if (rolls <=0)
  {
    return(result);
  }
  do
  {
    rolls -= 1;
    result += [self makeRandomNumber:(range)];
  } while (rolls > 0);
  return(result);
}

@end
