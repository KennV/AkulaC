/**
  KVAkulaDataController.h
  Akula

  Created by Kenn Villegas on 1/14/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.

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


/**
 DEFAULT CREATE ENTITY

 @param m MOC
 @return Entity - All Up
 */
- (KVRootEntity *)createEntityInMOC:(NSManagedObjectContext*)m;

@end
