/**
  KVPersonDataController.h
  Akula

  Created by Kenn Villegas on 6/19/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.
*/

#import <Foundation/Foundation.h>

#import "KVEntitiesDataController.h"
#import "KVPerson+CoreDataProperties.h"

#import "KVTasksDataController.h"


@protocol PersonActionProtocol

- (BOOL)didChangePerson:(id<PersonActionProtocol>)deli withPerson:(KVPerson*)p;
@optional

- (BOOL)didModifyTasksForPerson:(id<PersonActionProtocol>)deli
                   withTasksCon:(KVTasksDataController*)tkon
                         person:(KVPerson*)p;
@end


@interface KVPersonDataController <T:KVPerson*> : KVEntitiesDataController<T>

@property(weak,nonatomic)id<PersonActionProtocol> delegate;

- (KVPerson*)makeNewPersonInMOC:(NSManagedObjectContext*)m;
//- (id)createPersoninMOC:(NSManagedObjectContext*)m;
- (void)randomizePersonName:(KVPerson*)p;
- (void)resetDefaultPerson:(KVPerson*)newP;
@end
