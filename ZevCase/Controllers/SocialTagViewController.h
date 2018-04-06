//
//  SocialTagViewController.h
//  ZevCase
//
//  Created by Yu Li on 12/22/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "ViewController.h"

@interface SocialTagViewController : ViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *tableForTag;
}

@property ( nonatomic, retain ) NSString*     tag ;

// Functions ;
- ( id ) initWithTag : ( NSString* ) _tag ;

@end
