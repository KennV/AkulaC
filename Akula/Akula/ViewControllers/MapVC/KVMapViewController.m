/**
 DetailViewController.m
 Akula
 
 Created by Kenn Villegas on 1/11/18.
 Copyright © 2018 Kenn Villegas. All rights reserved.
This Software, Including its source code, binaries and indermediate derived libraies, objects and data are Propery of Kenneth D. Villegas and are not licensed for Free or Open Source usage. Nor Licensed to be extended by any third party or sub licensee contrator nor entity regardless of any contractural claims otherwise.
This Remains The Intellectual Property of Kenneth D. Villegas as owner with all Inherent rights reserved under law maintained by Kenneth D. Villegas

 
*/

#import "KVMapViewController.h"

@interface KVMapViewController ()

@end

@implementation KVMapViewController

- (void)configureView {
  // Update the user interface for the detail item.
  if (self.currentEntity) {
      self.entityDescriptionLabel.text = [self.currentEntity description];
  }
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setCurrentEntity:(KVRootEntity *)newDetailItem {
  if (_currentEntity != newDetailItem) {
      _currentEntity = newDetailItem;
      
      // Update the view.
      [self configureView];
  }
}


@end
