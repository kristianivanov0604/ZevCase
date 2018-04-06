//
//  SocialCartViewController.h
//  ZevCase
//
//  Created by Yu Li on 12/11/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"

@class SocialFeed;

typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface SocialCartViewController : UIViewController<PayPalPaymentDelegate,UITextFieldDelegate>{
    IBOutlet UIScrollView *scrollForFeed;
    
    IBOutlet UIImageView *imageForCase;
    IBOutlet UIButton *buttonForBuy;
    
    IBOutlet UITextField *shipAdress;
    PaymentStatus status;
    CGFloat y;
    
    
    IBOutlet UIView *viewMainContent;
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtPhoneNumber;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtAddress1;
    IBOutlet UITextField *txtAddress2;
    IBOutlet UITextField *txtAddress3;
    IBOutlet UITextField *txtCountry;
    IBOutlet UITextField *txtCity;
    IBOutlet UITextField *txtState;
    IBOutlet UITextField *txtZipcode;
    IBOutlet UIView *viewPaypalButton;
    
}

@property ( nonatomic, retain ) SocialFeed*     feed ;



// Functions ;
- ( id ) initWithFeed : ( SocialFeed* ) _feed;
- ( id ) initWithFeed : ( SocialFeed* ) _feed caseType:(NSString *)_caseType;

- (IBAction)actionBuyFor:(id)sender;


@end
