//
//  OverlayItemCell.m
//  ZevCase
//
//  Created by Liming Zhang on 10/22/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "OverlayItemCell.h"

@implementation OverlayItemCell
@synthesize _imgIcon;
@synthesize _lblOverlay;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end