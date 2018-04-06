//
//  SocialPaymentInfo.h
//  ZevCase
//
//  Created by threek on 1/27/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "SocialUser.h"

@interface SocialPaymentInfo : SocialUser

// Properties ;
@property ( nonatomic, retain ) NSString*       postid ;
@property ( nonatomic, retain ) NSString*       firstname ;
@property ( nonatomic, retain ) NSString*       lastname ;
@property ( nonatomic, retain ) NSString*       phonenumber ;
@property ( nonatomic, retain ) NSString*       email ;
@property ( nonatomic, retain ) NSString*       address1 ;
@property ( nonatomic, retain ) NSString*       address2 ;
@property ( nonatomic, retain ) NSString*       address3 ;
@property ( nonatomic, retain ) NSString*       country ;
@property ( nonatomic, retain ) NSString*       city ;
@property ( nonatomic, retain ) NSString*       state ;
@property ( nonatomic, retain ) NSString*       zipcode ;
@property ( nonatomic, retain ) NSString*       casetype ;

// Functions ;
- ( id ) initWithDict : ( NSDictionary* ) _dict ;

@end
