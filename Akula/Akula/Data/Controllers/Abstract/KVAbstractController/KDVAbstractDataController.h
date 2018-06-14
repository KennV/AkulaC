/**
  KDVAbstractDataController.h
  Ajax01

  Created by Kenn Villegas on 12/22/17.
  Copyright © 2017 Kenn Villegas. All rights reserved.

*/
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Akula+CoreDataModel.h"
//NEWER
//#import "KVAbstractEntity+CoreDataClass.h"
//#import "KVAbstractGraphicsEntity+CoreDataClass.h"
//#import "KVAbstractLocationEntity+CoreDataClass.h"
//#import "KVAbstractPhysics+CoreDataClass.h"
/**
OKrazy I need this to be in test from the get-go
But to do that need to define the test then fail it and init it
_then set a default init_
*/

@interface KDVAbstractDataController : NSObject <NSFetchedResultsControllerDelegate>

/**
 Default Init()

 @param a Current AppName
 @param d Current DatabaseName
 @param c Current ClassName
 @return Fully Valid Controller
 */
- (id)initWithAppName:(NSString*)a databaseName:(NSString*)d className:(NSString*)c;

/*Surprisingly Important
 Rithout these ivars you __Will Fail__ init() in MOM, PCONT, MOC, and PSK in that order
 */

/**
 REQUIRED DATA:
 Populates the
 - (NSManagedObjectModel *)MOM
 */
@property (nonatomic, copy) NSString* applicationName;

/**
 REQUIRED DATA:
 Populates the
 - (NSPersistentStoreCoordinator *)PSK
 */
@property (nonatomic, copy) NSString* databaseName;

/**
 REQUIRED DATA:
 Populates the
 - (NSFetchedResultsController *)fetchCon
 */
@property (nonatomic, copy) NSString* entityClassName;
/*these are constructed from those */

/**
 Workable Content Area
 */
@property (nonatomic, retain) NSManagedObjectContext *MOC;

@property (nonatomic, assign) BOOL copyDatabaseIfNotPresent;

/**
 Model derived from the applicationName
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *MOM;

@property (strong, nonatomic) NSPersistentStoreCoordinator *PSK;

@property (readonly, strong) NSPersistentContainer *container;

/**
 Gets ALL Entities of this type
 */
@property (strong, nonatomic) NSFetchedResultsController *fetchCon;
- (void)performAutomaticLightweightMigration;
@end
