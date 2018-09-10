/**
  KVTasksDataController.h
  Akula

  Created by Kenn Villegas on 7/23/18.
  Copyright © 2018 Kenn Villegas. All rights reserved.

*/
/**
 OKAY just like *Person …*Task is a rich class.
 AAMOF I feel like the entity/item layer could short circuit to nil with no mal effects. That is not in this build.
 I already wrote a stub interface for *Person
 BUT what I really need is for *Task to initWithPerson:(id)p
*/
#import "KVTask+CoreDataClass.h"
#import "KVItemsDataController.h"

@protocol TasksActionProtocol
- (void)willAddTaskInDelegate:(id<TasksActionProtocol>)deli;
@optional
/**
 below is an excellent example of a protocol signature.
 it is an action on a state with an unambigous return / effect
 It declares it's purpose / intent
*/

- (BOOL)didBindTaskFor:(id<TasksActionProtocol>)deli
              withTask:(KVTask*)t
              toPerson:(KVPerson*)p;
@end

@interface KVTasksDataController <T : KVTask*> : KVItemsDataController <T>
@property(weak,nonatomic)id<TasksActionProtocol> delegate;
@end
