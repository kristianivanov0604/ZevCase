//
//  GridTableCell.m
//  ZevCase
//
//  Created by Yu Li on 10/4/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "GridTableCell.h"

@implementation GridTableCell

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
