//
//  CommonFunctions.m
//  WhatzzApp
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "CommonFunctions.h"
#import "UIDevice+Macros.h"
#import "UI+Macros.h"
#import "Reachability.h"

@implementation CommonFunctions


+ (BOOL)isValidEmailId:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

//+ (BOOL)isValidMobile:(NSString*)mobile
//{
//    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    
//    return [phoneTest evaluateWithObject:mobile];
//}


+ (NSString *)documentsDirectory {
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    return [paths objectAtIndex:0];
    
}


+(BOOL) reachabiltyCheck
{
    //NSLog(@"reachabiltyCheck");
    BOOL status =YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    //NSLog(@"status : %d",[reach currentReachabilityStatus]);
    
    [reach startNotifier];
    
    if([reach currentReachabilityStatus]==0)
    {
        status = NO;
        //NSLog(@"network not connected");
    }
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    return status;
}


+(BOOL)reachabilityChanged:(NSNotification*)note
{
    BOOL status =YES;
    BOOL status1 =YES;
    NSLog(@"reachabilityChanged");
    Reachability * reach = [note object];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            status = NO;
            status1 = NO;
            //            [APPDELEGATE.communication closeStream];
            //            APPDELEGATE.communication = nil;
            
            //NSLog(@"Not Reachable");
        }
            break;
        case ReachableViaWiFi:
        {
            //            [APPDELEGATE.communication closeStream];
            //            APPDELEGATE.communication = nil;
            //            [APPDELEGATE tcpConnectionCreation];
        }
            break;
        case ReachableViaWWAN:
        {
            //            [APPDELEGATE.communication closeStream];
            //            APPDELEGATE.communication = nil;
            //            [APPDELEGATE tcpConnectionCreation];
        }
            break;
        default:
        {
            
        }
            break;
    }
    return status;
}

+ (BOOL)getStatusForNetworkConnectionAndShowUnavailabilityMessage:(BOOL)showMessage
{
    if (([[Reachability reachabilityWithHostname:[[NSURL URLWithString:SiteAPIURL]host]] currentReachabilityStatus] == NotReachable))
    {
        if (showMessage == NO)
            return NO;
        [CommonFunctions alertTitle:NSLocalizedString(@"NetError", @"")
                        withMessage:NSLocalizedString(@"NetErrorMsg", @"")];
        
        return NO;
    }
    return YES;
}

+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg withDelegate:(id)delegate{
    
    if ([UIAlertController class])
    {
        // use UIAlertController
        UIAlertController *alert= [UIAlertController
                                   alertControllerWithTitle:aTitle
                                   message:aMsg
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action){
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        
        [alert addAction:ok];

        [APPDELEGATE.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
    }
}

+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg{
    [self alertTitle:aTitle withMessage:aMsg withDelegate:nil];
}


+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg withDelegate:(id)delegate withTag:(int)tag
{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:aTitle
                                                     message:aMsg
                                                    delegate:delegate
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil, nil];
    [alert setTag:tag];
    [alert show];
}


+ (BOOL)isValueNotEmpty:(NSString*)aString
{
    if (aString == nil || [aString length] == 0){
        [CommonFunctions alertTitle:@"Server Response Error"
                        withMessage:@"Please try again, server is not responding."];
        return NO;
    }
    return YES;
}

+ (BOOL)isValueNotEmpty1:(NSString*)aString
{
    if (aString == nil || [aString length] == 0){
        return NO;
    }return YES;
}

+ (void)showServerNotFoundError
{
    [CommonFunctions alertTitle:@"Server Not Found" withMessage:@"Please try again"];
}

+ (BOOL)isRetineDisplay{
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        return YES;
    } else {
        // not Retine display
        return NO;
    }
}

+(void) setNavigationBar:(UINavigationController*)navController
{
    UINavigationBar *navBar = navController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"header_bg"]; //@"navbar"
    [navBar setBackgroundImage:image forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    [navBar setTranslucent:NO];
    [navController setNavigationBarHidden:FALSE];
    [navController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus !=  NotReachable;
}

+ (void) showAlertWithInfo:(NSDictionary*) infoDic
{
    int tag = 0;
    if ([infoDic objectForKey:@"tag"])
        tag = [[infoDic objectForKey:@"tag"] intValue];
    
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:[infoDic objectForKey:@"title"] message:[infoDic objectForKey:@"message"] delegate:[infoDic objectForKey:@"delegate"] cancelButtonTitle:[infoDic objectForKey:@"cancel"] otherButtonTitles:[infoDic objectForKey:@"other"],nil];
    [alertView setTag:tag];
    [alertView show];
}

+(void) showCommonAlert:(NSDictionary*)dic
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[dic objectForKey:@"title"] message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}

+ (void)showActivityIndicatorWithText:(NSString *)text detailedText:(NSString*)detailedText{
    [self removeActivityIndicator];
    
    MBProgressHUD *hud   =  [MBProgressHUD showHUDAddedTo:APPDELEGATE.window animated:YES];
    hud.labelText        =  text;
    hud.detailsLabelText =  detailedText;
    hud.graceTime        =  5.0;
}

+ (void)removeActivityIndicator
{
    [MBProgressHUD hideAllHUDsForView:APPDELEGATE.window animated:YES];
}

+ (id)removeNSNULL:(id)object{
    if ([object isMemberOfClass:[NSNull class]]) {
        object = nil;
    }
    if (object == [NSNull null]) {
        object = nil;
    }
    return object;
}

+ (BOOL) connectedToNetwork
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.google.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}

+(NSInteger)getAge:(NSDate*)date
{
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]components:NSYearCalendarUnit  fromDate:date toDate:now options:0];
    
    return[ageComponents year];
}


+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - isValidMobileNumber

/**
 * Function name isValidMobileNumber
 *
 * @params: NSString
 *
 * @object: function to check a valid Mobile #
 *
 * return BOOL
 */
+ (BOOL)isValidMobileNumber:(NSString*)number
{
    NSString *phoneRegex = @"^[0-9]{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [predicate evaluateWithObject:number];
}

#pragma mark - Converter Emoji Unicode

+(NSString *)convertEmojiToUnicode:(NSString *)str_sendMessage
{
    
    NSData *data = [str_sendMessage dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *return_unicodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return return_unicodeStr;
}

+(NSString *)convertUnicodeToEmoji:(NSString *)str_receiveMessage
{
    
    NSData *data1 = [str_receiveMessage dataUsingEncoding:NSUTF8StringEncoding];
    NSString *return_emojiStr = [[NSString alloc] initWithData:data1 encoding:NSNonLossyASCIIStringEncoding];
    
    return return_emojiStr;
}


#pragma mark Animated HUB

+(void) showHUDWithLabel:(NSString *)messageLabel ForNavigationController:(UINavigationController *) navController
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:APPDELEGATE.window animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD setBackgroundColor:[UIColor clearColor]];
    HUD.removeFromSuperViewOnHide = YES;
    
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage animatedImageWithImages:[NSArray arrayWithObjects:                                        [UIImage imageNamed:@"loading1"],[UIImage imageNamed:@"loading2"],
                                                                                                   [UIImage imageNamed:@"loading3"],[UIImage imageNamed:@"loading4"],
                                                                                                   [UIImage imageNamed:@"loading5"],[UIImage imageNamed:@"loading6"],
                                                                                                   [UIImage imageNamed:@"loading7"],[UIImage imageNamed:@"loading8"],
                                                                                                   [UIImage imageNamed:@"loading9"],[UIImage imageNamed:@"loading10"],
                                                                                                   [UIImage imageNamed:@"loading11"],[UIImage imageNamed:@"loading12"],
                                                                                                   nil] duration:1.0]];
    
    [customView startAnimating];
    HUD.customView = customView;
    
    if(messageLabel != nil) {
        HUD.labelText = messageLabel;
    }
    
    [HUD bringSubviewToFront:navController.view];
}

@end
