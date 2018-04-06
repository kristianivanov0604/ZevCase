//
//  SelectDeviceViewController.h
//  ZevCase
//
//  Created by threek on 1/25/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDeviceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tblDeviceList;
}

@property (nonatomic, strong) id prevVC;

@end

@interface SelectDeviceCell : UITableViewCell

@end