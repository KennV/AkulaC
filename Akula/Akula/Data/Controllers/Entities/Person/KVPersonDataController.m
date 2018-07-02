/**
  KVPersonDataController.m
  Akula

  Created by Kenn Villegas on 6/19/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
*/

#import "KVPersonDataController.h"

@interface KVPerson ()

//- (KVPerson*)PersonAllUp;

@end

@implementation KVPersonDataController

double DefaultLatitude = 37.33115792;
double DefaultLongitude = -122.03076853;

- (instancetype)init {
  return ([self initAllUp]);
}


- (instancetype)initAllUp {
  return ([self initWithAppName:(@"Akula") databaseName:@"Akula.sqlite" className:@"KVPerson"]);
}

/**- */
//- (BOOL)didSetupDefaultLocation:(id<MA_)a forPerson:(id)b fromDelegate:(id)c; {
//  return (false);
//}

- (KVPerson*)createEntityInMOC:(NSManagedObjectContext*)m {
  if (m == nil) {
    m = [self MOC];
  }
  /**
    Couch Front Porch in Baltimore
  double DefaultLatitude = 37.33115792;
  double DefaultLongitude = -122.03076853;
   */
  
  KVPerson * p = [NSEntityDescription insertNewObjectForEntityForName:[self entityClassName] inManagedObjectContext:(m)];
  KVAbstractPhysics *aep = [NSEntityDescription insertNewObjectForEntityForName:@"KVAbstractPhysics" inManagedObjectContext:(m)];
  KVAbstractGraphicsEntity * aeg = [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractGraphicsEntity") inManagedObjectContext:(m)];
  KVAbstractLocationEntity * ael = [NSEntityDescription insertNewObjectForEntityForName:(@"KVAbstractLocationEntity") inManagedObjectContext:(m)];
  
  [p setIncepDate:[NSDate date]];
  [p setDbID:[NSUUID UUID]];
  [p setPhysics:(aep)];
  [p setGraphics:(aeg)];
  [p setLocation:(ael)];
  
  if (DefaultLatitude != [[[p location]latitude]doubleValue]) {
    [[p location]setLatitude:[NSNumber numberWithDouble:(DefaultLatitude)]];
  }
  if (DefaultLongitude != [[[p location]longitude]doubleValue]) {
    [[p location]setLongitude:[NSNumber numberWithDouble:(DefaultLongitude)]];
  }
  
  NSError *error = nil;
  if (![[self MOC] save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    //NSCocoaErrorDomain Code=1570
    //required fields set to nil see xcdm
    abort();
  } else {
    return p;
  }  
}

@end
