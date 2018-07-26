//
//  KVPinItem.h
//  Akula
//
//  Created by Kenn Villegas on 7/26/18.
//  Copyright © 2018 Kenn Villegas. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "KVMapViewController.h"
#import "KVRootEntity+CoreDataClass.h"
@interface KVPinItem : MKPointAnnotation
-(instancetype)initNewPinItemFor:(KVRootEntity*)entity At:(CLLocationCoordinate2D)coord;
-(instancetype)initNewPinItemAt:(CLLocationCoordinate2D)coord;
@end
