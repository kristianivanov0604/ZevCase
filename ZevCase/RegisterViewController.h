//
//  RegisterViewController.h
//  ZevCase
//
//  Created by Yu Li on 9/30/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>{
    IBOutlet UITextField *_txtUsername;
    IBOutlet UITextField *_txtPassword;
    IBOutlet UITextField *_txtEmail;
    IBOutlet UITextField *_txtPhone;
    IBOutlet UITextField *_txtName;
    IBOutlet UIButton *_btnPhoto;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UITextField *_txtAddress;
}

@end
