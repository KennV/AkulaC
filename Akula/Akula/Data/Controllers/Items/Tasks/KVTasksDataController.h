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

@protocol TasksDataProtocol
- (BOOL)willAddTaskInDelegate:(id<TasksDataProtocol>)deli;
@optional

@end

@interface KVTasksDataController <T : KVTask*> : KVItemsDataController <T>
@property(weak,nonatomic)id<TasksDataProtocol> delegate;

- (KVTask*)makeNewTaskInMOC:(NSManagedObjectContext*)m;

@end
