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
@synthesize delegate = _delegate;

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
- (KVPerson*)makeNewPersonInMOC:(NSManagedObjectContext*)m {
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
  if ((int)[self makeRandomNumber:(1000)] < 500) {
    [p setGender:(@"female")];
  } else {
    [p setGender:(@"male")];
  }
  
  [self randomizePersonName:p]; //reactivated person name
  
//  [self randomizeContactInformation:p];
  
  
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

- (void)resetDefaultPerson:(KVPerson*)newP {
  NSString *def1 = (@"Edit-Me");
  [newP setGender:(def1)];
  [newP setFirstName:(def1)];
  [newP setLastName:(def1)];
  [newP setMiddleName:(def1)];
  [newP setPhoneNumber:(@"(101)555-4321")];
  [newP setEmailID:([def1 stringByAppendingString:@"@One.edu"])];
  [newP setTextID:[def1 stringByAppendingString:(@"@Scv.net")]];
  
}

- (void)randomizePersonName:(KVPerson*)p {
  
  if ([[p gender]isEqualToString:(@"Male")]||[[p gender]isEqualToString:(@"male")]) {
    [p setFirstName:[super createMaleName]];
  } else {
    [p setFirstName:[super createFemaleName]];
  }

  [p setLastName:[self createLastName]];
  [p setMiddleName:[self createMiddleName]];

}

//- (void)randomizeContactInformation:(KVPerson*)p {
//
//  NSDictionary *jive = @{@"Philadelphia1" : @217, @"Philadelphia2" : @267, @"Bronx1" : @718, @"Bronx2" : @347, @"Bronx3" : @929, @"Connecticut1" : @203, @"Connecticut2" : @860, @"Connecticut3" : @475, @"Portland1" : @503, @"Portland2" : @541, @"Portland3" : @971, @"Portland4" : @458, @"Manhattan1" : @212, @"Manhattan2" : @646, @"Manhattan3" : @332, @"Baltimore1" : @410, @"Baltimore2" : @443, @"Austin1" : @512, @"Austin2" : @737, @"Phoenix1" : @602, @"Phoenix2" : @480, @"Phoenix3" : @520, @"Phoenix4" : @928, @"Phoenix5" : @623, @"Chicago1" : @312, @"Chicago2" : @847, @"Chicago3" : @773, @"Chicago4" : @630, @"Chicago5" : @815};
////  __unused UInt16 K = [Jive count];
//  if ([jive count] > 1) {
//    ;
//  }
//}

@end
