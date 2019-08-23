//
//  CommonFunctions.h
//
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface CommonFunctions : NSObject {
    
}

+ (NSString *)documentsDirectory;
+ (void)openEmail:(NSString *)address;
+ (void)openPhone:(NSString *)number;
+ (void)openSms:(NSString *)number;
+ (void)openBrowser:(NSString *)url;
+ (void)openMap:(NSString *)address;
+ (BOOL) validateUrl: (NSString *) candidate;
+ (BOOL)isValidMobileNumber:(NSString*)number;

+ (void) hideTabBar:(UITabBarController *) tabbarcontroller;
+ (void) showTabBar:(UITabBarController *) tabbarcontroller;
+ (void) setNavigationTitle:(NSString *) title ForNavigationItem:(UINavigationItem *) navigationItem;

+(BOOL) reachabiltyCheck;

/**
 * Normal Alert view with only Ok btn
 */
+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg withDelegate:(id)delegate;
+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg;
+ (void)alertTitle:(NSString*)aTitle withMessage:(NSString*)aMsg withDelegate:(id)delegate withTag:(int)tag;

+ (BOOL)getStatusForNetworkConnectionAndShowUnavailabilityMessage:(BOOL)showMessage;

/**
 * user for check that value is empty or not
 * shows a alert : server not responding error
 */
+ (BOOL)isValueNotEmpty:(NSString*)aString;
+ (BOOL)isValueNotEmpty1:(NSString*)aString;

/**
 * shows a alert : server not found , try again later
 */
+ (void)showServerNotFoundError;

+ (BOOL)isValidEmailId:(NSString*)email;

+ (BOOL)isRetineDisplay;
+ (BOOL)connected;
+(void) setNavigationBar:(UINavigationController*)navController;
+ (void) showAlertWithInfo:(NSDictionary*) infoDic;
+(void) showCommonAlert:(NSDictionary*)dic;

+ (void)showActivityIndicatorWithText:(NSString *)text detailedText:(NSString*)detailedText;
+ (void)removeActivityIndicator;
+ (id)removeNSNULL:(id)object;
+ (BOOL) connectedToNetwork;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
+(NSInteger)getAge:(NSDate*)date;

+(NSString *)convertEmojiToUnicode:(NSString *)str_sendMessage;
+(NSString *)convertUnicodeToEmoji:(NSString *)str_receiveMessage;

+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(void) showHUDWithLabel:(NSString *)messageLabel ForNavigationController:(UINavigationController *) navController;

@end
