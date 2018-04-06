//
//  RegisterViewController.m
//  ZevCase
//
//  Created by Yu Li on 9/30/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "SocialUser.h"
#import "SocialCommunication.h"
#import "UIImageView+AFNetworking.h"

#import <Parse/Parse.h>
#import "TabViewController.h"

@interface RegisterViewController (){
    UIImage *imageForAvatar;
}

- ( void ) showAlertTips : ( NSString* ) _message ;

// Events ;
- ( IBAction ) onBtnBack : ( id ) _sender ;
- ( IBAction ) onBtnSignUp : ( id ) _sender ;
- ( IBAction ) onBtnPhoto : ( id ) _sender ;


@end

@implementation RegisterViewController

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
    
    _txtEmail.delegate = self;
    _txtName.delegate = self;
    _txtPassword.delegate = self;
    _txtPhone.delegate = self;
    _txtUsername.delegate = self;
    
    [_scrollView setContentSize:CGSizeMake(320, _scrollView.frame.size.height + 1)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
//    [self.navigationController setNavigationBarHidden:NO];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"img_navigationbarback"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setTitle:@"REGISTER"];
    
    UIBarButtonItem *btnSignup = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBtnSignUp:)];
    [btnSignup setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setRightBarButtonItem:btnSignup];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onBtnBack:)];
    [btnBack setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setLeftBarButtonItem:btnBack];
    
    [_txtUsername becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tapGesture recognizer
-(void)actionTap:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
}

#pragma mark - Alert Tips
- ( void ) showAlertTips : ( NSString* ) _message
{
    UIAlertView*    alertView   = [ [ UIAlertView alloc ] initWithTitle : ALERT_TIPS
                                                                  message : _message
                                                                 delegate : self
                                                        cancelButtonTitle : @"Ok"
                                                        otherButtonTitles : nil, nil ]  ;
    
    // Show ;
    [ alertView show ] ;
}

#pragma mark - Check
- ( BOOL ) checkBlankField
{
    NSArray*        arrayField  = [ NSArray arrayWithObjects : _txtUsername, _txtPassword, _txtEmail, _txtName, nil ] ;
    NSArray*        arrayTitle  = [ NSArray arrayWithObjects : @"Username", @"Password", @"Email", @"Name", nil ] ;
    
    UITextField*    textField   = nil ;
    NSString*       textTitle   = nil ;
    
    NSInteger       nInx        = 0 ;
    NSInteger       nCnt        = 0 ;
    
    for( nInx = 0, nCnt = [ arrayField count ] ; nInx < nCnt ; nInx ++ )
    {
        textField   = [ arrayField objectAtIndex : nInx ] ;
        textTitle   = [ arrayTitle objectAtIndex : nInx ] ;
        
        if( [ textField.text isEqualToString : @"" ] )
        {
            [ self showAlertTips : [ NSString stringWithFormat : @"%@ can't be blank. Please try again.", textTitle ] ] ;
            return NO ;
        }
    }
    
    return YES ;
}

- ( BOOL ) checkEmail
{
    BOOL            filter = YES ;
    NSString*       filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    NSString*       laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*" ;
    NSString*       emailRegex = filter ? filterString : laxString ;
    NSPredicate*    emailTest = [ NSPredicate predicateWithFormat : @"SELF MATCHES %@", emailRegex ] ;
    
    if( [ emailTest evaluateWithObject : _txtEmail.text ] == NO )
    {
        [ self showAlertTips : @"Input a valid Email address." ] ;
        return NO ;
    }
    
    return YES ;
}

- ( BOOL ) checkPassword
{
    return YES ;
}

#pragma mark - Events ;
- ( IBAction ) onBtnBack : ( id ) _sender
{
    [ self.navigationController popViewControllerAnimated : YES ] ;
}

- ( IBAction ) onBtnSignUp : ( id ) _sender
{
    // Check TextField ;
    if( [ self checkBlankField ] == NO )
    {
        return ;
    }
    
    // Check Email ;
    if( [ self checkEmail ] == NO )
    {
        return ;
    }
    
    // Check Password ;
    if( [ self checkPassword ] == NO )
    {
        return ;
    }
    
    // Email ;
    if( [ _txtUsername isFirstResponder ] )
    {
        [ _txtUsername resignFirstResponder ] ;
    }
    
    // Password ;
    if( [ _txtPassword isFirstResponder ] )
    {
        [ _txtPassword resignFirstResponder ] ;
    }
    
    // Email ;
    if( [ _txtEmail isFirstResponder ] )
    {
        [ _txtEmail resignFirstResponder ] ;
    }
    
    // Name ;
    if( [ _txtName isFirstResponder ] )
    {
        [ _txtName resignFirstResponder ] ;
    }
    
    // Show ;
//    [ self.navigationItem.rightBarButtonItem setEnabled : NO ] ;
    [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] ;
    
    // Sign Up ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Hide ;
        [ self.navigationItem.rightBarButtonItem setEnabled : YES ] ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Parse ;
        if( [ [ _responseObject objectForKey : @"result" ] isEqualToString : @"failed" ] )
        {
            [ self  showAlertTips : [ _responseObject objectForKey : @"message" ] ] ;
            return ;
        }
        
        // Set ;
        NSDictionary*   dict    = [ _responseObject objectForKey : @"user" ] ;
        SocialUser*     user    = [ [ SocialUser alloc ] initWithDict : dict ]  ;
        
        [ [ SocialCommunication sharedManager ] setMe : user ] ;
        
        NSString *strChannel = [NSString stringWithFormat:@"user_%@", [user userid]];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setChannels:[[NSArray alloc] initWithObjects:strChannel, nil]];
        [currentInstallation saveInBackground];
        // Dismiss ;
        TabViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabViewController"];
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ self.navigationItem.rightBarButtonItem setEnabled : YES ] ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Error ;
        [ self  showAlertTips : @"Internet Connection Error!" ] ;
        
    } ;
    
    NSData* dataForPhoto    = UIImageJPEGRepresentation( imageForAvatar , 0.5 ) ;
    
    [ [ SocialCommunication sharedManager ] SignUp : dataForPhoto
                                          username : _txtUsername.text
                                          password : _txtPassword.text
                                             email : _txtEmail.text
                                              name : _txtName.text
                                             phone : _txtPhone.text
                                           address  : _txtAddress.text
                                         successed : successed
                                           failure : failure ] ;
    
//    [ [ SocialCommunication sharedManager ] SignUp : nil
//                                          username : _txtUsername.text
//                                          password : _txtPassword.text
//                                             email : @"test@a.com"
//                                              name : _txtName.text
//                                             phone : @"12345678"
//                                         successed : successed
//                                           failure : failure ] ;
    
}

- ( IBAction ) onBtnPhoto : ( id ) _sender {
    for (UIView *subView in _scrollView.subviews) {
        if (subView.class == [UITextField class]) {
            [(UITextField*)subView resignFirstResponder];
        }
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from gallery", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            pickerController.allowsEditing = YES;
            pickerController.delegate = self;
            [self presentViewController:pickerController animated:YES completion:nil];
            break;
        }
        case 1:{
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            pickerController.delegate = self;
            [self presentViewController:pickerController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - uiimagepicker controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    imageForAvatar = [ info objectForKey:UIImagePickerControllerEditedImage ];
    [_btnPhoto setImage:imageForAvatar forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
