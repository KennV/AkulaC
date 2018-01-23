/**
 MasterViewController.m
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

 
*/

/**
Okay this is where the rubber meets the road.

- I have an NSMutableArray of objects
- This needs to be an NSArray of RootEntities or better
 - Non Mutable

 
Hella trippy
• I thought I had a bug,
• Worse YET I don't have a save() routine in here so I can't tell if I am writing to a real db. B\C I am not even working with a db in this state of teh template.

*thus* the next step is to write a save function
 
OOOPS DON'T BE A BITCH.
I NEED +Colors and effects, {See Accesessory Views Folder}
 
isHiddenIfYes(Bool)
Different Tupes of controllers for sections
number of sections
 (* OIC *)
 sectionCount. { %KVCDataCon%:getAllEntities.count}

THEN after all of that I might want a protocol for this controller. Jeppers

WOW I thought I did a commit, I was about to add an appDataCon and probably a getter for akulaEntities helping me decide if it is mutable or not.

*/

#import "KVPrimeTableViewController.h"
#import "KVMapViewController.h"

@interface KVPrimeTableViewController ()
// HEY THIS
@property NSMutableArray *akulaEntities;

// so for expediancy I made a cheap CLUT without the table or dict even
@property (weak, nonatomic)UIColor *color00;
@property (weak, nonatomic)UIColor *color01;
@property (weak, nonatomic)UIColor *color02;
@property (weak, nonatomic)UIColor *color03;

@property (weak, nonatomic)UIColor *color10;
@property (weak, nonatomic)UIColor *color11;
@property (weak, nonatomic)UIColor *color12;
@property (weak, nonatomic)UIColor *color13;

@property (weak, nonatomic)UIColor *buttonBaseColor;
@property (weak, nonatomic)UIColor *buttonSelectedColor;
@property (weak, nonatomic)UIColor *buttonTextColor;
@property (weak, nonatomic)UIColor *buttonTextAltColor;

@property (weak, nonatomic)UIColor *altTextColor;
@property (weak, nonatomic)UIColor *baseTextColor;
@property (weak, nonatomic)UIColor *hilightTextColor;
@property (weak, nonatomic)UIColor *specialTextColor;
//I expect that these will also be refactored into sensible names


@end

@implementation KVPrimeTableViewController
// Them colors
@synthesize color00 = _color00;
@synthesize color01 = _color01;
@synthesize color02 = _color02;
@synthesize color03 = _color03;

@synthesize color10 = _color10;
@synthesize color11 = _color11;
@synthesize color12 = _color12;
@synthesize color13 = _color13;

@synthesize buttonBaseColor = _buttonBaseColor;
@synthesize buttonSelectedColor = _buttonSelectedColor;
@synthesize buttonTextColor = _buttonTextColor;
@synthesize buttonTextAltColor = _buttonTextAltColor;

@synthesize altTextColor = _altTextColor;
@synthesize baseTextColor = _baseTextColor;
@synthesize hilightTextColor = _hilightTextColor;
@synthesize specialTextColor = _specialTextColor;

- (void)viewDidLoad {
  [super viewDidLoad];
  // TODO: Customization Point for this controller
  self.navigationItem.leftBarButtonItem = self.editButtonItem;

  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
  self.mapViewController = (KVMapViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
  self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
// TODO: Replace This with a controller function preferably from a delegate
- (void)insertNewObject:(id)sender {
  if (!self.akulaEntities) {
      self.akulaEntities = [[NSMutableArray alloc] init];
  }
  [self.akulaEntities insertObject:[NSDate date] atIndex:0];
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      NSDate *object = self.akulaEntities[indexPath.row];
      KVMapViewController *controller = (KVMapViewController *)[[segue destinationViewController] topViewController];
      [controller setCurrentEntity:object];
      controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
      controller.navigationItem.leftItemsSupplementBackButton = YES;
  }
}

#pragma mark - DataSource
/**
// First this must be synthed
- (NSMutableArray *)entities {
  return nil;
}
*/
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.akulaEntities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

  NSDate *object = self.akulaEntities[indexPath.row];
  cell.textLabel.text = [object description];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
      [self.akulaEntities removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}


@end
