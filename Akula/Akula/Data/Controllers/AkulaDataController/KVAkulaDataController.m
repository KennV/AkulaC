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

const NSString *FEMALE_NAME[20] =  { @"Jessica", @"Ashley", @"Amanda", @"Sarah", @"Jennifer", @"Brittany", @"Stephanie", @"Samantha", @"Nicole", @"Elizabeth", @"Lauren", @"Megan", @"Tiffany", @"Heather", @"Amber", @"Melissa", @"Danielle", @"Emily", @"Rachel", @"Kayla "};
const NSString *MALE_NAME[20] = {@"Michael", @"Christopher", @"Matthew", @"Joshua", @"Andrew", @"David", @"Justin", @"Daniel", @"James", @"Robert", @"John",
  @"Joseph", @"Ryan", @"Nicholas", @"Jonathan", @"William", @"Brandon", @"Anthony", @"Kevin", @"Eric "};
const NSString *LAST_NAME[20] = {@"Cero", @"Uno", @"Dos", @"Tres", @"Quatro", @"Cinco", @"Seis", @"Siete", @"Ocho", @"Nueve", @"Diez", @"Once", @"Doce", @"Triece", @"Catorce", @"Quince", @"Diesiseis", @"Dies y Siete", @"Diez y Ochco", @"Diez y Nueve"};
const NSString *STREET_NAMES[26] = {@"apple", @"birch", @"cherry", @"dogwood", @"ebony", @"fig", @"ginko", @"hickory", @"inode", @"juniper", @"katsura", @"larch", @"mahogany", @"nutmeg", @"oak", @"palm", @"qwest-tree", @"rosewood", @"spruce", @"teak", @"umbrella-tree", @"viburnum", @"walnut", @"xylosma", @"yucca", @"zelkova"};
const NSString *CITIES [9] = {@"New York", @"Boston", @"Philadelphia", @"Baltimore", @"Atlanta", @"Newark", @"Austin", @"Chicago", @"Pittsburgh"};
const NSString *STATES[9] = {@"NY", @"MA", @"MA", @"MD", @"GA", @"NJ", @"TX", @"IL", @"PA"};
//

- (instancetype)initAllUp {
  return ([self initWithAppName:(@"Akula") databaseName:(@"Akula.sqlite") className:(@"KVRootEntity")]);
}

-(KVRootEntity *)createEntityInMOC:(NSManagedObjectContext*)m {
  
  if (m == nil) {
    m = [self MOC];
  }
  
  KVRootEntity * rEntity = [NSEntityDescription insertNewObjectForEntityForName:[self entityClassName]inManagedObjectContext:(m)];
  KVAbstractPhysics * aep = [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractPhysics") inManagedObjectContext:(m)];
  KVAbstractGraphicsEntity * aeg = [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractGraphicsEntity") inManagedObjectContext:(m)];
  KVAbstractLocationEntity * ael = [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractLocationEntity") inManagedObjectContext:(m)];
  
  [rEntity setIncepDate:[NSDate date]];
  [rEntity setPhysics:(aep)];
  [rEntity setGraphics:(aeg)];
  [rEntity setLocation:(ael)];
  
  return rEntity;
}
@end
