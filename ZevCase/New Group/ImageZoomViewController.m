//
//  ImageZoomViewController.m
//  ZevCase
//
//  Created by threek on 2/7/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "ImageZoomViewController.h"
#import "MainViewController.h"

#import "UIImage+Rotating.h"


@interface ImageZoomViewController ()
{
    int boxIndex;
    MainViewController *mainViewController;
}

@end

@implementation ImageZoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMainViewController:(MainViewController*)mainVC
{
    self = [super init];
    if (self) {
        mainViewController = mainVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    boxIndex = -1;
    
    [self initMethod];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMethod
{

}

- (IBAction)navbarButtonAction:(id)sender {
    if ([sender isEqual:doneButton]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if (mainViewController) {
                [mainViewController setImageToBaseView:[self croppedImage] index:boxIndex];
            }
        }];
        
    } else if ([sender isEqual:cancelButton]) {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    
}

- (IBAction)imageFlipAction:(id)sender {
//    [imageView setImage:[UIImage imageWithCGImage: imageView.image.CGImage
//                                            scale: imageView.image.scale
//                                      orientation: UIImageOrientationUpMirrored]];
    
    [imageView setImage:[imageView.image horizontalFlip]];
}

- (IBAction)imageRotateAction:(id)sender {
    UIImage *newImage = [imageView.image rotateInDegrees:90.0f];
    CGRect newRect = CGRectMake(0, 0, imageView.frame.size.height, imageView.frame.size.width);
    [imageView setFrame:newRect];
    [imageView setImage:newImage];
    
    [boundScrollView setContentSize:newRect.size];
}

- (void)setOriginalImageFrame:(CGSize)frameSize image:(UIImage *)image index:(int)index
{
    boxIndex = index;
    
    float dt = 250 / frameSize.width;
    float height = frameSize.height * dt;
    CGRect scrollViewRect = CGRectMake(35, (self.view.frame.size.height - height) / 2, 250, height);
    [boundScrollView setFrame:scrollViewRect];
    boundScrollView.layer.borderWidth = 1.0f;
    boundScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    dt = 250 / image.size.width;
    height = image.size.height * dt;
    CGRect imageViewRect = CGRectMake(0, 0, 250, height);
    [imageView setFrame:imageViewRect];
    [imageView setImage:image];
    
    [boundScrollView setContentSize:imageViewRect.size];

    dt = -(scrollViewRect.size.height - height) / 2;
    [boundScrollView setContentOffset:CGPointMake(0, dt)];

}


#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == boundScrollView) {
        //        return myImageView;
        return imageView;
    } else {
        return Nil;
    }
}


- (UIImage*) croppedImage
{
    CGPoint offset = boundScrollView.contentOffset;
    CGSize imageSize = imageView.image.size;
    CGSize imageViewSize = imageView.frame.size;
    float ds = imageViewSize.width / imageSize.width;
    //        float dy = imageViewSize.height / imageSize.height;
    float xx1 = (1 / ds) * offset.x, yy1 = (1 / ds) * offset.y;
    float ww1 = (1 / ds) * boundScrollView.frame.size.width,
    hh1 = (1 / ds) * boundScrollView.frame.size.height;
    
    CGRect cropRect = CGRectMake(xx1, yy1, ww1, hh1);

    CGImageRef imageref = CGImageCreateWithImageInRect([imageView.image CGImage], cropRect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageref];
    return cropImage;
    
}

@end
