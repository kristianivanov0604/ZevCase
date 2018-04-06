//
//  SocialCommunication.h
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

// --- Classes --- ;
@class SocialUser ;
@class SocialFeed ;
@class SocialPaymentInfo ;

// --- Defines --- ;
// SocialCommunication Class ;
@interface SocialCommunication : NSObject

// Properties ;
@property ( strong, nonatomic ) SocialUser*         me ;
@property ( strong, nonatomic) NSMutableArray * originalImages;
@property ( strong, nonatomic ) CLLocationManager*  locationManager ;
@property ( strong, nonatomic ) CLLocation*         location ;

// Functions ;
+ ( SocialCommunication* ) sharedManager ;

// Sign ;
- ( void ) SignIn : ( NSString* ) _username
         password : ( NSString* ) _password
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) SignUp : ( NSData* ) _avatar
         username : ( NSString* ) _username
         password : ( NSString* ) _password
            email : ( NSString* ) _email
             name : ( NSString* ) _name
            phone : ( NSString* ) _phone
          address : ( NSString *) _address
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure ;

//original Image Uploading

-(void) originalImageUpload : (NSString *)_postid
                 photoIndex : (NSString *)_index
                       count: (NSString *)_count
                   subPhoto : (NSData *)_subPhoto
                  successed : (void (^)(id _responseObject)) _success
                    failure : (void (^)(NSError * _error)) _failure;




// Profile ;
- ( void ) GetProfile : ( NSString* ) _username
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) SetProfile : ( NSData* ) _avatar
                 name : ( NSString* ) _name
             username : ( NSString* ) _username
              website : ( NSString* ) _website
                  bio : ( NSString* ) _bio
                email : ( NSString* ) _email
                phone : ( NSString* ) _phone
               gender : ( NSString* ) _gender
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) SetPassword : ( NSString* ) _oldPassword
           newPassword : ( NSString* ) _newPassword
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) SetPrivatePhotos : ( BOOL ) _privatePhotos
                  successed : ( void (^)( id _responseObject ) ) _success
                    failure : ( void (^)( NSError* _error ) ) _failure ;

// Follow ;
- ( void ) FollowingAdd : ( SocialUser* ) _user
              successed : ( void (^)( id _responseObject ) ) _success
                failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) FollowingRemove : ( SocialUser* ) _user
                 successed : ( void (^)( id _responseObject ) ) _success
                   failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) Followers : ( SocialUser* ) _user
           successed : ( void (^)( id _responseObject ) ) _success
             failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) Followings : ( SocialUser* ) _user
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure ;

// Feed ;
- ( void ) FeedAdd : ( NSData* ) _photo
              name : ( NSString *)_name
               tag : ( NSString *)_tag
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) FeedRemove : ( NSString* ) _postId
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) Feeds : ( SocialUser* ) _user
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) FeedFollows : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) FeedNews : ( void (^)( id _responseObject ) ) _success
            failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) FeedTag : ( NSString* ) _tag
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure;

//Search
- ( void ) SearchTag : ( NSString* ) _tag
           successed : ( void (^)( id _responseObject ) ) _success
             failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) SearchUser : ( NSString* ) _user
           successed : ( void (^)( id _responseObject ) ) _success
             failure : ( void (^)( NSError* _error ) ) _failure ;

// Like ;
- ( void ) LikeAdd : ( SocialFeed* ) _feed
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) LikeRemove : ( SocialFeed* ) _feed
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) Likes : ( SocialFeed* ) _feed
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure ;

// Comment ;
- ( void ) CommentAdd : ( SocialFeed* ) _feed
              comment : ( NSString* ) _comment
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) CommentRemove : ( NSString* ) _commentId
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) Comments : ( SocialFeed* ) _feed
          successed : ( void (^)( id _responseObject ) ) _success
            failure : ( void (^)( NSError* _error ) ) _failure ;

// Notifications;
- ( void ) Notifications : ( SocialUser* ) _user
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure ;

// Payment;
- ( void ) Payment : ( SocialUser* ) _user
              feed : ( SocialFeed* ) _feed
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) Payment : ( SocialUser* ) _user
              info : ( SocialPaymentInfo* ) _info
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure ;

@end