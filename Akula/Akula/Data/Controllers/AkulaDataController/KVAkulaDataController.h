/**
  KVAkulaDataController.h
  Akula

  Created by Kenn Villegas on 1/14/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas


*/

#import "KDVApplicationDataController.h"
#import "KVRootEntity+CoreDataClass.h"


FOUNDATION_EXPORT NSString *HEX_DIGIT[16];
FOUNDATION_EXPORT NSString *FEMALE_NAME[20];
FOUNDATION_EXPORT NSString *MALE_NAME[20];
FOUNDATION_EXPORT NSString *LAST_NAME[20];
FOUNDATION_EXPORT NSString *STREET_NAMES[26];
FOUNDATION_EXPORT NSString *CITIES[9];
FOUNDATION_EXPORT NSString *STATES[9];

@interface KVAkulaDataController : KDVApplicationDataController

/**
 DEFAULT INITIALIZER

 @return AkulaDataCon - AllUP
*/
- (instancetype)initAllUp;
/**
 DEFAULT CREATE ENTITY
 
 @param m MOC
 @return Entity - All Up
 */
- (KVRootEntity *)createEntityInMOC:(NSManagedObjectContext*)m;

- (BOOL)saveEntities;


@end
