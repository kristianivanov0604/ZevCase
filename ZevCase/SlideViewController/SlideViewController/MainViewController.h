//
//  MainViewController.h
//  ZevCase
//
//  Created by Liming Zhang on 10/21/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "QBImagePickerController.h"
#import "BasePhoneView.h"
#import "TouchImageView.h"
#import "BoxEventView.h"
#import "ImageZoomViewController.h"



@interface MainViewController : UIViewController<QBImagePickerControllerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, BoxEventViewDelegate>{
    NSMutableArray      *arrayImage;
    NSMutableArray      *arrayOverlayImage;
    NSMutableArray      *arrayOverlayView;
    
    NSArray             *arrayColors;
    NSArray             *arrayFilter;
    
    BasePhoneView       *baseView;
    UIImageView         *dragImageView;
    
    CGPoint             _priorPoint;
    
    UIImage             *imageShare;
    NSData*             dataForPhoto ;
    
    float               nRatio;
    
}

@property (nonatomic) NSInteger selectedOverlayIndex;

@property (nonatomic, assign) IBOutlet UIScrollView *_scrollMainView;
@property (nonatomic, assign) IBOutlet UIScrollView *_scrollImageView;
@property (nonatomic, assign) IBOutlet UIScrollView *_scrollColorView;
@property (nonatomic, assign) IBOutlet UIScrollView *_scrollFilterView;

@property (nonatomic, assign) IBOutlet UIButton *_btnMenu;
@property (nonatomic, assign) IBOutlet UIButton *_btnShare;

- (IBAction)revealMenu:(id)sender;
- (IBAction)actionAddPhoto:(id)sender;
- (IBAction)actionAutoreloadImages:(id)sender;
- (IBAction)actionUpload:(id)sender;
- (IBAction)actionChangeColor:(id)sender;
- (IBAction)actionFilter:(id)sender;

- (void)addOverlayImage:(UIImage*)image;

- (void)setImageToBaseView:(UIImage *)image index:(int)index;  // insert by 3K Feb-07, 2014

@end
