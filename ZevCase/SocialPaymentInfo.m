//
//  SocialPaymentInfo.m
//  ZevCase
//
//  Created by threek on 1/27/14.
//  Copyright (c) 2014 Yu Li. All rights reserved.
//

#import "SocialPaymentInfo.h"

@implementation SocialPaymentInfo

- (id)initWithDict:(NSDictionary *)_dict
{
    self = [super init];
    if (self) {
        self.postid     = [_dict objectForKey:@"postid"];
        self.firstname  = [_dict objectForKey:@"firstname"];
        self.lastname   = [_dict objectForKey:@"lastname"];
        self.phonenumber = [_dict objectForKey:@"phonenumber"];
        self.email      = [_dict objectForKey:@"email"];
        self.address1   = [_dict objectForKey:@"address1"];
        self.address2   = [_dict objectForKey:@"address2"];
        self.address3   = [_dict objectForKey:@"address3"];
        self.country    = [_dict objectForKey:@"country"];
        self.city       = [_dict objectForKey:@"city"];
        self.state      = [_dict objectForKey:@"state"];
        self.zipcode    = [_dict objectForKey:@"zipcode"];
        self.casetype   = [_dict objectForKey:@"casetype"];
    }
    return self;
}

@end
