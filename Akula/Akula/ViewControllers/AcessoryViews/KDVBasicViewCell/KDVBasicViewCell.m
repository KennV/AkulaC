//
//  KDVPersonViewCell.m
//  Akula
//
//  Created by Kenn Villegas on 7/7/20.
//  Copyright © 2020 Kenn Villegas. All rights reserved.
//

#import "KDVBasicViewCell.h"

@implementation KDVBasicViewCell
@synthesize thumbnailImage = _thumbnailImage;
@synthesize nameLabel = _nameLabel;
@synthesize captionLabel = _captionLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
