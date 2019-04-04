/**
  KVCameraViewController.h
  Akula

  Created by Kenn Villegas on 3/26/19.
  Copyright © 2019 Kenn Villegas. All rights reserved.

*/

#import <UIKit/UIKit.h>
#import "KVPersonDataController.h"

@protocol KVCamViewData

@end

//NS_ASSUME_NONNULL_BEGIN

@interface KVCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) id <KVCamViewData> CamDataSource;
@property (strong,nonatomic) KVPerson* CurrentPerson;
@property (weak, nonatomic) KVPersonDataController* PDC;

@end

//NS_ASSUME_NONNULL_END
