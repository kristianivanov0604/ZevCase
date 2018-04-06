//
//  SearchViewController.h
//  ZevCase
//
//  Created by Yu Li on 10/2/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedDesignCell.h"
#import "FeaturedDesignersCell.h"
#import "FeaturedDesignPacksCell.h"

#import "MDSearchBarController.h"

@interface SearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, MDSearchBarViewControllerDelegate>{
    IBOutlet UIImageView*       imgForBackground ;
    IBOutlet UITableView*       tblForExplore ;
    
}

@property (nonatomic, strong) IBOutlet MDSearchBar *searchBar;
@property (nonatomic, strong) IBOutlet MDSearchBarController *searchBarController;

@end
