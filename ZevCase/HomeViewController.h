//
//  HomeViewController.h
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView*       tblForFeed ;
}

@property (nonatomic, assign) IBOutlet UIView *tabView;
@property (nonatomic, assign) IBOutlet UIImageView *imageForBlock;
@property (nonatomic, assign) IBOutlet UIImageView *imageForMakeCase;

-(IBAction)actionSelectedButton:(id)sender;

@end
