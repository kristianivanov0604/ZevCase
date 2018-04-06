//
//  OverlayDetailCell.m
//  ZevCase
//
//  Created by Liming Zhang on 10/26/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "OverlayDetailCell.h"

@implementation OverlayDetailCell
@synthesize _btnLeft;
@synthesize _btnRight;
@synthesize delegate;

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

#pragma mark - actions

- (IBAction)actionLeft:(id)sender{
    _globalData.selectedOverlayIndex = [(UIButton*)sender tag] ;
    if ([(id)delegate respondsToSelector:@selector(didSelected:)]) {
        
        [delegate didSelected:self];
    }
}

- (IBAction)actionRight:(id)sender{
    _globalData.selectedOverlayIndex = [(UIButton*)sender tag] ;
    if ([(id)delegate respondsToSelector:@selector(didSelected:)]) {
        
        [delegate didSelected:self];
    }
}

@end
