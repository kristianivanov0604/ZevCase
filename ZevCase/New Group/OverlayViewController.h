//
//  OverlayViewController.h
//  ZevCase
//
//  Created by Liming Zhang on 10/22/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface OverlayViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSArray *arrayItems;
}

@end
