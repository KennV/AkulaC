//
//  KVPinItem.m
//  Akula
//
//  Created by Kenn Villegas on 7/26/18.
//  Copyright © 2018 Kenn Villegas. All rights reserved.
//

#import "KVPinItem.h"

@implementation KVPinItem
- (instancetype)init {
  return([super init]);
}

- (instancetype)initNewPinItemFor:(KVRootEntity*)entity At:(CLLocationCoordinate2D)coord; {
  if(!(self = [self initNewPinItemAt:coord])) return nil;

//  [self setPinColor:[UIColor blueColor]];
//  [self setCoordinate:coord];
  [self setTitle:[entity type]];
  [self setSubtitle:[entity type]];
//  self.loca
  
  return self;
}

- (instancetype)initNewPinItemAt:(CLLocationCoordinate2D)coord {
  if(!(self = [self init])) return nil;
//  self.title = (@"Hello");
  [self setTitle:(@"New Pin")];
//  [self set]
  return self;
}

@end
