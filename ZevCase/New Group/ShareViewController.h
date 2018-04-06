//
//  ShareViewController.h
//  ZevCase
//
//  Created by Yu Li on 12/20/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "ViewController.h"

@interface ShareViewController : ViewController<UITextFieldDelegate, UITextViewDelegate>{
    IBOutlet UITextField *_txtName;
    IBOutlet UITextView *_txtTag;
    
    NSString* strName;
    NSString* strPrice;
    NSString* strTag;
    NSMutableArray * originalArray;
    int index;
    
}

@property (nonatomic, assign) NSData *dataForUpload;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionDone:(id)sender;
-(void)setOriginalArray:(NSMutableArray *)_originalArray;
-(NSMutableArray *)getOriginalArray;

@end
