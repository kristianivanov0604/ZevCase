//
//  ActionViewController.h
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableForNotification;

@end
