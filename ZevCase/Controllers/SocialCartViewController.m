//
//  SocialCartViewController.m
//  ZevCase
//
//  Created by Yu Li on 12/11/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "SocialCartViewController.h"
#import "SocialFeed.h"
#import "SocialPaymentInfo.h"

#import "UIImageView+AFNetworking.h"
#import "SocialCommunication.h"

#import "PayPalPayment.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalAmounts.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAddress.h"
#import "PayPalInvoiceItem.h"

#import "MBProgressHUD.h"

#define kPayPalClientId @"APP-80W284485P519543T"
#define kPayPalReceiverEmail @"zevcases@gmail.com"

@interface SocialCartViewController ()
{
    NSString *caseType;
}
@end

@implementation SocialCartViewController
@synthesize feed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self keyboardShowHideAnimationSetting];
    
    shipAdress.delegate = self;
    
    NSString *strTitle = @"Item Purchase";
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setText:strTitle];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    //    [lblTitle sizeToFit];
    UIView *viewTitle = [[UIView alloc] init];
    [viewTitle addSubview:lblTitle];
    [viewTitle setBackgroundColor:[UIColor clearColor]];
    [viewTitle setFrame:CGRectMake(0, 0, 120, 30)];
    [lblTitle setFrame:CGRectMake(0, 0, 120, 30)];
    [self.navigationItem setTitleView:viewTitle];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
//    [scrollForFeed setContentSize:CGSizeMake(320, 480)];
    
    [PayPal initializeWithAppID:@"APP-75N34681KH3161903" forEnvironment:ENV_LIVE];
//    [PayPal initializeWithAppID:@"APP-75N34681KH3161903" forEnvironment:ENV_NONE];
    
    y = 400;
    
    [self initMethod];
    
//    [self addLabelWithText:@"Simple Payment" andButtonWithType:BUTTON_294x43 withAction:@selector(simplePayment)];
    [self addLabelWithText:@"Simple Payment" andButtonWithType:BUTTON_152x33 withAction:@selector(simplePayment)];
    
}

- (void) initMethod
{
    [scrollForFeed setContentSize:viewMainContent.frame.size];
    [scrollForFeed addSubview:viewMainContent];
    for (int i = 0; i < 11; i++) {
        UITextField *textField = (UITextField *)[viewMainContent viewWithTag:(100 + i)];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, CGRectGetHeight(textField.frame))];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;

    }
    
    SocialUser *me = [[SocialCommunication sharedManager] me];
    
    [txtFirstName   setText:me.name];
    [txtLastName    setText:@" "];
    [txtPhoneNumber setText:me.phone];
    [txtEmail       setText:me.email];

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentSandbox];
//    [PayPalPaymentViewController prepareForPaymentUsingClientId:kPayPalClientId];
    
    [ imageForCase setImageWithURL : [ NSURL URLWithString : [ feed photo ] ] ] ;
    
    
}
-(void)addLabelWithText:(NSString *)text andButtonWithType:(PayPalButtonType)type withAction:(SEL)action {
    UIFont *font = [UIFont boldSystemFontOfSize:14.];
    CGSize size = [text sizeWithFont:font];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIButton *button = [[PayPal getPayPalInst] getPayButtonWithTarget:self andAction:action andButtonType:type];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
	CGRect frame = button.frame;
//	frame.origin.x = round((self.view.frame.size.width - button.frame.size.width) / 2.);
//	frame.origin.y = round(shipAdress.frame.origin.y + 1.5 * shipAdress.frame.size.height);
//	button.frame = frame;
//	[scrollForFeed addSubview:button];
    
    [viewPaypalButton addSubview:button];
	
	/*UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, y, size.width, size.height)] autorelease];
     label.font = font;
     label.text = text;
     label.backgroundColor = [UIColor clearColor];
     
     label.lineBreakMode = NSLineBreakByWordWrapping;
     label.numberOfLines = 0;
     [label sizeToFit];
     
     [self.view addSubview:label];*/
	
	y += size.height + frame.size.height + 3;
    
}


#pragma mark - init with feed
- ( id ) initWithFeed : ( SocialFeed* ) _feed
{
    
    self = [ self initWithNibName : @"SocialCartViewController" bundle : nil ] ;
    
    if( self )
    {
        [ self setFeed : _feed ] ;
        caseType = @"iPhone 5/5s";
    }
    
    return self ;
}

- ( id ) initWithFeed : ( SocialFeed* ) _feed caseType:(NSString *)_caseType{
    
    self = [ self initWithNibName : @"SocialCartViewController" bundle : nil ] ;
    
    if( self )
    {
        [ self setFeed : _feed ] ;
        caseType = [NSString stringWithFormat:@"%@", _caseType];
        
    }
    
    return self ;
}

- (IBAction)actionBuyFor:(id)sender{
    
}

#pragma mark -
#pragma mark PayPalPaymentDelegate methods

-(IBAction)RetryInitialization:(id)sender
{
    //DEVPACKAGE
    //	[PayPal initializeWithAppID:@"your live app id" forEnvironment:ENV_SANDBOX];
    //	[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
}

//paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
//was successful and perform any desired bookkeeping. you should not do any user interface updates.
//payKey is a string which uniquely identifies the transaction.
//paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	status = PAYMENTSTATUS_SUCCESS;
}

//paymentFailedWithCorrelationID is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
	status = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
- (void)paymentCanceled {
	status = PAYMENTSTATUS_CANCELED;
}

//paymentLibraryExit is a required method. this is called when the library is finished with the display
//and is returning control back to your app. you should now do any user interface updates such as
//displaying a success/failure/canceled message.
- (void)paymentLibraryExit {
	UIAlertView *alert = nil;
	switch (status) {
		case PAYMENTSTATUS_SUCCESS: {
			//[self.navigationController pushViewController:[[[HCVIPPaymentResultViewController alloc] init] autorelease] animated:TRUE];
            void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
                if( [ [ _responseObject objectForKey : @"result" ] isEqualToString : @"failed" ] )
                {
                    UIAlertView*  alertView = [[UIAlertView alloc] initWithTitle:@"Order Failed" message:@"Your order is already exist! Please be more patient."                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                    return ;
                }else{
                    UIAlertView*  alertView = [[UIAlertView alloc] initWithTitle:@"Order Successed" message:@"Your order successed! You will get the ZevCases within 2weeks"                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    return ;
                }

            } ;
            
            void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
                
            } ;
            
            [ [ SocialCommunication sharedManager ] Payment:[[SocialCommunication sharedManager] me]
                                                       info:[self paymentInformation]
                                                  successed:successed
                                                    failure:failure  ] ;
            
            [self.navigationController popViewControllerAnimated:YES];
            
			break;
        }
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
											   message:@"Your order failed. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case PAYMENTSTATUS_CANCELED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order canceled"
											   message:@"You canceled your order. Touch \"Pay with PayPal\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
	}
    
	[alert show];
    
	
}

- (SocialPaymentInfo *) paymentInformation
{
    NSDictionary *infoDic = @{@"postid"     : self.feed.postid,
                              @"firstname"   : txtFirstName.text,
                              @"lastname"    : txtLastName.text,
                              @"phonenumber" : txtPhoneNumber.text,
                              @"email"       : txtEmail.text,
                              @"address1"    : txtAddress1.text,
                              @"address2"    : (txtAddress2.text.length == 0 ? @"-" : txtAddress2.text),
                              @"address3"    : (txtAddress3.text.length == 0 ? @"-" : txtAddress3.text),
                              @"country"     : txtCountry.text,
                              @"city"        : txtCity.text,
                              @"state"       : txtState.text,
                              @"zipcode"     : txtZipcode.text,
                              @"casetype"    : caseType,
                              };
    
    SocialPaymentInfo *info = [[SocialPaymentInfo alloc] initWithDict:infoDic];
    return info;
}
//adjustAmountsForAddress:andCurrency:andAmount:andTax:andShipping:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use the advanced version first, but will use this one if that one is not implemented.
- (PayPalAmounts *)adjustAmountsForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency andAmount:(NSDecimalNumber const *)inAmount
									andTax:(NSDecimalNumber const *)inTax andShipping:(NSDecimalNumber const *)inShipping andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	//do any logic here that would adjust the amount based on the shipping address
	PayPalAmounts *newAmounts = [[PayPalAmounts alloc] init] ;
	newAmounts.currency = @"USD";
	newAmounts.payment_amount = (NSDecimalNumber *)inAmount;
	
	//change tax based on the address
	if ([inAddress.state isEqualToString:@"CA"]) {
		newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .1]];
	} else {
		newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .08]];
	}
	newAmounts.shipping = (NSDecimalNumber *)inShipping;
	
	//if you need to notify the library of an error condition, do one of the following
	//*outErrorCode = AMOUNT_ERROR_SERVER;
	//*outErrorCode = AMOUNT_CANCEL_TXN;
	//*outErrorCode = AMOUNT_ERROR_OTHER;
    
	return newAmounts;
}

//adjustAmountsAdvancedForAddress:andCurrency:andReceiverAmounts:andErrorCode: is optional. you only need to
//provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
//for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
//the library will try to use this version first, but will use the simple one if this one is not implemented.
- (NSMutableArray *)adjustAmountsAdvancedForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency
								 andReceiverAmounts:(NSMutableArray *)receiverAmounts andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
	NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:[receiverAmounts count]];
	for (PayPalReceiverAmounts *amounts in receiverAmounts) {
		//leave the shipping the same, change the tax based on the state
		if ([inAddress.state isEqualToString:@"CA"]) {
			amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .1]];
		} else {
			amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .08]];
		}
		[returnArray addObject:amounts];
	}
	
	//if you need to notify the library of an error condition, do one of the following
	//*outErrorCode = AMOUNT_ERROR_SERVER;
	//*outErrorCode = AMOUNT_CANCEL_TXN;
	//*outErrorCode = AMOUNT_ERROR_OTHER;
	
	return returnArray;
}

#pragma mark -
#pragma mark Actions triggered by Pay with PayPal buttons

- (BOOL) checkingShippingInformation
{
    NSString *alertString = @"";
    if (txtFirstName.text.length == 0) {
        alertString = @"Please enter First Name.";
    } else if (txtLastName.text.length == 0) {
        alertString = @"Please enter Last Name.";
    } else if (txtPhoneNumber.text.length == 0) {
        alertString = @"Please enter Phone Number.";
    } else if (txtEmail.text.length == 0) {
        alertString = @"Please enter Email Address.";
    } else if (txtAddress1.text.length == 0) {
        alertString = @"Please enter Address.";
    } else if (txtCountry.text.length == 0) {
        alertString = @"Please enter Country.";
    } else if (txtCity.text.length == 0) {
        alertString = @"Please enter City.";
    } else if (txtState.text.length == 0) {
        alertString = @"Please enter State.";
    } else if (txtZipcode.text.length == 0) {
        alertString = @"Please enter Zip Code.";
    }
    if (alertString.length == 0) {
        return YES;
    } else {
        [[[UIAlertView alloc] initWithTitle:Nil
                                    message:alertString
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        return NO;
    }
}

- (void)simplePayment {
    
    if (![self checkingShippingInformation]) {
        return;
    }
    
    [shipAdress resignFirstResponder];
	//dismiss any native keyboards
	//[preapprovalField resignFirstResponder];
    
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = FALSE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = TRUE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_EACHRECEIVER;
	
	//for a payment with a single recipient, use a PayPalPayment object
	PayPalPayment *payment = [[PayPalPayment alloc] init] ;
	payment.recipient = kPayPalReceiverEmail;
	payment.paymentCurrency = @"USD";
	payment.description = @"ZevCases";
	payment.merchantName = @"ZevCases Admin";
	
	//subtotal of all items, without tax and shipping
    
	payment.subTotal = [NSDecimalNumber decimalNumberWithString:@"29.99"];
	
	//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
	payment.invoiceData = [[PayPalInvoiceData alloc] init] ;
	payment.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithString:@"0"];
	payment.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithString:@"0.0"];
	
	//invoiceItems is a list of PayPalInvoiceItem objects
	//NOTE: sum of totalPrice for all items must equal payment.subTotal
	//NOTE: example only shows a single item, but you can have more than one
	payment.invoiceData.invoiceItems = [NSMutableArray array];
	PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init] ;
	item.totalPrice = payment.subTotal;
	item.name = @"ZevCases";
	[payment.invoiceData.invoiceItems addObject:item];
	
	[[PayPal getPayPalInst] checkoutWithPayment:payment];
}

- (void)parallelPayment {
	//dismiss any native keyboards
//	[preapprovalField resignFirstResponder];
	
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = TRUE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = TRUE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_EACHRECEIVER;
	
	//for a payment with multiple recipients, use a PayPalAdvancedPayment object
	PayPalAdvancedPayment *payment = [[PayPalAdvancedPayment alloc] init] ;
	payment.paymentCurrency = @"USD";
	
    // A payment note applied to all recipients.
    payment.memo = @"A Note applied to all recipients";
    
	//receiverPaymentDetails is a list of PPReceiverPaymentDetails objects
	payment.receiverPaymentDetails = [NSMutableArray array];
	
	//Frank's Robert's Julie's Bear Parts;
	NSArray *nameArray = [NSArray arrayWithObjects:@"Frank's", @"Robert's", @"Julie's",nil];
	
	for (int i = 1; i <= 3; i++) {
		PayPalReceiverPaymentDetails *details = [[PayPalReceiverPaymentDetails alloc] init] ;
		
        // Customize the payment notes for one of the three recipient.
        if (i == 2) {
            details.description = [NSString stringWithFormat:@"Bear Component %d", i];
        }
        
        details.recipient = [NSString stringWithFormat:@"example-merchant-%d@paypal.com", 4 - i];
		details.merchantName = [NSString stringWithFormat:@"%@ Bear Parts",[nameArray objectAtIndex:i-1]];
        
		unsigned long long order, tax, shipping;
		order = i * 100;
		tax = i * 7;
		shipping = i * 14;
		
		//subtotal of all items for this recipient, without tax and shipping
		details.subTotal = [NSDecimalNumber decimalNumberWithMantissa:order exponent:-2 isNegative:FALSE];
		
		//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
		details.invoiceData = [[PayPalInvoiceData alloc] init] ;
		details.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithMantissa:shipping exponent:-2 isNegative:FALSE];
		details.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithMantissa:tax exponent:-2 isNegative:FALSE];
		
		//invoiceItems is a list of PayPalInvoiceItem objects
		//NOTE: sum of totalPrice for all items must equal details.subTotal
		//NOTE: example only shows a single item, but you can have more than one
		details.invoiceData.invoiceItems = [NSMutableArray array];
		PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init] ;
		item.totalPrice = details.subTotal;
		item.name = @"Bear Stuffing";
		[details.invoiceData.invoiceItems addObject:item];
		
		[payment.receiverPaymentDetails addObject:details];
	}
	
	[[PayPal getPayPalInst] advancedCheckoutWithPayment:payment];
}

- (void)chainedPayment {
	//dismiss any native keyboards
//	[preapprovalField resignFirstResponder];
	
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = TRUE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = TRUE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_EACHRECEIVER;
	
	//for a payment with multiple recipients, use a PayPalAdvancedPayment object
	PayPalAdvancedPayment *payment = [[PayPalAdvancedPayment alloc] init] ;
	payment.paymentCurrency = @"USD";
	
	//receiverPaymentDetails is a list of PPReceiverPaymentDetails objects
	payment.receiverPaymentDetails = [NSMutableArray array];
	
	NSArray *nameArray = [NSArray arrayWithObjects:@"Frank's", @"Robert's", @"Julie's",nil];
	
	for (int i = 1; i <= 3; i++) {
		PayPalReceiverPaymentDetails *details = [[PayPalReceiverPaymentDetails alloc] init] ;
		
		details.description = @"Bear Components";
		details.recipient = [NSString stringWithFormat:@"example-merchant-%d@paypal.com", 4 - i];
		details.merchantName = [NSString stringWithFormat:@"%@ Bear Parts",[nameArray objectAtIndex:i-1]];
		
		unsigned long long order, tax, shipping;
		order = i * 100;
		tax = i * 7;
		shipping = i * 14;
		
		//subtotal of all items for this recipient, without tax and shipping
		details.subTotal = [NSDecimalNumber decimalNumberWithMantissa:order exponent:-2 isNegative:FALSE];
		
		//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
		details.invoiceData = [[PayPalInvoiceData alloc] init] ;
		details.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithMantissa:shipping exponent:-2 isNegative:FALSE];
		details.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithMantissa:tax exponent:-2 isNegative:FALSE];
		
		//invoiceItems is a list of PayPalInvoiceItem objects
		//NOTE: sum of totalPrice for all items must equal details.subTotal
		//NOTE: example only shows a single item, but you can have more than one
		details.invoiceData.invoiceItems = [NSMutableArray array];
		PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init] ;
		item.totalPrice = details.subTotal;
		item.name = @"Bear Stuffing";
		[details.invoiceData.invoiceItems addObject:item];
		
		//the only difference between setting up a chained payment and setting
		//up a parallel payment is that the chained payment must have a single
		//primary receiver.  the subTotal + totalTax + totalShipping of the
		//primary receiver must be greater than or equal to the sum of
		//payments being made to all other receivers, because the payment is
		//being made to the primary receiver, then the secondary receivers are
		//paid by the primary receiver.
		if (i == 3) {
			details.isPrimary = TRUE;
		}
		
		[payment.receiverPaymentDetails addObject:details];
	}
	
	[[PayPal getPayPalInst] advancedCheckoutWithPayment:payment];
}

- (void)preapproval {
	//dismiss any native keyboards
//	[preapprovalField resignFirstResponder];
	
	//the preapproval flow is kicked off by a single line of code which takes
	//the preapproval key and merchant name as parameters.
	[[PayPal getPayPalInst] preapprovalWithKey:@"asdfasdfasd" andMerchantName:@"Joe's Bear Emporium"];
}

#pragma mark - keyboard show/hide notification

-(void)keyboardShowHideAnimationSetting
{
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(didShowKeyBoard:) name:UIKeyboardWillShowNotification  object:nil];
    [notificationCenter addObserver:self selector:@selector(willHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)didShowKeyBoard : (NSNotification *) _notification
{
    CGRect scrollViewRect = scrollForFeed.frame;
    CGRect rectForKeyBoard = [[_notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.4f animations:^{
        [scrollForFeed setFrame:CGRectMake(scrollViewRect.origin.x ,
                                           scrollViewRect.origin.y,
                                           scrollViewRect.size.width,
                                           scrollViewRect.size.height - rectForKeyBoard.size.height + 50)];
    }];
    
}

-(void)willHideKeyBoard : (NSNotification *) _notification
{
    CGRect scrollViewRect = scrollForFeed.frame;
    CGRect rectForKeyBoard = [[_notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.4f animations:^{
    [scrollForFeed setFrame:CGRectMake(scrollViewRect.origin.x ,
                                       scrollViewRect.origin.y,
                                       scrollViewRect.size.width,
                                       scrollViewRect.size.height + rectForKeyBoard.size.height - 50)];
    }];
}



@end
