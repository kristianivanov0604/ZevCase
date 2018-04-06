//
//  SocialCommunication.m
//  Social
//
//  Created by Yu Li on 01/08/13.
//  Copyright (c) 2013 Yu Li. All rights reserved.
//
// --- Headers --- ;
#import "SocialCommunication.h"
#import "SocialUser.h"
#import "SocialFeed.h"
#import "SocialPaymentInfo.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

// --- Defines --- ;
// Web Services ;
#define WEBAPI_URL                  @"http://www.zevcases.com/mobile/mobileservice.php"
//#define WEBAPI_URL                  @"http://192.168.1.177/mobile/mobileservice.php"

// Sign ;
#define WEBAPI_SIGNIN               @"signin"
#define WEBAPI_SIGNUP               @"signup"

// Profile ;
#define WEBAPI_GETPROFILE           @"getprofile"
#define WEBAPI_SETPROFILE           @"setprofile"
#define WEBAPI_SETPASSWORD          @"setpassword"
#define WEBAPI_SETPRIVATEPHOTOS     @"setprivatephotos"

// Follow ;
#define WEBAPI_FOLLOWINGADD         @"followingadd"
#define WEBAPI_FOLLOWINGREMOVE      @"followingremove"
#define WEBAPI_FOLLOWERS            @"followers"
#define WEBAPI_FOLLOWINGS           @"followings"

// Feed ;
#define WEBAPI_FEEDADD              @"feedadd"
#define WEBAPI_FEEDREMOVE           @"feedremove"
#define WEBAPI_FEEDS                @"feeds"
#define WEBAPI_FEEDFOLLOWS          @"feedfollows"
#define WEBAPI_FEEDNEWS             @"feednews"
#define WEBAPI_FEEDTAG              @"feedtag"


//original image uploading
#define WEBAPI_ORIGINAL             @"original"
// Like
#define WEBAPI_LIKEADD              @"likeadd"
#define WEBAPI_LIKEREMOVE           @"likeremove"
#define WEBAPI_LIKES                @"likes"

// Comment ;
#define WEBAPI_COMMENTADD           @"commentadd"
#define WEBAPI_COMMENTREMOVE        @"commentremove"
#define WEBAPI_COMMENTS             @"comments"

// Chat ;
#define WEBAPI_CHATSEND             @"chatsend"
#define WEBAPI_CHATRECEIVE          @"chatreceive"
#define WEBAPI_CATTCLEAR            @"chatclear"

// Search ;
#define WEBAPI_SEARCHTAG            @"searchtag"
#define WEBAPI_SEARCHUSER           @"searchuser"

// Notifications;
#define WEBAPI_NOTIFICATIONS        @"notifications"

// Payment;
#define WEBAPI_PAYMENT              @"payment"

// SocialCommunication Class ;
@interface SocialCommunication ()  < CLLocationManagerDelegate >

// Web Service ;
- ( void ) sendToService : ( NSDictionary* ) _params
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) sendToService : ( NSDictionary* ) _params
                   photo : ( NSData* ) _photo
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure ;

@end

@implementation SocialCommunication

// Properties ;
@synthesize me ;

@synthesize locationManager ;
@synthesize location ;

// Functions ;
#pragma mark - Shared Functions
+ ( SocialCommunication* ) sharedManager
{
    __strong static SocialCommunication* sharedObject = nil ;
	static dispatch_once_t onceToken ;
    
	dispatch_once( &onceToken, ^{
        sharedObject = [ [ SocialCommunication alloc ] init ] ;
	} ) ;
    
    return sharedObject ;
}

#pragma mark - SocialCommunication
- ( id ) init
{
    self = [ super init ] ;
    
    if( self )
    {
        // Location ;
        CLLocationManager*  manager =  [ [ CLLocationManager alloc ] init ]  ;

        [ manager setDelegate : self ] ;
        [ manager setDesiredAccuracy : kCLLocationAccuracyBest ] ;
        [ manager startUpdatingLocation ] ;

        [ self setMe : nil ] ;
        [ self setLocationManager : manager ] ;
        [ self setLocation : nil ] ;
    }
    
    return self ;
}

- ( void ) dealloc
{
    // Release ;
    [ self.locationManager stopUpdatingLocation ] ;

    [ self setMe : nil ] ;
    [ self setLocationManager : nil ] ;
    [ self setLocation : nil ] ;
    
}

#pragma mark - Location ;
- ( void ) locationManager : ( CLLocationManager* ) _manager didUpdateToLocation : ( CLLocation* ) _newLocation fromLocation : ( CLLocation* ) _oldLocation
{
    self.location = _newLocation ;
}

- ( void ) locationManager : ( CLLocationManager* ) _manager didFailWithError : ( NSError* ) _error
{
    NSLog( @"Invalid Postion" ) ;
}

#pragma mark - Web Service
- ( void ) sendToService : ( NSDictionary* ) _params
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    NSURL*                  url         = [ NSURL URLWithString : WEBAPI_URL ] ;
    AFHTTPClient*           client      = [ [ AFHTTPClient alloc ] initWithBaseURL : url ] ;
    NSMutableURLRequest*    request     = [ client requestWithMethod : @"POST" path : nil parameters : _params ] ;
    AFHTTPRequestOperation* operation   = [ [ AFHTTPRequestOperation alloc ] initWithRequest : request ]  ;
    
    [ client registerHTTPOperationClass : [ AFHTTPRequestOperation class ] ] ;
    [ operation setCompletionBlockWithSuccess : ^( AFHTTPRequestOperation* _operation, id _responseObject ) {
        NSString* string = [ [ NSString alloc ] initWithData : _responseObject encoding : NSUTF8StringEncoding ]  ;
        NSLog( @"%@", string ) ;
        
        // Response Object ;
        id responseObject   = [ NSJSONSerialization JSONObjectWithData : _responseObject
                                                               options : kNilOptions
                                                                 error : nil ] ;
        
        // Success ;
        if( _success )
        {
            _success( responseObject ) ;
        }
    } failure : ^( AFHTTPRequestOperation* _operation, NSError* _error )
    {
        NSLog( @"%@", _error.description ) ;
        
        // Failture ;
        if( _failure )
        {
            _failure( _error ) ;
        }
    } ] ;
    [ operation start ] ;

}

- ( void ) sendToService : ( NSDictionary* ) _params
                   photo : ( NSData* ) _photo
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    NSURL*                  url         = [ NSURL URLWithString : WEBAPI_URL ] ;
    AFHTTPClient*           client      = [ [ AFHTTPClient alloc ] initWithBaseURL : url ] ;
    
    NSMutableURLRequest*    request     = [ client multipartFormRequestWithMethod : @"POST"
                                                                             path : nil
                                                                       parameters : _params
                                                        constructingBodyWithBlock : ^( id <AFMultipartFormData > _formData ) {
                                                            if( _photo )
                                                            {
                                                                [ _formData appendPartWithFileData : _photo
                                                                                              name : @"photo"
                                                                                          fileName : @"photo"
                                                                                          mimeType : @"image/jpeg" ] ;
                                                            }
                                                        } ] ;
    AFHTTPRequestOperation* operation   = [ [ AFHTTPRequestOperation alloc ] initWithRequest : request ]  ;
    
    [ client registerHTTPOperationClass : [ AFHTTPRequestOperation class ] ] ;
    [ operation setCompletionBlockWithSuccess : ^( AFHTTPRequestOperation* _operation, id _responseObject ) {
        NSString* string = [ [ NSString alloc ] initWithData : _responseObject encoding : NSUTF8StringEncoding ]  ;
        NSLog( @"%@", string ) ;
        
        // Response Object ;
        id responseObject   = [ NSJSONSerialization JSONObjectWithData : _responseObject
                                                               options : kNilOptions
                                                                 error : nil ] ;
    
        // Success ;
        if( _success )
        {
            _success( responseObject ) ;
        }
    } failure : ^( AFHTTPRequestOperation* _operation, NSError* _error ) {
        
        NSLog( @"%@", _error.description ) ;
        
        // Failture ;
        if( _failure )
        {
            _failure( _error ) ;
        }
    } ] ;
    [ operation start ] ;
}

#pragma mark - Notification
- ( void ) PushNotificationForJoin
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
 
    // Params ;
    [ params setObject : @"" forKey : @"alert" ] ;
    [ params setObject : @"" forKey : @"type" ] ;
    [ params setObject : @"" forKey : @"user" ] ;
    
/*  PFPush* notification    = [ [ [ PFPush alloc ] init ] autorelease ] ;
    
    // Notification ;
    [ notification setChannels : nil ] ;
    [ notification setData : params ] ;
    [ notification sendPushInBackground ] ; */
}

#pragma mark - Sign
- ( void ) SignIn : ( NSString* ) _username
         password : ( NSString* ) _password
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_SIGNIN forKey : @"action" ] ;
    [ params setObject : _username forKey : @"username" ] ;
    [ params setObject : _password forKey : @"password" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) SignUp : ( NSData* ) _avatar
         username : ( NSString* ) _username
         password : ( NSString* ) _password
            email : ( NSString* ) _email
             name : ( NSString* ) _name
            phone : ( NSString* ) _phone
          address : (NSString *)  _address
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_SIGNUP forKey : @"action" ] ;
    [ params setObject : _username forKey : @"username" ] ;
    [ params setObject : _password forKey : @"password" ] ;
    [ params setObject : _email forKey : @"email" ] ;
    [ params setObject : _name forKey : @"name" ] ;
    [ params setObject : _phone forKey : @"phone" ] ;
    [ params setObject : _address forKey:@"address"];
    
    // Web Service ;
    [ self sendToService : params photo : _avatar success : _success failure : _failure ] ;
}


#pragma mark- original Image uploading

-(void) originalImageUpload : (NSString *)_postid
                 photoIndex : (NSString *)_index
                       count: (NSString *)_count
                   subPhoto : (NSData *)_subPhoto
                  successed : (void (^)(id _responseObject)) _success
                    failure : (void (^)(NSError * _error)) _failure
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:WEBAPI_ORIGINAL forKey:@"action"];
    [params setObject:_postid forKey:@"postid"];
    [params setObject:_index forKey:@"index"];
    [params setObject:_count forKey:@"count"];
    [self sendToService:params photo:_subPhoto success:_success failure:_failure];
}

#pragma mark - Profile
- ( void ) GetProfile : ( NSString* ) _username
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_GETPROFILE forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : _username forKey : @"username" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) SetProfile : ( NSData* ) _avatar
                 name : ( NSString* ) _name
             username : ( NSString* ) _username
              website : ( NSString* ) _website
                  bio : ( NSString* ) _bio
                email : ( NSString* ) _email
                phone : ( NSString* ) _phone
               gender : ( NSString* ) _gender
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_SETPROFILE forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : _name ? _name : @"" forKey : @"name" ] ;
    [ params setObject : _username ? _username : @"" forKey : @"username" ] ;
    [ params setObject : _website ? _website : @"" forKey : @"website" ] ;
    [ params setObject : _bio ? _bio : @"" forKey : @"bio" ] ;
    [ params setObject : _email ? _email : @"" forKey : @"email" ] ;
    [ params setObject : _phone ? _phone : @"" forKey : @"phone" ] ;
    [ params setObject : _gender ? _gender : @"" forKey : @"gender" ] ;
    
    // Web Service ;
//    [ self sendToService : params success : _success failure : _failure ] ;
  [ self sendToService : params photo : _avatar success : _success failure : _failure ] ;
}

- ( void ) SetPassword : ( NSString* ) _oldPassword
           newPassword : ( NSString* ) _newPassword
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_SETPASSWORD forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : _oldPassword forKey : @"oldpassword" ] ;
    [ params setObject : _newPassword forKey : @"newpassword" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) SetPrivatePhotos : ( BOOL ) _privatePhotos
                  successed : ( void (^)( id _responseObject ) ) _success
                    failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_SETPRIVATEPHOTOS forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ NSNumber numberWithBool : _privatePhotos ] forKey : @"private" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

#pragma mark - Follow
- ( void ) FollowingAdd : ( SocialUser* ) _user
              successed : ( void (^)( id _responseObject ) ) _success
                failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FOLLOWINGADD forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _user userid ] forKey : @"to" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) FollowingRemove : ( SocialUser* ) _user
                 successed : ( void (^)( id _responseObject ) ) _success
                   failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FOLLOWINGREMOVE forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _user userid ] forKey : @"to" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) Followers : ( SocialUser* ) _user
           successed : ( void (^)( id _responseObject ) ) _success
             failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FOLLOWERS forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _user userid ] forKey : @"from" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) Followings : ( SocialUser* ) _user
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FOLLOWINGS forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _user userid ] forKey : @"to" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

#pragma mark - Feed
- ( void ) FeedAdd : ( NSData* ) _photo
              name : ( NSString *)_name
               tag : ( NSString *)_tag
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FEEDADD forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : _name forKey : @"name" ] ;
    [ params setObject : _tag forKey : @"tag" ] ;
    [ params setObject : [ NSString stringWithFormat : @"%0.4f", [ [ self location ] coordinate ].latitude ] forKey : @"latitude" ] ;
    [ params setObject : [ NSString stringWithFormat : @"%0.4f", [ [ self location ] coordinate ].longitude ] forKey : @"longitude" ] ;
    
    // Web Service ;
    [ self sendToService : params photo : _photo success : _success failure : _failure ] ;
    
}

- ( void ) FeedRemove : ( NSString* ) _postId
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FEEDREMOVE forKey : @"action" ] ;
//  [ params setObject : [ [ SocialUser me ] userIdString ] forKey : @"sender" ] ;
//  [ params setObject : [ [ _feed feedPost ] postIdString ] forKey : @"post" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) Feeds : ( SocialUser* ) _user
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FEEDS forKey : @"action" ] ;
    [ params setObject : [ _user userid ] forKey : @"userid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) FeedFollows : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FEEDFOLLOWS forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) FeedNews : ( void (^)( id _responseObject ) ) _success
            failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FEEDNEWS forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) FeedTag : ( NSString* ) _tag
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_FEEDTAG forKey : @"action" ] ;
    [ params setObject : _tag forKey : @"tag" ] ;
    [ params setObject : [[ self me ] userid] forKey : @"userid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

#pragma mark - Like
- ( void ) LikeAdd : ( SocialFeed* ) _feed
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_LIKEADD forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _feed postid ] forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) LikeRemove : ( SocialFeed* ) _feed
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_LIKEREMOVE forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _feed postid ] forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) Likes : ( SocialFeed* ) _feed
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_LIKES forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _feed postid ] forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;

}

#pragma mark - Comment
- ( void ) CommentAdd : ( SocialFeed* ) _feed
              comment : ( NSString* ) _comment
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_COMMENTADD forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _feed postid ] forKey : @"postid" ] ;
    [ params setObject : _comment forKey : @"comment" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) CommentRemove : ( NSString* ) _commentId
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_COMMENTREMOVE forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : _commentId forKey : @"commentid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

- ( void ) Comments : ( SocialFeed* ) _feed
          successed : ( void (^)( id _responseObject ) ) _success
            failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_COMMENTS forKey : @"action" ] ;
    [ params setObject : [ [ self me ] userid ] forKey : @"userid" ] ;
    [ params setObject : [ _feed postid ] forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
}

#pragma mark - search
- ( void ) SearchTag : ( NSString* ) _tag
           successed : ( void (^)( id _responseObject ) ) _success
             failure : ( void (^)( NSError* _error ) ) _failure {
    
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_SEARCHTAG forKey : @"action" ] ;
    [ params setObject : _tag forKey : @"key" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
    
}

- ( void ) SearchUser : ( NSString* ) _user
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure {
    
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_SEARCHUSER forKey : @"action" ] ;
    [ params setObject : _user forKey : @"key" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
    
}

#pragma mark - notifications
- ( void ) Notifications : ( SocialUser* ) _user
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure {
    
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_NOTIFICATIONS forKey : @"action" ] ;
    [ params setObject : [_user userid] forKey : @"userid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
    
}

#pragma mark - notifications
- ( void ) Payment:(SocialUser *)_user
              feed:(SocialFeed *)_feed
         successed:(void (^)(id))_success
           failure:(void (^)(NSError *))_failure {
    
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : WEBAPI_PAYMENT forKey : @"action" ] ;
    [ params setObject : [_user userid] forKey : @"userid" ] ;
    [ params setObject : [_feed postid] forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
    
}


- ( void ) Payment:(SocialUser *)_user
              info:(SocialPaymentInfo *)_info
         successed:(void (^)(id))_success
           failure:(void (^)(NSError *))_failure {
    
    // Params ;
    NSDictionary *params = @{@"action"      : WEBAPI_PAYMENT,
                             @"userid"      : _user.userid,
                             @"postid"      : _info.postid,
                             @"firstname"   : _info.firstname,
                             @"lastname"    : _info.lastname,
                             @"phonenumber" : _info.phonenumber,
                             @"email"       : _info.email,
                             @"address1"    : _info.address1,
                             @"address2"    : _info.address2,
                             @"address3"    : _info.address3,
                             @"country"     : _info.country,
                             @"city"        : _info.city,
                             @"state"       : _info.state,
                             @"zipcode"     : _info.zipcode,
                             @"casetype"    : _info.casetype,
                             };
    
    // Web Service ;
    [ self sendToService : params success : _success failure : _failure ] ;
    
}
@end