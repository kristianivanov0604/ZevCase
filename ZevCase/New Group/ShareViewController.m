//
//  ShareViewController.m
//  ZevCase
//
//  Created by Yu Li on 12/20/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "ShareViewController.h"
#import "MBProgressHUD.h"
#import "SocialCommunication.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize dataForUpload;

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
    index = 0;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setOriginalArray:(NSMutableArray *)_originalArray
{
    originalArray = _originalArray;
}
-(NSMutableArray *)getOriginalArray
{
    return originalArray;
}
#pragma mark - actions

- (IBAction)actionCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionDone:(id)sender{
    if ([_txtName.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Name can't be blank!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [ MBProgressHUD showHUDAddedTo : self.view animated : YES ] ;
    
    // Sign Up ;
    void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
        // Hide ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        NSLog(@"%@",_responseObject);
        
        NSDictionary * dic = (NSDictionary *)_responseObject;
        [self originalImageUploading:[dic objectForKey:@"postid"]];
    
        
        // Dismiss ;
        [self dismissViewControllerAnimated:YES completion:nil];
    } ;
    
    void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
        // Hide ;
        [ MBProgressHUD hideHUDForView : self.view animated : YES ] ;
        
        // Dismiss ;
        [self dismissViewControllerAnimated:YES completion:nil];
    } ;
    [ [ SocialCommunication sharedManager ] FeedAdd  : dataForUpload
                                                name : _txtName.text
                                                 tag : [self getString:_txtTag.text]
                                           successed : successed
                                             failure : failure] ;

    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)originalImageUploading:(NSString *)_postid
{
    UIImage *image = (UIImage *)[originalArray objectAtIndex:index];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
  
        void ( ^successed )( id _responseObject ) = ^( id _responseObject ) {
            
            
            NSDictionary * dic = (NSDictionary *)_responseObject;
            
            if (index < [originalArray count]-1)
            {
                index ++;
                [self originalImageUploading:[dic objectForKey:@"postid"]];
                
            }
            
            
            
        } ;
        
        void ( ^failure )( NSError* _error ) = ^( NSError* _error ) {
            [[[UIAlertView alloc] initWithTitle:@"error" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            
        } ;


    if (index == 0)
    {
            [[SocialCommunication sharedManager] originalImageUpload:_postid
                                                          photoIndex:[NSString stringWithFormat:@"%d",index]
                                                               count:[NSString stringWithFormat:@"%d",[originalArray count]]
                                                            subPhoto:imageData
                                                           successed:successed
                                                             failure:failure];
    }
    else
    {
            [[SocialCommunication sharedManager] originalImageUpload:_postid
                                                          photoIndex:[NSString stringWithFormat:@"%d",index]
                                                               count:[NSString stringWithFormat:@"%d",-1]
                                                            subPhoto:imageData
                                                           successed:successed
                                                             failure:failure];
    }
    
    
}


- (NSString*)getString:(NSString*)string{
    NSString *returnString = @"";
    NSMutableArray *returnArray = [NSMutableArray array];
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *str_array = [string componentsSeparatedByString:@"#"];
    for (int i = 1; i < str_array.count ; i++) {
        if (!([[str_array objectAtIndex:i] isEqualToString:@""] || [returnArray containsObject:[str_array objectAtIndex:i]])) {
            [returnArray addObject:[str_array objectAtIndex:i]];
            returnString  = [returnString stringByAppendingString:[str_array objectAtIndex:i]];
            returnString  = [returnString stringByAppendingString:@","];
        }
    }
    
    return returnString = [returnString substringWithRange:NSMakeRange(0, returnString.length-1)];
}

#pragma mark - uitextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _txtName) {
        [_txtTag becomeFirstResponder];
    }
    return YES;
}


@end
