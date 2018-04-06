//
//  BasePhoneView.m
//  ZevCase
//
//  Created by Liming Zhang on 11/5/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "BasePhoneView.h"
#import "MainViewController.h"


@implementation BasePhoneView
@synthesize arrayOverlayViews, arrayImages;

// insert by 3K  Feb-07, 2014
@synthesize arrayImageRectOfEvent;

- (id)initWithFrame:(CGRect)frame parent:(MainViewController *)parent
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
//        self.clipsToBounds = YES;
        
        parentViewController = parent;
        
        _phoneImage = [[UIImageView alloc] init];
        UIImage *imageBase = [UIImage imageNamed:[NSString stringWithFormat:@"base_%@-1", [_globalData.arraySelectedPhone valueForKey:@"Device"]]];
        [_phoneImage setFrame:CGRectMake(0, 0, imageBase.size.width, imageBase.size.height)];
        [_phoneImage setImage:imageBase];
        [_phoneImage setTag:1000];
        [self setTag:2000];
        [self addSubview:_phoneImage];
        
        arrayBoxes              = [_globalData.arraySelectedPhone valueForKey:@"Boxes"];
        arrayImages             = [[NSMutableArray alloc] init];
        arrayImageRectOfEvent   = [[NSMutableArray alloc] init];  // insert by 3K  Feb-07, 2014
        arrayOverlayImage       = [NSMutableArray array];
        arrayOverlayViews       = [NSMutableArray array];
        
        for (int i = 0; i < [arrayBoxes count]; i++) {
            
            NSDictionary *dict = [arrayBoxes objectAtIndex:i];
            BoxView *viewBox = [[BoxView alloc] initWithFrame:CGRectMake([[dict objectForKey:@"Left"]   integerValue],
                                                                         [[dict objectForKey:@"Top"]    integerValue],
                                                                         [[dict objectForKey:@"Width"]  integerValue],
                                                                         [[dict objectForKey:@"Height"] integerValue])];
            [viewBox setMask:[dict objectForKey:@"Mask"]];
            [viewBox setTag:i];
            [self addSubview:viewBox];
            [arrayImages setObject:@"" atIndexedSubscript:i ];
            
            // insert by 3K  Feb-07, 2014
            BoxEventView *viewBoxEvent = [[BoxEventView alloc] initWithFrame:viewBox.frame];
            [viewBoxEvent setIndex:i];
            [viewBoxEvent setDelegate:parentViewController];
            [self insertSubview:viewBoxEvent aboveSubview:viewBox];
            [arrayImageRectOfEvent addObject:viewBoxEvent];
            //--------------------------------------- end of insert by 3K  Feb-07, 2014
            
        }
        
//        UIImage *imageOverlay = [self overlayImage:_phoneImage.image withOverlay:[UIImage imageNamed:[NSString stringWithFormat:@"overlay_%@-%@-1",[_globalData.arraySelectedPhone valueForKey:@"Device"], [_globalData.arraySelectedPhone valueForKey:@"CaseOverlay"]]]];
        _phoneOverlayImage = [[UIImageView alloc] init];
//        [_phoneOverlayImage setFrame:CGRectMake(0, 0, imageOverlay.size.width, imageOverlay.size.height)];
        [_phoneOverlayImage setFrame:CGRectMake(0, 0, _phoneImage.frame.size.width, _phoneImage.frame.size.height)];
//        [_phoneOverlayImage setImage:imageOverlay];
        [_phoneOverlayImage setTag:1001];
        [self addSubview:_phoneOverlayImage];
        [self bringSubviewToFront:_phoneOverlayImage];
    }
    return self;
}

#pragma mark - set random images
- (void)setRandomImages:(NSArray*)arrayImage{
    for (int i = 0; i < [arrayImages count]; i++) {
        int r = arc4random() % [arrayImage count];
        [arrayImages setObject:[[arrayImage objectAtIndex:r] objectForKey:UIImagePickerControllerOriginalImage] atIndexedSubscript:i];
        
        // insert by 3K  Feb-07, 2014
        BoxEventView *view = (BoxEventView *) [arrayImageRectOfEvent objectAtIndex:i];
        [view setIndex:i];
        [view setOriginalImage:[[arrayImage objectAtIndex:r] objectForKey:UIImagePickerControllerOriginalImage]];


    }
    
    [self setImageArray];
}

#pragma mark - remove all images
- (void)removeAllImages{
    for (int i = 0; i < [arrayImages count]; i++) {
        if ([[arrayImages objectAtIndex:i] isKindOfClass:[UIImage class]]) {
            [arrayImages setObject:@"" atIndexedSubscript:i];
//            BoxView *viewBox = (BoxView*)[self viewWithTag:i];
//            [viewBox setBorder:YES];
        }
        
        BoxEventView *view = (BoxEventView *) [arrayImageRectOfEvent objectAtIndex:i];
        [view setOriginalImage:Nil];
        
    }
    
    [self setImageArray];
    [self setBoxHidden:NO];
    [self setBoxBorder:YES];
    
}

#pragma mark - add overlay image to view

- (void)addOverlayImage:(UIImage*)image{
    [arrayOverlayImage addObject:image];
    UIImageView *overlayView = [[UIImageView alloc] initWithImage:image];
    [overlayView sizeToFit];
    [overlayView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    overlayView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    [gestureRecognizer addTarget:self action:@selector(imageOverlayMove:)];
    gestureRecognizer.delegate = self;
    [overlayView addGestureRecognizer: gestureRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] init];
    [pinchRecognizer addTarget:self action:@selector(imageOverlayPinch:)];
    pinchRecognizer.delegate = self;
    [overlayView addGestureRecognizer: pinchRecognizer];
    
    [self addSubview:overlayView];
    [arrayOverlayViews addObject:overlayView];
}

- (void)imageOverlayPinch : (UIPinchGestureRecognizer*)recognizer{
    
    static CGRect initialBounds;
    UIImageView *_view = [[UIImageView alloc] init];
    if ([recognizer.view isKindOfClass:[UIImageView class]]) {
        
    }
    _view = (UIImageView*)recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        initialBounds = _view.bounds;
    }
    CGFloat factor = [(UIPinchGestureRecognizer *)recognizer scale];
    
    CGAffineTransform zt = CGAffineTransformScale(CGAffineTransformIdentity, factor, factor);
    _view.bounds = CGRectApplyAffineTransform(initialBounds, zt);
    
    return;
    
}

- (void)imageOverlayMove : (UIPanGestureRecognizer*)recognizer{
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    recognizer.view.center=CGPointMake(recognizer.view.center.x+translation.x, recognizer.view.center.y+ translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
}
#pragma mark - setimage at index

- (void)setImageAtIndex:(UIImage*)image index:(int)index{
    
    UIImage *imageBase = [UIImage imageNamed:[NSString stringWithFormat:@"base_%@-1", [_globalData.arraySelectedPhone valueForKey:@"Device"]]];
    [_phoneImage setImage:imageBase];
    [_phoneOverlayImage setImage:nil];
    if (image == nil) {
        [arrayImages setObject:@"" atIndexedSubscript:index];
    }else{
        [arrayImages setObject:image atIndexedSubscript:index];
    }
    
    
//    [self setBoxHidden:NO];
    [self setImageArray];
    
//    maskedImage =[self maskImage:[self imageCapture] withMask:[UIImage imageNamed:[NSString stringWithFormat:@"mask_%@", [_globalData.arraySelectedPhone valueForKey:@"Device"]]]];
//    [_phoneImage setImage:[self maskImage:[self imageCapture] withMask:[UIImage imageNamed:[NSString stringWithFormat:@"mask_%@", [_globalData.arraySelectedPhone valueForKey:@"Device"]]]]];
    
//    [_phoneOverlayImage setImage:[self overlayImage:maskedImage withOverlay:[UIImage imageNamed:[NSString stringWithFormat:@"overlay_%@-%@-1",[_globalData.arraySelectedPhone valueForKey:@"Device"], [_globalData.arraySelectedPhone valueForKey:@"CaseOverlay"]]]]];

//    [self setBoxHidden:YES];
    
    
    
//    [self setBoxBorder:YES];
    
//    BoxView *viewBoxindex = (BoxView*)[self viewWithTag:index];
//    [viewBoxindex setImage:image];
//    [viewBoxindex setAlpha:0];
//    [viewBoxindex setHidden:YES];
//    UIImage *addImage = [self imageCapture:viewBoxindex];
    
//    [_phoneImage setImage:[self addImage:addImage toImage:[_phoneImage image] frame:viewBoxindex.frame]];
//    
//    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
//    [gestureRecognizer addTarget:self action:@selector(imgLongPressed:)];
//    gestureRecognizer.delegate = self;
//    [viewBoxindex addGestureRecognizer: gestureRecognizer];
}

// insert by 3K  Feb-07, 2014
- (void) setOriginalImage:(UIImage *)image index:(int)index
{
    if (image) {
        BoxEventView *view = (BoxEventView *) [arrayImageRectOfEvent objectAtIndex:index];
        [view setIndex:index];
        [view setOriginalImage:image];
    }
}

#pragma mark - set array box hidden

- (void)setBoxHidden : (BOOL)bShow{
    for (int i = 0; i < [arrayBoxes count]; i++) {
        BoxView *viewBox = (BoxView*)[self viewWithTag:i];
        if (![[arrayImages objectAtIndex:i] isKindOfClass:[NSString class]]) {
            [viewBox setBoxHidden:bShow];
        }else{
            [viewBox setBoxHidden:!bShow];
        }
    }
}

- (void) setBoxEventViewShow:(BOOL)flag
{
    for (BoxEventView *view in arrayImageRectOfEvent) {
        [view setHidden:!flag];
        if (flag) {
            [self bringSubviewToFront:view];
        }
    }
}

#pragma mark - set array box border

- (void)setBoxBorder : (BOOL)bShow{
    for (int i = 0; i < [arrayBoxes count]; i++) {
        BoxView *viewBox = (BoxView*)[self viewWithTag:i];
        if ([[arrayImages objectAtIndex:i] isKindOfClass:[NSString class]]) {
            [viewBox setBorder:bShow];
        }
    }
}

#pragma mark - set array Image

- (void)setImageArray{
    UIImage *imageBase = [UIImage imageNamed:[NSString stringWithFormat:@"base_%@-1", [_globalData.arraySelectedPhone valueForKey:@"Device"]]];
    [_phoneImage setImage:imageBase];
    for (int i = 0; i <[arrayImages count] ; i++) {
        BoxView *boxView = (BoxView*)[self viewWithTag:i];
        if ([[arrayImages objectAtIndex:i] isKindOfClass:[UIImage class]]) {
            [boxView setImage:[arrayImages objectAtIndex:i]];
        }else{
            [boxView setImage:nil];
        }

    }
    
    [_phoneOverlayImage setImage:nil];
    
    [self setBoxHidden:NO];
    [self setBoxEventViewShow:NO];
    
    maskedImage =[self maskImage:[self imageCapture]
                        withMask:[UIImage imageNamed:[NSString stringWithFormat:@"mask_%@", [_globalData.arraySelectedPhone valueForKey:@"Device"]]]];
    
    [_phoneOverlayImage setImage:[self overlayImage:maskedImage
                                        withOverlay:[UIImage imageNamed:[NSString stringWithFormat:@"overlay_%@-%@-1",[_globalData.arraySelectedPhone valueForKey:@"Device"], [_globalData.arraySelectedPhone valueForKey:@"CaseOverlay"]]]]];

    
    [self setBoxHidden:YES];
    [self setBoxEventViewShow:YES];
}

#pragma mark - longpress gesture

- (void) imgLongPressed:(UILongPressGestureRecognizer*)sender
{
    BoxView *view_ =(BoxView*) sender.view;
    CGPoint point = [sender locationInView:self];
    
//    NSLog(@"%f, %f", point.x, point.y);
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        dragImageView = [[UIImageView alloc] init];
        UIImage *dragImage = [view_ getImage];
        [dragImageView setImage:dragImage];
        [dragImageView setFrame:CGRectMake(point.x - dragImage.size.width/4, point.y - dragImage.size.height/4, dragImage.size.width/2, dragImage.size.height/2)];
        
        [self addSubview:dragImageView];
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
            if (point.x > [[dict objectForKey:@"Left"] integerValue] && point.y > [[dict objectForKey:@"Top"] integerValue]) {
                if ((point.x < [[dict objectForKey:@"Left"] integerValue] + [[dict objectForKey:@"Width"] integerValue]) &&
                    (point.y < [[dict objectForKey:@"Top"] integerValue] + [[dict objectForKey:@"Height"] integerValue])) {
                    
                    [dragImageView removeFromSuperview];
                    BoxView *boxIndex = (BoxView*)[self viewWithTag:i];
                    UIImage *imageTemp = [boxIndex getImage];
                    [self setImageAtIndex:[dragImageView image] index:[[dict objectForKey:@"ID"] intValue]];
                    [self setImageAtIndex:imageTemp index:(int)[view_ tag]];
                }else{
                    [dragImageView removeFromSuperview];
                }
            }else{
                [dragImageView removeFromSuperview];
            }
        }
    }
    
    _priorPoint = point;
}

#pragma mark - overlay image
- (UIImage*) overlayImage:(UIImage *)image withOverlay:(UIImage*)overlay{

#if 1
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"overlay.png"];
    NSLog(@"path = %@", path);
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [UIImagePNGRepresentation(overlay) writeToFile:path atomically:YES];
#endif
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//    [overlay drawInRect:CGRectMake(image.size.width - overlay.size.width, image.size.height - overlay.size.height, overlay.size.width, overlay.size.height)];
    [overlay drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#if 1
    path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"overlayresult.png"];
    NSLog(@"path = %@", path);
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [UIImagePNGRepresentation(result) writeToFile:path atomically:YES];
#endif
    return result;
}

#pragma mark - mask image
- (UIImage*) maskImage:(UIImage *) image withMask:(UIImage *) mask
{
    UIGraphicsBeginImageContext( self.bounds.size ) ;
    
    CGContextRef context = UIGraphicsGetCurrentContext() ;
    
    // Tranfrom ;
    CGContextTranslateCTM( context, 0, self.bounds.size.height ) ;
    CGContextScaleCTM( context, 1.0, -1.0 ) ;
    
    // Mask ;
    CGContextClipToMask( context, self.bounds, [ mask CGImage ] ) ;
    
    // Tranfrom ;
    CGContextTranslateCTM( context, 0.0, self.bounds.size.height ) ;
    CGContextScaleCTM( context, 1.0, -1.0 ) ;
    
    
    [ image drawInRect : self.bounds ] ;
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext() ;
    UIGraphicsEndImageContext() ;
    
    return resultImage;
}

#pragma mark - captureimage

- (UIImage *)imageCapture{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    NSLog(@"bound = %@", NSStringFromCGRect(self.bounds));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(ctx, self.bounds);
    [self.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
#if 1
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"newImage.png"];
    NSLog(@"path = %@", path);
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [UIImagePNGRepresentation(newImage) writeToFile:path atomically:YES];
#endif
    
    return newImage;
}

- (UIImage *)imageCapture : (BoxView *) captureView{
    
    UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, captureView.opaque, 0.0);
    NSLog(@"bound = %@", NSStringFromCGRect(captureView.bounds));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(ctx, captureView.bounds);
    [captureView.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
#if 1
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"newImage.png"];
    NSLog(@"path = %@", path);
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [UIImagePNGRepresentation(newImage) writeToFile:path atomically:YES];
#endif
    
    return newImage;
}


#pragma mark - addimage to background

- (UIImage*)addImage:(UIImage*)image toImage:(UIImage*)backImage frame : (CGRect)rectImage {
//    UIImage *bottomImage = [UIImage imageNamed:@"photo 2.JPG"]; //background image
//    UIImage *image       = [UIImage imageNamed:@"photo 3.JPG"]; //foreground image
//    UIImage *image1      = [UIImage imageNamed:@"photo 4.JPG"]; //foreground image
//    UIImage *image2      = [UIImage imageNamed:@"photo 5.JPG"]; //foreground image
//
    CGSize newSize = self.bounds.size;
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [backImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    [image drawInRect:rectImage blendMode:kCGBlendModeNormal alpha:0.8];
//    [image1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.3];
//    [image2 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.2];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
