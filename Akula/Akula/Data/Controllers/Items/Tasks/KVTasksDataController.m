//
//  KVTasksDataController.m
//  Akula
//
//  Created by Kenn Villegas on 7/23/18.
//  Copyright © 2018 Kenn Villegas. All rights reserved.
//

#import "KVTasksDataController.h"

@implementation KVTasksDataController
@synthesize delegate = _delegate;


//- (instancetype)initAllUp {
//

-(id)initAllUp  {
  // there is a reason I cant use this as an instanstancetype
  if (!(self = [super initWithAppName:(@"Akula") databaseName:@"Akula.sqlite" className:@"KVTask"])) {
    return (nil);
  }
  return(self);

}
- (KVTask*)makeOLDNewTaskInMOC:(NSManagedObjectContext*)m {
  KVTask *t =  (KVTask *)([self makeNewEntityInMOC:m]);
//  KVTask *t = ([self makeNewEntityInMOC:m]);
  return t;
}
/**
OKAY THIS IS WHERE IT IS IN THE SHITS
 Or at least as far as I can trace. I do seem to be able to make tasks from MapController so that is a benefit. And I have no doubt (*But I need to verify*) that I can also use the MapActions Callbacks to add new People to the PTVC. However
The Initializer chain for the KVPerson is Far FAR more complete than this one is. Now those are easy to fix but before I waste a few hours on that I would like to add some buttons to the table view controller.
 
ALSO NEED TO FIX: Some autolayout issues in the .nib

*/
- (KVTask*)makeNewTaskInMOC:(NSManagedObjectContext*)m {

  
   KVTask* entity = (KVTask *)[[KVTask  alloc]initWithContext:m];
  
   [entity setIncepDate:[NSDate date]];
   [entity setDbID:[NSUUID  UUID]];
   
//   [entity setPhysics:([super makePhysSubEntityFor:entity In:ctx])];
//   [entity setLocation:([self makeLocationSubEntityFor:entity In:ctx])];
//   [entity setGraphics:([self makeGraphicsSubEntityFor:entity In:ctx])];
   
   return entity;
  
//  return nil;
}
- (KVTask*)makeNewTaskInMOC:(NSManagedObjectContext*)m withPerson:(KVPerson*)p {
//  if (m == nil) {
    m = [self MOC];
//  }
  KVTask* t = (KVTask *)[[KVTask  alloc]initWithContext:m];

  [t setTaskMemo:(@"Edit-Me")];
  [t setTax:([NSNumber numberWithFloat:(0.00)])];
  [t setCost:([NSNumber numberWithFloat:(0.00)])];
  [t setType:(@"Edit-Me")];
  [t setQName:(@"Edit-Me")];
  [t setSkuID:(@"Edit-Me")];

  [t setIncepDate:[NSDate date]];
  [t setDbID:[NSUUID  UUID]];
  [t setTaskOwner:p];
  [[p taskList]setByAddingObject:t];
//  p.taskList.
  return t;
}
@end
