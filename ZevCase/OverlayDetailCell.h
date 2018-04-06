//
//  OverlayDetailCell.h
//  ZevCase
//
//  Created by Liming Zhang on 10/26/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@protocol OverlaySelected

@optional;
- (void)didSelected:(id)picker;
@end

@interface OverlayDetailCell : UITableViewCell

@property (nonatomic, assign) id<OverlaySelected> delegate;

@property (nonatomic, assign) IBOutlet UIButton *_btnLeft;
@property (nonatomic, assign) IBOutlet UIButton *_btnRight;

- (IBAction)actionLeft:(id)sender;
- (IBAction)actionRight:(id)sender;
@end
