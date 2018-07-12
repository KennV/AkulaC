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

- (KVAbstractPhysics*)mkPhysSubEntityFor:(id)e in:(NSManagedObjectContext*)ctx {
  return [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractPhysics") inManagedObjectContext:(ctx)];
}

- (KVAbstractGraphicsEntity*)mkGraphicsSubEntityFor:(id)e in:(NSManagedObjectContext*)ctx {
  return [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractGraphicsEntity") inManagedObjectContext:(ctx)];
}

- (KVAbstractLocationEntity*)mkLocationSubEntityFor:(id)e in:(NSManagedObjectContext*)ctx {
  return [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractLocationEntity") inManagedObjectContext:(ctx)];
}


- (BOOL)didSaveEntities
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.MOC;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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


- (KVRootEntity *)createEntityInMOC:(NSManagedObjectContext*)m {
  
  if (m == nil) {
    m = [self MOC];
  }
  
  KVRootEntity * rEntity = [NSEntityDescription insertNewObjectForEntityForName:[self entityClassName]inManagedObjectContext:(m)];
  
  [rEntity setIncepDate:[NSDate date]];
  [rEntity setDbID:[NSUUID UUID]];
  [rEntity setPhysics:([self mkPhysSubEntityFor:rEntity in:m])];
  [rEntity setLocation:([self mkLocationSubEntityFor:rEntity in:m])];
  [rEntity setGraphics:([self mkGraphicsSubEntityFor:rEntity in:m])];
  
  [[rEntity physics]setOwner:rEntity];
  [[rEntity location]setOwner:rEntity];
  [[rEntity graphics]setOwner:rEntity];
  
  NSError *error = nil;
  if (![[self MOC] save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    //NSCocoaErrorDomain Code=1570
    //required fields set to nil see xcdm
    abort();
  } else {
    return rEntity;
  }
}



@end
