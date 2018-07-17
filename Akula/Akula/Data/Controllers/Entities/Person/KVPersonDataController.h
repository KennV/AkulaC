/**
  KVPersonDataController.h
  Akula

  Created by Kenn Villegas on 6/19/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
*/

#import <Foundation/Foundation.h>
//#import "KVAkulaDataController.h"
#import "KVEntitiesDataController.h"
#import "KVPerson+CoreDataProperties.h"

@protocol PersonDataProtocol

@optional
///Good signatures but these would go into the PersonController
- (BOOL)didChangePerson:(id<PersonDataProtocol>)deli withPerson:(KVPerson*)p;

@end


@interface KVPersonDataController <T:KVPerson*> : KVEntitiesDataController<T>

- (KVPerson*)createEntityInMOC:(NSManagedObjectContext*)m;
//- (id)createPersoninMOC:(NSManagedObjectContext*)m;
- (void)randomizePersonName:(KVPerson*)p;
- (void)resetDefaultPerson:(KVPerson*)newP;
@end
