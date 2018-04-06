//
//  BoxView.m
//  ZevCase
//
//  Created by Liming Zhang on 11/8/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//

#import "BoxView.h"

@implementation BoxView
@synthesize strMask;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
//        [self.layer setBorderWidth:2.0];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self addSubview:_imgBox];
        
        arrayFilter = [ NSArray arrayWithObjects : @"Origin", @"BookStore", @"City", @"Country", @"Film", @"Forest", @"Lake", @"Moment", @"NYC", @"Tea", @"Vintage", @"1Q84", @"B&W", nil ] ;
        
        
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    
    if (image != nil) {
        float scaleFactor = 0;
        if (image.size.height > image.size.width) {
            if (self.frame.size.width > self.frame.size.height) {
                scaleFactor = self.frame.size.width / image.size.width;
            }else{
                scaleFactor = self.frame.size.height / image.size.width;
            }
            
        }else{
            if (self.frame.size.width > self.frame.size.height) {
                scaleFactor = self.frame.size.width / image.size.height;
            }else{
                scaleFactor = self.frame.size.height / image.size.height;
            }
            
        }
        
        float newHeight = image.size.height * scaleFactor;
        float newWidth = image.size.width * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect bounds;
        
        bounds.origin = CGPointZero;
        bounds.size = newImage.size;
        
        _imgBox.bounds = bounds;
        _imgBox.image = newImage;
        
        [_imgBox setImage:[self setupFilter:_globalData.selectedFilterIndex :image]];
        [self.layer setBorderWidth:0.0];
//        [self setAlpha:0];
    }else{
        [_imgBox setImage:nil];
        [self.layer setBorderWidth:2.0];
    }
    
}

- (UIImage*)getImage{
    if(_imgBox.image != nil){
        return [_imgBox image];
    }else{
        return nil;
    }
    
}

- (void)setBoxHidden : (BOOL)bShow{
    [self setHidden:bShow];
}

- (void)setBorder : (BOOL)bShow{
    if (bShow == YES) {
        [self.layer setBorderWidth:2.0];
    }else{
        [self.layer setBorderWidth:0.0];
    }
    
}
- (void)setMask:(NSString *)mask{
    if ([mask isEqualToString:@"circle"]) {
        [self.layer setCornerRadius:self.frame.size.height / 2];
    }else{
        [self.layer setCornerRadius:0];
    }
}

#pragma mark - filter

- (UIImage *) setupFilter : ( FILTER_TYPE ) _type : (UIImage *)image
{
    GPUImageOutput < GPUImageInput >* filterForCamera = nil ;
    
    // New ;
    switch( _type )
    {
        case FILTER_ORIGINAL :
        {
            filterForCamera = [ [ GPUImageGammaFilter alloc ] init ] ;
            break ;
        }
            
        case FILTER_BOOKSTORE :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [[ GPUImageToneCurveFilter alloc ] initWithACV : @"BookStore" ];
            GPUImageSaturationFilter*   saturation  = [  [ GPUImageSaturationFilter alloc ] init ];
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_CITY :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"City" ] ;
            GPUImageSaturationFilter*   saturation  =  [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_COUNTRY :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Country" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_FILM :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Film" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ]  ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_FOREST :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Forest" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_LAKE :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Lake" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_MOMENT :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Moment" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_NYC :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"NYC" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_TEA :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Tea" ] ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_VINTAGE :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"Vintage" ] ;
            GPUImageVignetteFilter*     vintage     = [ [ GPUImageVignetteFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : vintage ] ;
            [ tone addTarget : vintage ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : vintage ] ;
            break ;
        }
            
        case FILTER_1Q84 :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"1Q84" ]  ;
            GPUImageSaturationFilter*   saturation  = [ [ GPUImageSaturationFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : saturation ] ;
            [ tone addTarget : saturation ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : saturation ] ;
            break ;
        }
            
        case FILTER_BW :
        {
            filterForCamera = [ [ GPUImageFilterGroup alloc ] init ] ;
            
            // Tone Curve ;
            GPUImageToneCurveFilter*    tone        = [ [ GPUImageToneCurveFilter alloc ] initWithACV : @"B&W" ] ;
            GPUImageGrayscaleFilter*    gray        = [ [ GPUImageGrayscaleFilter alloc ] init ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera addFilter : gray ] ;
            [ tone addTarget : gray ] ;
            
            [ ( GPUImageFilterGroup* )filterForCamera setInitialFilters : [ NSArray arrayWithObject : tone ] ] ;
            [ ( GPUImageFilterGroup* )filterForCamera setTerminalFilter : gray ] ;
            break ;
        }
            
        default :
        {
            filterForCamera = [ [ GPUImageGammaFilter alloc ] init ] ;
            break ;
        }
    }
    
    GPUImageRotationMode imageViewRotationMode = kGPUImageRotateLeft ;
    
    switch( [ image imageOrientation ] )
    {
        case UIImageOrientationLeft :
            imageViewRotationMode = kGPUImageRotateLeft ;
            break ;
            
        case UIImageOrientationRight :
            imageViewRotationMode = kGPUImageRotateRight ;
            break ;
            
        case UIImageOrientationDown :
            imageViewRotationMode = kGPUImageNoRotation ;
            break ;
            
        default :
            imageViewRotationMode = kGPUImageNoRotation ;
            break ;
    }
    
    [ filterForCamera setInputRotation : imageViewRotationMode atIndex : 0 ] ;
    
    UIImage *filteredImage = [ filterForCamera imageByFilteringImage : image ] ;
    
    return filteredImage;
}


@end
