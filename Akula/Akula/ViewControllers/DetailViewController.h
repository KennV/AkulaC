//
//  DetailViewController.h
//  Akula
//
//  Created by Kenn Villegas on 1/11/18.
//  Copyright © 2018 Kenn Villegas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

