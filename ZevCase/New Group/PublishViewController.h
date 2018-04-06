//
//  PublishViewController.h
//  ZevCase
//
//  Created by Yu Li on 12/20/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PublishViewController : ViewController<UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate>{
    BOOL bFacebook;
    BOOL bTwitter;
    BOOL bInstagram;
    BOOL bEmail;
    BOOL bLibrary;
}
@property (nonatomic,retain) UIDocumentInteractionController *docController;

@property (nonatomic, assign) UIImage *shareImage;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDone:(id)sender;

- (IBAction)actionSwitchFacebook:(id)sender;
- (IBAction)actionSwitchTwitter:(id)sender;
- (IBAction)actionSwitchInstagram:(id)sender;
- (IBAction)actionSwitchEmail:(id)sender;
- (IBAction)actionSwitchLibrary:(id)sender;

@end
