/**
 
*/
#import <UIKit/UIKit.h>

#import "KVPersonDataController.h"

@interface KVCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(weak,nonatomic)KVPerson* CurrentPerson;
@property (weak, nonatomic) KVPersonDataController* PDC;
//last ditch - Ditch Witch Bitch?!?!
- (id)initWithDataCon:(KVPersonDataController*)c Persron:(KVPerson*)p;
@end
