
//
//  SocialSwitchControl.h
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
#import <Foundation/Foundation.h>

// --- Defines --- ;
// SocialSwitchControl Class ;
@interface SocialSwitchControl : UIControl
{
    UIImageView*        imgForBackground_Off ;
    UIImageView*        imgForBackground_On ;
    
    UIView*             viewForBtn ;
    UIImageView*        imgForButton ;
    UILabel*            lblForOn ;
    UILabel*            lblForOff ;

    BOOL                isOn ;
    CGPoint             firstTouchPoint ;
    float               touchDistanceFromButton ;
    
    id                  returnTarget ;
    SEL                 returnAction ;
}

// Functions ;
- ( BOOL ) on ;
- ( void ) setOn : ( BOOL ) _on animated : ( BOOL ) _animated ;

@end
