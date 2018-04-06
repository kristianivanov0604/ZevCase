//
//  SocialFeedCell.m
//  Social
//
//  Created by XinZhangZhe on 01/08/13.
//  Copyright (c) 2013 Xin ZhangZhe. All rights reserved.
//
// --- Headers --- ;
//#import "SocialAppDelegate.h"

#import "AppDelegate.h"

#import "SocialFeedCell.h"
#import "SocialFeed.h"
#import "SocialComment.h"
#import "SocialActionSheet.h"

#import "SocialCommunication.h"
#import "SocialHelper.h"

#import "GlobalData.h"
#import "UIImageView+AFNetworking.h"

// --- Defines --- ;
// SocialFeedUser Class ;
@implementation SocialFeedUser

// Properties ;
@synthesize delegate ;
@synthesize feed ;

// Functions ;
#pragma mark - Shared Funtions
+ ( SocialFeedUser* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialFeedCell" owner : nil options : nil ] ;
    SocialFeedUser*     view    = [ array objectAtIndex : 0 ] ;
    
    return view ;
}

#pragma mark - SocialFeedUser
- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) touchesEnded : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    if( [ delegate respondsToSelector : @selector( didSelectedUser: ) ] )
    {
        [ delegate performSelector : @selector( didSelectedUser: ) withObject : [ self feed ] ] ;
    }
}

#pragma mark - Set
- ( void ) setFeed : ( SocialFeed* ) _feed
{
    // Set ;

    
    feed    = _feed ;

    // UI ;
    [ imgForAvatar setImageWithURL : [ NSURL URLWithString : [ feed avatar ] ]
                  placeholderImage : [ UIImage imageNamed : @"anonymousUser.png" ] ] ;
    [GlobalMethods setRoundView:imgForAvatar
                    borderColor:[UIColor colorWithRed:0 green:0.5f blue:0.45f alpha:1.0f]];
    [ lblForUsername setText : [ feed username ] ] ;
    [ lblForName setText : [feed name]];
    [ lblForTime setText : [ SocialHelper timeElapsed : [ feed date ] ] ] ;
    
}

@end

// SocialFeedPhoto Class ;
@implementation SocialFeedPhoto

// Properties ;
@synthesize delegate ;
@synthesize feed ;

// Functions ;
+ ( SocialFeedPhoto* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialFeedCell" owner : nil options : nil ] ;
    SocialFeedPhoto*    cell    = [ array objectAtIndex : 1 ] ;
    
    return cell ;
}

- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) touchesEnded : ( NSSet* ) _touches withEvent : ( UIEvent* ) _event
{
    UITouch*    touch   = [ _touches anyObject ] ;
    
    if( [ touch tapCount ] == 2 && [ feed liked ] == NO )
    {
        [ feed setLiked : YES ] ;
        [ feed setLikes : [ feed likes ] + 1 ] ;

        [ [ SocialCommunication sharedManager ] LikeAdd : [ self feed ]
                                              successed : nil
                                                failure : nil ] ;

        if( [ self.delegate respondsToSelector : @selector( didLikedFeed: ) ] )
        {
            [ self.delegate performSelector : @selector( didLikedFeed: ) withObject : [ self feed ] ] ;
        }
    }
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setFeed : ( SocialFeed* ) _feed
{
    // Set ;

    
    feed    = _feed ;

    
    // UI ;
    [ imgForPhoto setImageWithURL : [ NSURL URLWithString : [ feed photo ] ]
                 placeholderImage : [ UIImage imageNamed  : @"base_iphone5s-1" ] ] ;
}

@end

// SocialFeedLikes Class ;
@implementation SocialFeedLikes

// Properties ;
@synthesize delegate ;
@synthesize feed ;

// Functions ;
+ ( SocialFeedLikes* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialFeedCell" owner : nil options : nil ] ;
    SocialFeedLikes*    cell    = [ array objectAtIndex : 2 ] ;
    
    return cell ;
}

- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setFeed : ( SocialFeed* ) _feed
{
    // Set ;
   
    feed    = _feed ;
    
    // UI ;
    [ btnForLikes setTitle : [ NSString stringWithFormat : @"%d likes", [ feed likes ] ] forState : UIControlStateNormal ] ;
}

#pragma mark - Events
- ( IBAction ) onBtnLikes : ( id ) _sender
{
    if( [ self.delegate respondsToSelector : @selector( didLikes: ) ] )
    {
        [ self.delegate performSelector : @selector( didLikes: ) withObject : [ self feed ] ] ;
    }
}

@end

// SocialFeedComment Class ;
@implementation SocialFeedComment

// Properties ;
@synthesize delegate ;
@synthesize comment ;

// Functions ;
+ ( SocialFeedComment* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialFeedCell" owner : nil options : nil ] ;
    SocialFeedComment*  cell    = [ array objectAtIndex : 6 ] ;
    
    return cell ;
}

+ ( CGFloat ) height : ( SocialComment* ) _comment
{
    NSString*   string  = [ NSString stringWithFormat : @"%@\n%@", [ _comment username ], [ _comment comment ] ] ;
    CGFloat     height  = 8.0f + ceilf( [ string sizeWithFont : [ UIFont systemFontOfSize : 17.0f ] constrainedToSize : CGSizeMake( 273.0f, 999 ) lineBreakMode : NSLineBreakByWordWrapping ].height ) ;
    height = 35.0f;
    return height ;
}

- (IBAction)commentUserSelectAction:(id)sender {
    SEL     didSelectedUser = @selector(didSelectedUser:);
    if (self.delegate) {
        if ([self.delegate respondsToSelector:didSelectedUser]) {
            [self.delegate performSelector:didSelectedUser withObject:comment];
        }
    }
}

- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) awakeFromNib
{
//  lblForComment.highlightedShadowColor = [ UIColor colorWithWhite : 0.0f alpha : 0.25f ] ;
//  lblForComment.highlightedShadowOffset = CGSizeMake( 0.0f, -1.0f ) ;
//  lblForComment.highlightedShadowRadius = 1 ;
    lblForComment.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop ;
    lblForComment.delegate = self ;
    
    NSMutableDictionary* mutableLinkAttributes = [ NSMutableDictionary dictionary ] ;
    
    [ mutableLinkAttributes setValue : ( id )[ [ UIColor blueColor ] CGColor ] forKey : ( NSString* )kCTForegroundColorAttributeName ] ;
    [ mutableLinkAttributes setValue : [ NSNumber numberWithBool : NO ] forKey : ( NSString* )kCTUnderlineStyleAttributeName ] ;
    
    lblForComment.linkAttributes = mutableLinkAttributes ;
    
    NSMutableDictionary* mutableActiveLinkAttributes = [ NSMutableDictionary dictionary ] ;
    
    [ mutableActiveLinkAttributes setValue : ( id )[ [ UIColor redColor ] CGColor ] forKey : ( NSString* )kCTForegroundColorAttributeName ] ;
    [ mutableActiveLinkAttributes setValue : [ NSNumber numberWithBool : NO ] forKey : ( NSString* )kCTUnderlineStyleAttributeName ] ;
    
    lblForComment.activeLinkAttributes = mutableActiveLinkAttributes ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setComment : ( SocialComment* ) _comment
{
    // Set ;
    
    comment     = _comment ;
    
    for (UIView *view in btnCommentUserAvator.subviews) {
        [view removeFromSuperview];
    }
    [btnCommentUserAvator setBackgroundImage:nil forState:UIControlStateNormal];
    UIImageView *imgCommentUserAvator = [[UIImageView alloc]
                                         initWithFrame:CGRectMake(0, 0,
                                                                  btnCommentUserAvator.frame.size.width,
                                                                  btnCommentUserAvator.frame.size.height)];
    
    [imgCommentUserAvator setImageWithURL:[NSURL URLWithString:comment.avatar]
                         placeholderImage:[UIImage imageNamed:@"anonymousUser"]];

    [GlobalMethods setRoundView:imgCommentUserAvator borderColor:nil];
    [btnCommentUserAvator addSubview:imgCommentUserAvator];
    
    [lblCommentUsername setText:[comment username]];
    
    [lblComment         setText:[comment comment]];
    

    /*
    
    // UI ;
    [ lblForComment setText : [ NSString stringWithFormat : @"%@ %@", [ comment username ], [ comment comment ] ] afterInheritingLabelAttributesAndConfiguringWithBlock : nil ] ;
    
    NSMutableAttributedString*  mas         = [ lblForComment.attributedText mutableCopy ] ;
    NSRegularExpression*        userRegex   = [ NSRegularExpression regularExpressionWithPattern : @"^\\w+" options : NSRegularExpressionCaseInsensitive error : nil ] ;    
    NSRegularExpression*        usersRegex  = [ NSRegularExpression regularExpressionWithPattern : @"\\B@\\w+" options : NSRegularExpressionCaseInsensitive error : nil ] ;
    NSRegularExpression*        keyRegex    = [ NSRegularExpression regularExpressionWithPattern : @"\\B#\\w+" options : NSRegularExpressionCaseInsensitive error : nil ] ;
    NSRange                     stringRange = NSMakeRange( 0, [ mas length ] ) ;

    // Username ;
    NSRange linkRange   = [ userRegex rangeOfFirstMatchInString : [ mas string ] options : 0 range : NSMakeRange( 0, [ mas length ] ) ] ;
    NSURL*  url         = [ NSURL URLWithString : [ NSString stringWithFormat : @"user:%@", [ [ mas string ] substringWithRange : linkRange ] ] ] ;

    [ lblForComment addLinkToURL : url withRange:linkRange ] ;
    
    // Usernames ;
    [ usersRegex enumerateMatchesInString : [ mas string ]
                                  options : 0
                                    range : stringRange
                               usingBlock : ^( NSTextCheckingResult* _result, NSMatchingFlags _flags, BOOL* _stop )
     {
         NSString* string = [ [ mas string ] substringWithRange : _result.range ] ;
         NSURL* url = [ NSURL URLWithString : [ NSString stringWithFormat : @"user:%@", [ string substringFromIndex : 1 ] ] ] ;

         // Add Link ;
         [ lblForComment addLinkToURL : url withRange : _result.range ] ;
     } ] ;
    
    // Keywords
    [ keyRegex enumerateMatchesInString : [ mas string ]
                                options : 0
                                  range : stringRange
                             usingBlock : ^( NSTextCheckingResult* _result, NSMatchingFlags _flags, BOOL* _stop )
     {
         NSString* string = [ [ mas string ] substringWithRange : _result.range ] ;
         NSURL* url = [ NSURL URLWithString : [ NSString stringWithFormat : @"keyword:%@", [ string substringFromIndex : 1 ] ] ] ;

         // Add Link ;
         [ lblForComment addLinkToURL : url withRange : _result.range ] ;
     } ] ;
    */
    
    [ self setNeedsLayout ] ;
}

- ( void ) attributedLabel : ( TTTAttributedLabel* ) _label didSelectLinkWithURL : ( NSURL* ) _url
{
	if( [ [ _url scheme ] isEqualToString : @"user" ] )
    {
        if( [ self.delegate respondsToSelector : @selector( didSelectedUsername: ) ] )
        {
            [ self.delegate performSelector : @selector( didSelectedUsername: ) withObject : [ _url resourceSpecifier ] ] ;
        }
        return ;
    }
    
    if( [ [ _url scheme ] isEqualToString : @"keyword" ] )
    {
        NSLog( @"Keyword : %@", [ _url resourceSpecifier ] ) ;
        return ;
    }
}

@end

// SocialFeedComment Class ;
@implementation SocialFeedDetail

// Properties ;
@synthesize delegate ;
@synthesize feed ;

// Functions ;
+ ( SocialFeedDetail* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialFeedCell" owner : nil options : nil ] ;
    SocialFeedDetail*   cell    = [ array objectAtIndex : 7 ] ;
    
    return cell ;
}

- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}


- ( void ) awakeFromNib
{
    // Like ;
    UIImage*    imgForLike              = [ [ UIImage imageNamed : @"likeButton.png" ] stretchableImageWithLeftCapWidth : 21 topCapHeight : 0 ] ;
    UIImage*    imgForLikePressed       = [ [ UIImage imageNamed : @"likeButtonActive.png" ] stretchableImageWithLeftCapWidth : 21 topCapHeight : 0 ] ;
    UIImage*    imgForLikeSelected      = [ [ UIImage imageNamed : @"likeButtonLiked.png" ] stretchableImageWithLeftCapWidth : 21 topCapHeight : 0 ] ;
    
    [ btnForLike setBackgroundImage : imgForLike  forState : UIControlStateNormal ] ;
    [ btnForLike setBackgroundImage : imgForLikePressed  forState : UIControlStateHighlighted ] ;
    [ btnForLike setBackgroundImage : imgForLikeSelected  forState : UIControlStateSelected ] ;
    
    // Comment ;
    UIImage*    imgForComment           = [ [ UIImage imageNamed : @"commentButton.png" ] stretchableImageWithLeftCapWidth : 21 topCapHeight : 0 ] ;
    UIImage*    imgForCommentPressed    = [ [ UIImage imageNamed : @"commentButtonActive.png" ] stretchableImageWithLeftCapWidth : 21 topCapHeight : 0 ] ;
    
    [ btnForComment setBackgroundImage : imgForComment  forState : UIControlStateNormal ] ;
    [ btnForComment setBackgroundImage : imgForCommentPressed  forState : UIControlStateHighlighted ] ;
    [ btnForComment setBackgroundImage : imgForCommentPressed  forState : UIControlStateSelected ] ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setFeed : ( SocialFeed* ) _feed
{
    // Set ;
    
    feed = _feed ;
    
    // UI ;
//    [ btnForLike setSelected : [ feed liked ] ] ;
//    [lblPrice setText:[NSString stringWithFormat:@"$29.99" ]];
    
    [self setLike:feed.liked];
    [self checkingMyCommented];
    
}

- (void) setLike:(BOOL)flag
{
    if (flag) {
        [imgLike setImage:[UIImage imageNamed:@"liked"]];
        [btnLike setTitle:@"Liked" forState:(UIControlStateNormal)];
        [btnLike setTitleColor:[UIColor colorWithRed:0 green:0.5f blue:0.45f alpha:1.0f] forState:UIControlStateNormal];
    } else {
        [imgLike setImage:[UIImage imageNamed:@"like"]];
        [btnLike setTitle:@"Like" forState:(UIControlStateNormal)];
        [btnLike setTitleColor:[UIColor colorWithWhite:0.4f alpha:1.0f] forState:UIControlStateNormal];
    }
}

- (void) checkingMyCommented
{
    NSString *meUserID = [ [ SocialCommunication sharedManager ] me ].userid;
    for (SocialComment *elem in feed.commentArray) {
        if ([meUserID isEqualToString:elem.userid]) {
            [imgComment setImage:[UIImage imageNamed:@"commented"]];
            [btnComment setTitle:@"Commented" forState:(UIControlStateNormal)];
            [btnComment setTitleColor:[UIColor colorWithRed:0 green:0.5f blue:0.45f alpha:1.0f]
                             forState:UIControlStateNormal];
            return;
        }
    }
    [imgComment setImage:[UIImage imageNamed:@"comment"]];
    [btnComment setTitle:@"Comment" forState:(UIControlStateNormal)];
    [btnComment setTitleColor:[UIColor colorWithWhite:0.4f alpha:1.0f]
                     forState:UIControlStateNormal];

}

- ( IBAction ) onBtnLike : ( id ) _sender
{
    [ feed setLiked : ![ feed liked ] ] ;
    [ feed setLikes : [ feed likes ] + ( [ feed liked ] ? 1 : -1 ) ] ;
    
//    [ btnForLike setSelected : [ feed liked ] ] ;
    
    [self setLike:feed.liked];
    
    if( [ feed liked ] )
    {
        [ [ SocialCommunication sharedManager ] LikeAdd : [ self feed ]
                                              successed : nil
                                                failure : nil ] ;
    }
    else
    {
        [ [ SocialCommunication sharedManager ] LikeRemove : [ self feed ]
                                                 successed : nil
                                                   failure : nil ] ;
    }
    
    if( [ self.delegate respondsToSelector : @selector( didLikedFeed: ) ] )
    {
        [ self.delegate performSelector : @selector( didLikedFeed: ) withObject : [ self feed ] ] ;
    }
}

- ( IBAction ) onBtnComment : ( id ) _sender
{
    if( [ self.delegate respondsToSelector : @selector( didComment: ) ] )
    {
        [ self.delegate performSelector : @selector( didComment: ) withObject : [ self feed ] ] ;
    }
}

- ( IBAction ) onBtnOptions : ( id ) _sender
{
    if( [ self.delegate respondsToSelector : @selector( didOptions: ) ] )
    {
        [ self.delegate performSelector : @selector( didOptions: ) withObject : [ self feed ] ] ;
    }
}

- ( void ) actionSheet : ( UIActionSheet* ) _actionSheet clickedButtonAtIndex : ( NSInteger ) _buttonIndex
{
/*  NSArray*    buttons = [ _actionSheet valueForKey : @"_buttons" ] ;
    UIButton*   button  = [ buttons objectAtIndex : _buttonIndex ] ;
    NSString*   title   = [ button titleForState : UIControlStateNormal ] ; */
    
    SocialUser* me = [ [ SocialCommunication sharedManager ] me ] ;
    
    if( [ [ me userid ] isEqualToString : [ [ self feed ] userid ] ] )
    {
        switch( _buttonIndex )
        {
            case 0 :
                break ;
                
            default :
                break ;
        }
    }
    else
    {
        switch( _buttonIndex )
        {
            case 0 :
                break ;
                
            default :
                break ;
        }
    }
}

@end

// SocialFeedGrid Class ;
@implementation SocialFeedGrid

// Properties ;
@synthesize delegate ;
@synthesize feed1 ;
@synthesize feed2 ;
@synthesize feed3 ;

// Functions ;
+ ( SocialFeedGrid* ) sharedCell
{
    NSArray*            array   = [ [ NSBundle mainBundle ] loadNibNamed : @"SocialFeedCell" owner : nil options : nil ] ;
    SocialFeedGrid*     cell    = [ array objectAtIndex : 5 ] ;
    
    return cell ;
}

- ( id ) initWithStyle : ( UITableViewCellStyle ) _style reuseIdentifier : ( NSString* ) _reuseIdentifier
{
    self = [ super initWithStyle : _style reuseIdentifier : _reuseIdentifier ] ;
    
    if( self )
    {
        
    }
    
    return self ;
}

- ( void ) layoutSubviews
{
    [ super layoutSubviews ] ;
}

- ( void ) setSelected : ( BOOL ) _selected animated : ( BOOL ) _animated
{
    
}

- ( void ) setFeed1 : ( SocialFeed* ) _feed
{
    // Set ;
   
    feed1   = _feed ;
    
    // UI ;
//    [ imgForFeed1 setImageWithURL : [ NSURL URLWithString:  [ feed1 photo ] ] ] ;
    
    // 3K (25/01/2014)
//    [viewFeed1 setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:0.1f]];
    [ imgForFeed1 setImageWithURL : [ NSURL URLWithString:  [ feed1 photo ] ]
                 placeholderImage : [ UIImage imageNamed:   @"base_iphone5s-1" ] ] ;
    [ lblTitle1     setText : [ feed1 name ] ] ;
    [ lblUsername1  setText : [ feed1 username ] ] ;

    
}

- ( void ) setFeed2 : ( SocialFeed* ) _feed
{
    // Set ;
    if( feed2 )
    {
        feed2 = nil ;
    }

    if( _feed )
    {
        feed2   = _feed ;

    }
    
    // UI ;
    if( feed2 )
    {
        [ btnForFeed2 setHidden : NO ] ;
        
        [ imgForFeed2 setHidden : NO ] ;
//        [ imgForFeed2 setImageWithURL : [ NSURL URLWithString:  [ feed2 photo ] ] ] ;
        [ imgForFeed2 setImageWithURL : [ NSURL URLWithString:  [ feed2 photo ] ]
                     placeholderImage : [ UIImage imageNamed:   @"base_iphone5s-1"]];  // 3K (25/01/2014)
        
        [ lblTitle2     setText : [ feed2 name ] ] ;
        [ lblUsername2  setText : [ feed2 username ] ] ;

        [ viewFeed2 setHidden : NO ] ;
    }
    else
    {
//        [ btnForFeed2 setHidden : YES ] ;        
//        [ imgForFeed2 setHidden : YES ] ;
        [ viewFeed2 setHidden : YES ] ;
    }
}

- ( void ) setFeed3 : ( SocialFeed* ) _feed
{
    // Set ;
    if( feed3 )
    {
        feed3 = nil ;
    }
    
    if( _feed )
    {
        feed3   = _feed ;

    }
    
    // UI ;
    if( feed3 )
    {
        [ btnForFeed3 setHidden : NO ] ;        
        [ imgForFeed3 setHidden : NO ] ;
        [ imgForFeed3 setImageWithURL : [ NSURL URLWithString:  [ feed3 photo ] ] ] ;
    }
    else
    {
        [ btnForFeed3 setHidden : YES ] ;
        [ imgForFeed3 setHidden : YES ] ;
    }
}

#pragma mark - Events
- ( IBAction ) onBtnFeed1 : ( id ) _sender
{
    if( [ self.delegate respondsToSelector : @selector( didSelectedFeed: ) ] )
    {
        [ self.delegate performSelector : @selector( didSelectedFeed: ) withObject : [ self feed1 ] ] ;
    }
}

- ( IBAction ) onBtnFeed2 : ( id ) _sender
{
    if( [ self.delegate respondsToSelector : @selector( didSelectedFeed: ) ] )
    {
        [ self.delegate performSelector : @selector( didSelectedFeed: ) withObject : [ self feed2 ] ] ;
    }
}

- ( IBAction ) onBtnFeed3 : ( id ) _sender
{
    if( [ self.delegate respondsToSelector : @selector( didSelectedFeed: ) ] )
    {
        [ self.delegate performSelector : @selector( didSelectedFeed: ) withObject : [ self feed3 ] ] ;
    }
}

@end