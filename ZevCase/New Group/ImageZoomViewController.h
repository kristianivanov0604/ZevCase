//
//  ImageZoomViewController.h
//  ZevCase
//
//  Created by threek on 2/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface ImageZoomViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIBarButtonItem *cancelButton;
    IBOutlet UIBarButtonItem *doneButton;
    IBOutlet UIScrollView *boundScrollView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *flipButton;
    IBOutlet UIButton *rotateButton;
    
}

- (id)initWithMainViewController:(MainViewController*)mainVC;
- (void)setOriginalImageFrame:(CGSize)frameSize image:(UIImage *)image index:(int)index;

- (IBAction)navbarButtonAction:(id)sender;
- (IBAction)imageFlipAction:(id)sender;
- (IBAction)imageRotateAction:(id)sender;

@end
