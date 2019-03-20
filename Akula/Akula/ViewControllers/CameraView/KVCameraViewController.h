/**
 
*/
#import <UIKit/UIKit.h>

#import "KVPersonDataController.h"

@interface KVCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(weak,nonatomic)KVPerson* CurrentPerson;
@property (strong, nonatomic) KVPersonDataController* PDC;
@end
