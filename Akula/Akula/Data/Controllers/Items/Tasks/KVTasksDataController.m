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


- (instancetype)initAllUp {
  return ([self initWithAppName:(@"Akula") databaseName:@"Akula.sqlite" className:@"KVTask"]);
}
- (KVTask*)makeNewTaskInMOC:(NSManagedObjectContext*)m {
//  return (KVTask *)([self makeNewEntityInMOC:m]);
//FIXME: ¿DaAKTUALFuck?
  KVTask *t = ([self makeNewEntityInMOC:m]);
  return t;
}
@end
