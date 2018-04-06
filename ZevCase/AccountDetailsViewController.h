//
//  AccountDetailsViewController.h
//  ZevCase
//
//  Created by Yu Li on 10/7/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet UITableView *tableAccount;

- (IBAction)actionBack:(id)sender;

@end
