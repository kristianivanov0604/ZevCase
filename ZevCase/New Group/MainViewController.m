//
//  MainViewController.m
//  ZevCase
//
//  Created by Liming Zhang on 10/21/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "MainViewController.h"
#import "MenuNavViewController.h"
#import "Global.h"
#import "SocialCommunication.h"
#import "MBProgressHUD.h"
#import "PublishViewController.h"
#import "ShareViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - Instance Properties

@synthesize _scrollMainView;
@synthesize _scrollImageView;
@synthesize _scrollColorView;
@synthesize _scrollFilterView;
@synthesize selectedOverlayIndex;
@synthesize _btnMenu;
@synthesize _btnShare;

#pragma mark - init Methods

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
    
    // color scrollview
    
    arrayColors = @[ @"Black",
                   @"Dark Grey",
                   @"Light Grey",
                   @"Grey",
                   @"White",
                   @"Red",
                   @"Green",
                   @"Blue",
                   @"Cyan",
                   @"Yellow",
                   @"Magenta",
                   @"Orange",
                   @"Purple",
                   @"Brown",
                   @"Skyblue",
                   @"Lawngreen",
                   @"Chocolate",
                   [UIColor blackColor],
                   [UIColor darkGrayColor],
                   [UIColor lightGrayColor],
                   [UIColor grayColor],
                   [UIColor whiteColor],
                   [UIColor redColor],
                   [UIColor greenColor],
                   [UIColor blueColor],
                   [UIColor cyanColor],
                   [UIColor yellowColor],
                   [UIColor magentaColor],
                   [UIColor orangeColor],
                   [UIColor purpleColor],
                   [UIColor brownColor],
                   [UIColor colorWithRed:135.0 / 255.0 green:206.0 / 255.0 blue:235.0 / 255.0 alpha:1.0],
                   [UIColor colorWithHue:90.0 / 255.0 saturation:100.0 / 255.0 brightness:99.0 / 255.0 alpha:1.0],
                   [UIColor colorWithRed:210.0 / 255.0 green:105.0 / 255.0 blue:30.0 / 255.0 alpha:1.0]];
    
    for (int i = 0; i < [arrayColors count] / 2; i++) {
        UILabel *lblColor = [[UILabel alloc] initWithFrame:CGRectMake(70 * i, 0, 70, 50)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(actionTapColor:)];
        [tapGesture setNumberOfTouchesRequired:1];
        [lblColor addGestureRecognizer:tapGesture];
        [lblColor setBackgroundColor:[arrayColors objectAtIndex:[arrayColors count] / 2 + i]];
        [lblColor setUserInteractionEnabled:YES];
        [_scrollColorView addSubview:lblColor];
    }
    
    [_scrollColorView setContentSize:CGSizeMake([arrayColors count] * 70 / 2,
                                                _scrollColorView.frame.size.height)];
    [_scrollColorView setHidden:YES];
    selectedOverlayIndex = -1;
    
    
    //filters array, scrollview
    
    arrayFilter = @[ @"Origin",
                     @"BookStore",
                     @"City",
                     @"Country",
                     @"Film",
                     @"Forest",
                     @"Lake",
                     @"Moment",
                     @"NYC",
                     @"Tea",
                     @"Vintage",
                     @"1Q84",
                     @"B&W" ] ;

    for (int i = 0; i < 13; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"filter_image_%@", [arrayFilter objectAtIndex:i]]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(5 + 65*i, 5, 60, 60)];
        [button setTag:60+i];
        [button addTarget:self action:@selector(actionFilterButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollFilterView addSubview:button];
    }
    [_scrollFilterView setHidden:YES];
    [_scrollFilterView setContentSize:CGSizeMake(5 + 65 * 13, 70)];
    
    //baseview
    
    arrayImage          = [NSMutableArray array];
    arrayOverlayImage   = [NSMutableArray array];
    arrayOverlayView    = [NSMutableArray array];
    
    UIImage *imageBase = [UIImage imageNamed:[NSString stringWithFormat:@"base_%@-1", [_globalData.arraySelectedPhone valueForKey:@"Device"]]];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageBase];
    baseView = [[BasePhoneView alloc] initWithFrame:CGRectMake((_scrollMainView.frame.size.width  - imageBase.size.width)  / 2,
                                                               (_scrollMainView.frame.size.height - imageBase.size.height) / 2,
                                                               imageBase.size.width , imageBase.size.height )
                                             parent:self];
    
//    baseView = [[BasePhoneView alloc] init];
    
//    [baseView setFrame:CGRectMake((_scrollMainView.frame.size.width  - imageBase.size.width)  / 2,
//                                  (_scrollMainView.frame.size.height - imageBase.size.height) / 2,
//                                  imageBase.size.width , imageBase.size.height )];
    
    [baseView setContentMode:UIViewContentModeScaleAspectFit];
    
        
    nRatio = _scrollMainView.frame.size.height / (baseView.frame.size.height + 50);
    
    baseView.transform = CGAffineTransformScale(CGAffineTransformIdentity,nRatio, nRatio);
    
//    NSLog(@"x = %f, y = %f", baseView.frame.size.width, baseView.frame.size.height);
    
    [self._scrollMainView addSubview:baseView];
    [baseView setBackgroundColor:[UIColor clearColor]];
    [_scrollMainView setBackgroundColor:[UIColor clearColor]];
    
    [self._scrollMainView setContentSize:CGSizeMake(321, self._scrollMainView.frame.size.height + 1.0)];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OverlayViewController"];
        MenuNavViewController *navController = [[MenuNavViewController alloc] initWithRootViewController:viewController];
        self.slidingViewController.underLeftViewController = navController;
//        [self.slidingViewController anchorTopViewTo:ECRight];
    }
    
    self.slidingViewController.underRightViewController = Nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}

#pragma mark - action tap color

- (void)actionTapColor:(UITapGestureRecognizer*)sender{
    UILabel *lblSelectedColor = (UILabel*)[sender view];
    [self setColorToSelectedOver:[lblSelectedColor backgroundColor]];
}

#pragma mark - set Random Images
- (void)setRandomImages{
    if (arrayImage.count !=0) {
        [baseView setRandomImages:arrayImage];
    }
}

#pragma mark - remove all images
- (void)removeAllImages{
    [baseView removeAllImages];
}

#pragma mark - setcolor to selected overlay
- (void)setColorToSelectedOver:(UIColor*)color{
    if (selectedOverlayIndex != -1) {
        UIImageView *_imageviewSelected = [arrayOverlayView objectAtIndex:selectedOverlayIndex];
        
        CGRect rect = CGRectMake(0, 0, _imageviewSelected.image.size.width, _imageviewSelected.image.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, _imageviewSelected.image.CGImage);
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                    scale:1.0 orientation: UIImageOrientationDownMirrored];
        
        _imageviewSelected.image = flippedImage;
    }
}

#pragma mark - actions

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)actionAddPhoto:(id)sender{
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init] ;
    imagePickerController.delegate = self;
    imagePickerController.filterType = QBImagePickerFilterTypeAllPhotos;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.fullScreenLayoutEnabled = YES;
    imagePickerController.allowsMultipleSelection = YES;
    
    imagePickerController.limitsMaximumNumberOfSelection = NO;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)actionAutoreloadImages:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil  otherButtonTitles:@"Random", @"Remove", nil];
    actionSheet.tag = 1111;
    [actionSheet showInView:self.view];
}

- (IBAction)actionUpload:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Publish Case", @"Share this case", @"Close design case", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)actionChangeColor:(id)sender{
    if (arrayOverlayView.count != 0) {
        if (_scrollColorView.isHidden == YES) {
            [_scrollColorView setHidden:NO];
            [_scrollImageView setHidden:YES];
            [_scrollFilterView setHidden:YES];
        }else{
            [_scrollColorView setHidden:YES];
            [_scrollFilterView setHidden:YES];
            [_scrollImageView setHidden:NO];
        }
    }
}

- (IBAction)actionFilter:(id)sender{
    if (_scrollFilterView.isHidden == YES) {
        [_scrollFilterView setHidden:NO];
        [_scrollColorView setHidden:YES];
        [_scrollImageView setHidden:YES];
    }else{
        [_scrollFilterView setHidden:YES];
        [_scrollColorView setHidden:YES];
        [_scrollImageView setHidden:NO];
    }
}

- (void)actionFilterButton:(id)sender{
    _globalData.selectedFilterIndex = [(UIButton*)sender tag] - 60;
    [baseView setImageArray];
}

#pragma mark - add overlay

- (void)addOverlayImage:(UIImage*)image{
    
    [arrayOverlayImage addObject:image];
    UIImageView *overlayView = [[UIImageView alloc] initWithImage:image];
    [overlayView sizeToFit];
    [overlayView setCenter:CGPointMake(self._scrollMainView.frame.size.width/2, self._scrollMainView.frame.size.height/2)];
    overlayView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    [gestureRecognizer addTarget:self action:@selector(imageOverlayMove:)];
    gestureRecognizer.delegate = self;
    [overlayView addGestureRecognizer: gestureRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] init];
    [pinchRecognizer addTarget:self action:@selector(imageOverlayPinch:)];
    pinchRecognizer.delegate = self;
    [overlayView addGestureRecognizer: pinchRecognizer];
    
    [self._scrollMainView addSubview:overlayView];
    [arrayOverlayView addObject:overlayView];
}


- (void)moveOverlayImages{
    
    NSLog(@"baseview frame = %@", [NSValue valueWithCGRect:baseView.frame]);
    NSLog(@"scrollview frame = %@", [NSValue valueWithCGRect:_scrollMainView.frame]);
    
    for (int i = 0 ; i < [arrayOverlayView count] ; i++ ) {
        UIImageView *subView = [arrayOverlayView objectAtIndex:i];
        
        float nWidth =  ( baseView.frame.origin.x - _scrollMainView.frame.origin.x ) ;
        float nHeight = ( baseView.frame.origin.y - _scrollMainView.frame.origin.y ) ;
        
        [subView removeFromSuperview];
        
        [subView setFrame:CGRectMake(subView.frame.origin.x - nWidth / nRatio, subView.frame.origin.y - nHeight / nRatio, subView.frame.size.width / nRatio, subView.frame.size.height / nRatio)];
        
//        subView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1 / nRatio, 1 / nRatio);
        
        [baseView addSubview:subView];
    }
}

- (void)imageOverlayPinch : (UIPinchGestureRecognizer*)recognizer{
    
    static CGRect initialBounds;

    UIImageView *_viewRecognizer = (UIImageView*)recognizer.view;
    
    for (int i = 0 ; i < [arrayOverlayView count]; i++) {
        if (_viewRecognizer == [arrayOverlayView objectAtIndex:i]) {
            selectedOverlayIndex = i;
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = _viewRecognizer.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)recognizer scale];
    
    CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
    _viewRecognizer.bounds = CGRectApplyAffineTransform(initialBounds, zt);
    
    return;
    
}

- (void)imageOverlayMove : (UIPanGestureRecognizer*)recognizer{
    
    UIImageView *_imageviewSelected = (UIImageView* )[recognizer view];
    
    for (int i = 0 ; i < [arrayOverlayView count]; i++) {
        if (_imageviewSelected == [arrayOverlayView objectAtIndex:i]) {
            selectedOverlayIndex = i;
        }
    }

    CGPoint translation = [recognizer translationInView:recognizer.view];
    recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
}


#pragma mark - set image to scrollview

- (void)setScrollImage{
//    UIButton *buttonImage = [[UIButton alloc] init];
    for (int i = 0; i < [arrayImage count]; i++) {
        UIButton *buttonImage =[[UIButton alloc] initWithFrame:CGRectMake(5 + i * 65, 5, 60, 60)];
        [buttonImage setImage:[[arrayImage objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"] forState:UIControlStateNormal];
        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [gestureRecognizer addTarget:self action:@selector(imgLongPressed:)];
        gestureRecognizer.delegate = self;
        [buttonImage addGestureRecognizer: gestureRecognizer];
        [self._scrollImageView addSubview:buttonImage];
        
    }
    [self._scrollImageView setContentSize:CGSizeMake([arrayImage count] * 65 + 5, 70)];
}

#pragma mark - longpress gesture

- (void) imgLongPressed:(UILongPressGestureRecognizer*)sender
{
    UIButton *imageButton =(UIButton*) sender.view;
    CGPoint point = [sender locationInView:baseView];
    
    NSLog(@"%f, %f", point.x, point.y);
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        dragImageView = [[UIImageView alloc] init];
        UIImage *dragImage = [imageButton imageForState:UIControlStateNormal];
        [dragImageView setImage:dragImage];
        [dragImageView setFrame:CGRectMake(point.x - 50, point.y - 50, 100, 100)];
        
        [baseView addSubview:dragImageView];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint center = dragImageView.center;
        center.x += point.x - _priorPoint.x;
        center.y += point.y - _priorPoint.y;
        dragImageView.center = center;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSArray *arrayBox= [_globalData.arraySelectedPhone valueForKey:@"Boxes"];
        for (int i = 0; i < [arrayBox count]; i++) {
            NSDictionary *dict = [arrayBox objectAtIndex:i];
            
//            if (point.x > [[dict objectForKey:@"Left"] integerValue] && point.y > [[dict objectForKey:@"Top"] integerValue]) {
//                if ((point.x < [[dict objectForKey:@"Left"] integerValue] + [[dict objectForKey:@"Width"] integerValue]) && (point.y < [[dict objectForKey:@"Top"] integerValue] + [[dict objectForKey:@"Height"] integerValue])) {
//                    //                    NSInteger index = [[[[_globalData.arraySelectedPhone valueForKey:@"Boxes"] objectAtIndex:0] objectForKey:@"ID"] integerValue];
//                    //                    [baseView setImageAtIndex:[dragImageView image] index:[[dict objectForKey:@"ID"] integerValue] - index];
//                    [dragImageView removeFromSuperview];
//                    [baseView setImageAtIndex:[dragImageView image] index:i];
//                }else{
//                    [dragImageView removeFromSuperview];
//                }
//            }else{
//                [dragImageView removeFromSuperview];
//            }
        
            
    // Changed by 3K    Feb-04, 2014
            CGRect boxRect = CGRectMake([[dict objectForKey:@"Left"]    floatValue],
                                        [[dict objectForKey:@"Top"]     floatValue],
                                        [[dict objectForKey:@"Width"]   floatValue],
                                        [[dict objectForKey:@"Height"]  floatValue]);
            
            if (CGRectContainsPoint(boxRect, point)) {
                [dragImageView removeFromSuperview];
                [baseView setImageAtIndex:[dragImageView image] index:i];
                [baseView setOriginalImage:[dragImageView image] index:i];
//                [dragImageView removeFromSuperview];
                break;
            }
            
            
    // ---------------------------------
            

        }
        [dragImageView removeFromSuperview];
        
    }
    _priorPoint = point;
}

#pragma mark - BoxEventView delegate

- (void)BoxEventView:(BoxEventView *)eventView originalImage:(UIImage *)image index:(int)index
{
    ImageZoomViewController *viewController = [[ImageZoomViewController alloc] initWithMainViewController:self];
    [self presentViewController:viewController animated:YES completion:^{
        [viewController setOriginalImageFrame:eventView.frame.size image:image index:index];
    }];
}

- (void)setImageToBaseView:(UIImage *)image index:(int)index
{
    [baseView setImageAtIndex:image index:index];
}
    
#pragma mark - uiscrollview image
- (void)getScrollViewImage{
    [_btnShare setHidden:YES];
    [_btnMenu setHidden:YES];
    
    imageShare = [self captureScrollView];
    
    [_btnShare setHidden:NO];
    [_btnMenu setHidden:NO];
    
}

#pragma mark - caputure uiscrollview
- (UIImage*)captureScrollView
{
    CGPoint scrollOrigin = _scrollMainView.frame.origin;
    CGRect baseRect = CGRectOffset(baseView.frame, scrollOrigin.x, scrollOrigin.y);
    CGRect croppedRect = CGRectMake(baseRect.origin.x * 2,
                                    baseRect.origin.y * 2 ,
                                    baseView.frame.size.width * 2,
                                    baseView.frame.size.height * 2);
    
    [baseView setBoxEventViewShow:NO];
    
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self._scrollMainView.bounds.size, self._scrollMainView.opaque, 0.0);
    } else {
        UIGraphicsBeginImageContext(self._scrollMainView.frame.size);
    }
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"image size = %@", [NSValue valueWithCGSize:image.size]);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croppedRect);
    UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    [baseView setBoxEventViewShow:YES];
    
    return newImage;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.class == [QBImagePickerController class]) {
        QBImagePickerController *pickerController = (QBImagePickerController *)picker;
        if (pickerController.allowsMultipleSelection) {
            NSArray *mediaInfoArray = (NSArray *)info;
            [arrayImage addObjectsFromArray:mediaInfoArray];
            [self setScrollImage];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - uiactionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1111) {
        switch (buttonIndex) {
            case 0:{
                [self setRandomImages];
                break;
            }
            case 1:{
                [self removeAllImages];
                break;
            }
            default:
                break;
        }
    }else{
//        [self moveOverlayImages];
        [self getScrollViewImage];
        
        switch (buttonIndex) {
            case 0:{
                dataForPhoto    = UIImageJPEGRepresentation(imageShare, 1) ;
                ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
                viewController.dataForUpload = dataForPhoto;
                [viewController setOriginalArray:baseView.arrayImages];
//                NSLog(@"%d",[baseView.arrayImages count]);
                [self presentViewController:viewController animated:YES completion:nil];
                // Show ;
                
                break;
            }
            case 1:{
                PublishViewController *viewController = [[PublishViewController alloc] initWithNibName:@"PublishViewController" bundle:nil];
                viewController.shareImage = imageShare;
                [self presentViewController:viewController animated:YES completion:nil];
                break;
            }
            case 2:{
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            }
            case 3:{
                break;
            }
            default:
                break;
        }
    }
}

- (NSData*) saveAsImageType : (UIImage *)_image
{
    
    CGSize pointsSize = _image.size;
    CGSize pixelSize = CGSizeMake(CGImageGetWidth([_image CGImage]), CGImageGetHeight([_image CGImage]));
    
    CGFloat currentDPI = ceilf((72.0f * pixelSize.width)/pointsSize.width);
    NSLog(@"current DPI %f", currentDPI);
    
    CGSize updatedPointsSize = pointsSize;
//
    updatedPointsSize.width = ceilf((72.0f * pixelSize.width)/300.0f);
    updatedPointsSize.height = ceilf((72.0f * pixelSize.height)/300.0f);
//
//    [rep setSize:updatedPointsSize];
//
//    NSData *data = [rep representationUsingType: imageType properties: nil];
//    [data writeToFile: filePath atomically: NO];
    
    return nil;
    
}

@end
