//
//  OverlayDetailViewController.h
//  ZevCase
//
//  Created by Liming Zhang on 10/26/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "OverlayDetailCell.h"

@interface OverlayDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, OverlaySelected>{
    NSArray *arrayOverlayCount;
    NSArray *arrayOverlay;
    
    IBOutlet UILabel *_lblForTitle;
}

@property (nonatomic, assign) int type;

- (IBAction)actionBack:(id)sender;

@end
