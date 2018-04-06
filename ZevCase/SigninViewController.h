//
//  SigninViewController.h
//  ZevCase
//
//  Created by Yu Li on 9/30/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@interface SigninViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UITextField *_txtUsername;
    IBOutlet UITextField *_txtPassword;
    NSString * username;
    NSString * password;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;


@end
