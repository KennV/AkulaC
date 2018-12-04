/**
  KVAkulaDataController.m
  Akula

  Created by Kenn Villegas on 1/14/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

*/

#import "KVAkulaDataController.h"


@implementation KVAkulaDataController

const NSString *HEX_DIGIT[16] = {@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f"};

const NSString *STREET_NAMES[26] = {@"apple", @"birch", @"cherry", @"dogwood", @"ebony", @"fig", @"ginko", @"hickory", @"inode", @"juniper", @"katsura", @"larch", @"mahogany", @"nutmeg", @"oak", @"palm", @"qwest-tree", @"rosewood", @"spruce", @"teak", @"umbrella-tree", @"viburnum", @"walnut", @"xylosma", @"yucca", @"zelkova"};
const NSString *CITIES [9] = {@"New York", @"Boston", @"Philadelphia", @"Baltimore", @"Atlanta", @"Newark", @"Austin", @"Chicago", @"Pittsburgh"};
const NSString *STATES[9] = {@"NY", @"MA", @"MA", @"MD", @"GA", @"NJ", @"TX", @"IL", @"PA"};


- (instancetype)initAllUp {
  return ([self initWithAppName:(@"Akula") databaseName:(@"Akula.sqlite") className:(@"KVRootEntity")]);
}


/**
 For Clarity's Sake I am pulling these here
 */

- (KVAbstractPhysics*)makePhysSubEntityFor:(id)e In:(NSManagedObjectContext*)ctx {
  KVAbstractPhysics *p = [[KVAbstractPhysics alloc]initWithContext:ctx];
  [p setOwner:e];
  return (p);
}

- (KVAbstractGraphicsEntity*)makeGraphicsSubEntityFor:(id)e In:(NSManagedObjectContext*)ctx {
  KVAbstractGraphicsEntity *g = [[KVAbstractGraphicsEntity alloc]initWithContext:ctx];
  [g setOwner:e];
  return (g);
}

- (KVAbstractLocationEntity*)makeLocationSubEntityFor:(id)e In:(NSManagedObjectContext*)ctx {
  KVAbstractLocationEntity *l = [[KVAbstractLocationEntity alloc]initWithContext:ctx];
  [l setOwner:e];
  return l;
}

- (BOOL)didSaveEntities {
  NSError *error = nil;
  NSManagedObjectContext *m = [self MOC];
  if (m != nil) {
    if ([m hasChanges] && ![m save:&error]) {
      /**
       NSCocoaErrorDomain Code=1570
       required fields set to nil see xcdm
       Replace this implementation with code to handle the error appropriately.
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
  return (true);
}

- (NSString*)createFemaleName {
  NSString *FEMALE_NAME[20] =  { @"Jessica", @"Ashley", @"Amanda", @"Sarah", @"Jennifer", @"Brittany", @"Stephanie", @"Samantha", @"Nicole", @"Elizabeth", @"Lauren", @"Megan", @"Tiffany", @"Heather", @"Amber", @"Melissa", @"Danielle", @"Emily", @"Rachel", @"Kayla "};
  return (FEMALE_NAME[[self makeRandomNumber:(20)]]);
}

- (NSString*)createLastName {
  NSString *LAST_NAME[20] = {@"Cero", @"Uno", @"Dos", @"Tres", @"Quatro", @"Cinco", @"Seis", @"Siete", @"Ocho", @"Nueve", @"Diez", @"Once", @"Doce", @"Triece", @"Catorce", @"Quince", @"Diesiseis", @"Dies y Siete", @"Diez y Ochco", @"Diez y Nueve"};
  
  NSString *name = (@"");
  name = LAST_NAME[[self makeRandomNumber:20]];
  return (name);
}

- (NSString*)createMaleName {
  NSString *MALE_NAME[20] = {@"Michael", @"Christopher", @"Matthew", @"Joshua", @"Andrew", @"David", @"Justin", @"Daniel", @"James", @"Robert", @"John",@"Joseph", @"Ryan", @"Nicholas", @"Jonathan", @"William", @"Brandon", @"Anthony", @"Kevin", @"Eric "};
  return (MALE_NAME[[self makeRandomNumber:(20)]]);
}

- (NSString*)createMiddleName {

  if ((int)[self makeRandomNumber:1000] < 750) {
    //75% will have a middle name
    if ((int)[self makeRandomNumber:1000] < 800) {
      //80% will have a female name
      return ([self createFemaleName]);
    } else {
      //the other 20% will have a male name
      return ([self createMaleName]);
    }
  } else {
    //25% will have no Middle Name
    return (@"");
  }
  
}

/**
 These next two look like they would be forward recievers, however they work…
*/

- (KVRootEntity *)makeNewEntityInMOC:(NSManagedObjectContext*)ctx {
  if (ctx == nil) {
    ctx = [self MOC];
  }
  KVRootEntity *entity = [[KVRootEntity alloc]initWithContext:ctx];
  [entity setIncepDate:[NSDate date]];
  [entity setDbID:[NSUUID  UUID]];
  
  [entity setPhysics:([self makePhysSubEntityFor:entity In:ctx])];
  [entity setLocation:([self makeLocationSubEntityFor:entity In:ctx])];
  [entity setGraphics:([self makeGraphicsSubEntityFor:entity In:ctx])];
  
  return entity;
}

- (KVPerson *)makeNewPersonInMOC:(NSManagedObjectContext*)ctx {
  if (ctx == nil) {
    ctx = [self MOC];
  }
  KVPerson *p = [[KVPerson alloc]initWithContext:ctx];
  [p setIncepDate:[NSDate date]];
  [p setDbID:[NSUUID  UUID]];
  
  [p setPhysics:([self makePhysSubEntityFor:p In:ctx])];
  [p setLocation:([self makeLocationSubEntityFor:p In:ctx])];
  [p setGraphics:([self makeGraphicsSubEntityFor:p In:ctx])];
  
  return p;
}

@end
