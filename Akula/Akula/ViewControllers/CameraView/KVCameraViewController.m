/**
  KVCameraViewController.m
  Akula

  Created by Kenn Villegas on 3/26/19.
  Copyright © 2019 Kenn Villegas. All rights reserved.

 
 SIDENOTE:
the first time around It took the object
Second Time Just the photo
This time around it will be a more complete implementation of the first one with an object and a MOC or Some controller AAMOF it could be done in protocols for what it is worth
AND Speaking on Protocols what does a camera contoller actually do in Cocoa? I mean before I go re-inventing the wheel and junk. I mean I can reverse the Swift Implementation that I have in Tricorder with an MVP in this the CurrentBuild v.16
AND ALSO  since it is loading the view nil, am I really wired up in the XIB?(yup) then I would prefer to fix the AppDelegate level issues first

 B4 I go haywire can I set a Delegate and does it persist
The Current state of teh Bug is that I CAN start the segue wit these ivars but they are nil when viewDidLoad/…Appear
THIS IS PROBLAMATIC B\C
1.> I Know That the Ivar are settable and BEING Set
2.> I Know that the ivar Types are identical to the class above where it works
 
*/

#import "KVCameraViewController.h"

@interface KVCameraViewController()
@property (weak, nonatomic) IBOutlet UILabel *miLabel;

@end

@implementation KVCameraViewController

@synthesize CurrentPerson = _CurrentPerson;
@synthesize PDC = _PDC;

@synthesize miLabel = _miLabel;
-(void)setCurrentPerson:(KVPerson *)p {
  if (_CurrentPerson != p) {
    _CurrentPerson = p;
    [self configureView];
  }
}

-(KVPerson *)CurrentPerson {
  return _CurrentPerson;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self configureView];
  
}
- (void)configureView {
  if ([self CurrentPerson]) {
//    NSLog(@"Powa");
    [[self miLabel]setText:([[self CurrentPerson]firstName])];
  }
//   [[self miLabel]setText:(@"Howdy")];
  
  // Okay kinda lets try -
//  if ([self miLabel]) {
//    [[self miLabel]setText:[[self CurrentPerson]firstName]];
//  } else {
//    [[self miLabel]setText:(@"Howdy")];
//  }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
