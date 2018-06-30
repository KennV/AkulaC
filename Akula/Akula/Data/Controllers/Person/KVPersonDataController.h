/**
  KVPersonDataController.h
  Akula

  Created by Kenn Villegas on 6/19/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "KVAkulaDataController.h"
#import "KVPerson+CoreDataProperties.h"

@interface KVPersonDataController <T:KVPerson*> : KVAkulaDataController<T>

- (KVPerson*)createEntityInMOC:(NSManagedObjectContext*)m;
//- (id)createPersoninMOC:(NSManagedObjectContext*)m;
@end
