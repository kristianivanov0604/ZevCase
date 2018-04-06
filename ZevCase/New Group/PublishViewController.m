//
//  PublishViewController.m
//  ZevCase
//
//  Created by Yu Li on 12/20/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "PublishViewController.h"
#import "ShareKit.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKInstagram.h"

@interface PublishViewController ()

@end

@implementation PublishViewController
@synthesize shareImage;
@synthesize docController;

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
    
    bFacebook = false;
    bTwitter = false;
    bInstagram = false;
    bEmail = false;
    bLibrary = false;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)actionCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (bLibrary) {
        UIImageWriteToSavedPhotosAlbum(shareImage, nil, nil, nil);
    }
}

#pragma mark - actions switcher
- (IBAction)actionSwitchFacebook:(id)sender{
    UISwitch *swither = (UISwitch*)sender;
    
    if (swither.isOn) {
        if (bFacebook == false) {
            bFacebook = true;
            SHKItem *item = [SHKItem image:shareImage title:@"#ZevCase"];
            SHKFacebook *sharer = [[SHKFacebook alloc] init];
            [sharer loadItem:item];
            [sharer share];
            
        }
    }
}

- (IBAction)actionSwitchTwitter:(id)sender{
    UISwitch *swither = (UISwitch*)sender;
    
    if (swither.isOn) {
        if (bTwitter == false) {
            bTwitter = true;
            SHKItem *item = [SHKItem image:shareImage title:@"#ZevCase"];
            SHKTwitter *sharer = [[SHKTwitter alloc] init];
            [sharer loadItem:item];
            [sharer share];
            
        }
    }
}

- (IBAction)actionSwitchInstagram:(id)sender{
    UISwitch *swither = (UISwitch*)sender;
    
    if (swither.isOn) {
        if (bInstagram == false) {
            bInstagram = true;
            if (self.docController) {
                [self.docController dismissMenuAnimated:NO];
                docController = nil;
            }
            
            NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"Image.igo"];
                NSData *imageData = UIImagePNGRepresentation(shareImage);
                [imageData writeToFile:savedImagePath atomically:YES];
                NSURL *imageUrl = [NSURL fileURLWithPath:savedImagePath];
                NSLog(@"%@",imageUrl);
                docController = [[UIDocumentInteractionController alloc] init];
                docController.delegate = self;
                docController.UTI = @"com.instagram.exclusivegram";
                docController.URL = imageUrl;
                
                [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            }
        }
    }
}

- (IBAction)actionSwitchEmail:(id)sender{
    UISwitch *switcher = (UISwitch*)sender;
    if (switcher.isOn) {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            [mailer setSubject:@"ZevCase"];
            NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
            [mailer setToRecipients:toRecipients];
            NSData *imageData = UIImagePNGRepresentation(shareImage);
            [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
            NSString *emailBody = @"Check out this Case I made with ZevCase iPhone app";
            [mailer setMessageBody:emailBody isHTML:NO];
            [self presentViewController:mailer animated:TRUE completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:@"Your device doesn't support the composer sheet"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (IBAction)actionSwitchLibrary:(id)sender{
    UISwitch *switcher = (UISwitch*)sender;
    bLibrary = switcher.isOn;
}

#pragma mark - mail compose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
