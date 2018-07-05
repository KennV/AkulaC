/**
  KDVApplicationDataController.h
  Ajax01

  Created by Kenn Villegas on 12/23/17.
  Copyright © 2017 Kenn Villegas. All rights reserved.

*/
#import "KDVAbstractDataController.h"
//#import "KDVApplicationEntity+CoreDataClass.h"

@interface KDVApplicationDataController <T:NSManagedObject*> : KDVAbstractDataController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController <KVAbstractEntity *> *fetchCon;
- (instancetype)initAllUp;


- (NSMutableArray *)getEntities:(NSString *)entityName sortedBy:(NSSortDescriptor *)sortDescriptor matchingPredicate:(NSPredicate *)predicate;

/**
 All Entities
 
 @return All entities of this class type
*/
- (NSMutableArray *)getAllEntities;

/**
 Gets entities of the default type matching the predicate

 @param p NSPred
 @return All entities of class type Matching (p)
*/
- (NSMutableArray *)getEntitiesMatchingPredicate: (NSPredicate *)p;

/**
 Gets entities of the default type matching the predicate string

 @param predicateString Predicate Description
 @return Entities matching the predicate string
*/
- (NSMutableArray *)getEntitiesMatchingPredicateString: (NSString *)predicateString, ...;

/**
 Gets Sorted and Filtered Entities

 @param entityName Class Name for this Controller
 @param sortDescriptor NSSortDescriptor
 @param predicateString Filter String
 @return Sorted and Filtered Entities
 */
- (NSMutableArray *)getEntities:(NSString *)entityName
                       sortedBy:(NSSortDescriptor *)sortDescriptor
        matchingPredicateString:(NSString *)predicateString, ...;

/**
 Delete the specified entity

 @param e That Entity
*/
- (void)deleteEntity:(NSManagedObject *)e;

/**
 Basic Number Generator
 
 @param range Allowed Range
 @return Number within Range
 */
- (int)makeRandomNumber:(int)range;

/**
 D & D Style Number Generator
 
 @param rolls Number of Rolls
 @param range Number within Range
 @return Number within Rolls * Range
 */
- (int)makeRandomNumberCurve:(int)rolls :(int)range;

@end
