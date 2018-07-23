//
//  KVTasksDataController.h
//  Akula
//
//  Created by Kenn Villegas on 7/23/18.
//  Copyright © 2018 Kenn Villegas. All rights reserved.
//

#import "KVTask+CoreDataClass.h"
#import "KVItemsDataController.h"

@interface KVTasksDataController <T : KVTask*> : KVItemsDataController <T>

@end
