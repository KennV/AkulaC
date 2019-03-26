/**

*/
#import "KVCameraViewController.h"
/**
Okay
 the first time around It took the object
 Second Time Just the photo
 This time around it will be a more complete implementation of the first one with an object and a MOC or Some controller AAMOF it could be done in protocols for what it is worth
AND Speaking on Protocols what does a camera contoller actually do in Cocoa? I mean before I go re-inventing the wheel and junk. I mean I can reverse the Swift Implementation that I have in Tricorder with an MVP in this the CurrentBuild v.16
 AND ALSO  since it is loading the view nil, am I really wired up in the XIB?(yup) then I would prefer to fix the AppDelegate level issues first
*/
@interface KVCameraViewController()

@end

@implementation KVCameraViewController 
@synthesize CurrentPerson = _CurrentPerson;
@synthesize PDC = _PDC;

-(instancetype)init {
  if (!(self = [super init])) return nil;
  return (self);
}

- (id)initWithDataCon:(KVPersonDataController*)c Persron:(KVPerson*)p {
  self = [self init];
  [self setPDC:c];
  [self setCurrentPerson:p];
  NSLog(@"Saxifrage Russel");
  return (self);
}

-(void)viewWillAppear:(BOOL)animated {
  NSLog(@"¿Powa?");
  [super viewDidLoad];

}
-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:true];
  //OK i'm nil x nil here
}
@end
