//
//  Created by Deepesh on 24/02/16.
//  Copyright __MyCompanyName__ 2016. All rights reserved.
//

#ifndef ViewController_Macros_h
#define ViewController_Macros_h


#define APPDELEGATE    ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define Set_SearchBarTintColor    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar"]]];

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_SIZE ([[UIScreen mainScreen] bounds].size)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 667.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f

#define RETURN_IF_THIS_VIEW_IS_NOT_A_TOPVIEW_CONTROLLER if (self.navigationController) if (!(self.navigationController.topViewController == self)) return;

#define SHOW_STATUS_BAR               [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
#define HIDE_STATUS_BAR               [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

#define SHOW_NAVIGATION_BAR           [self.navigationController setNavigationBarHidden:FALSE];
#define HIDE_NAVIGATION_BAR           [self.navigationController setNavigationBarHidden:TRUE];

#define VC_OBJ(x) [[x alloc] init]
#define VC_OBJ_WITH_NIB(x) [[x alloc] initWithNibName : (NSString *)CFSTR(#x) bundle : nil]

#define RESIGN_KEYBOARD [UIView animateWithDuration:0.3 animations:^{[[[UIApplication sharedApplication] keyWindow] endEditing:YES];}];

#define IOS_STANDARD_COLOR_BLUE                        [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:1]

#define FONT_BaronNeue                              @"BaronNeue"
#define FONT_BaronNeue_Black_Italic                 @"BaronNeueBlackItalic"
#define FONT_BaronNeue_Bold_Italic                  @"BaronNeueBoldItalic"
#define FONT_BaronNeue_Black                        @"BaronNeueBlack"
#define FONT_BaronNeue_Bold                         @"BaronNeueBold"
#define FONT_BaronNeue_Italic                       @"BaronNeueItalic"

#define FONT_SFBurlingtonScript                     @"SFBurlingtonScript"
#define FONT_SFBurlingtonScript_Italic              @"SFBurlingtonScript-Italic"
#define FONT_SFBurlingtonScript_Bold                @"SFBurlingtonScript-Bold"
#define FONT_SFBurlingtonScript_Bold_Italic         @"SFBurlingtonScript-BoldItalic"

#define FONT_Bebas                                  @"Bebas"
#define FONT_BebasNeue                              @"BebasNeue"
#define FONT_BebasNeue_Book                         @"BebasNeueBook"
#define FONT_BebasNeue_Light                        @"BebasNeueLight"
#define FONT_BebasNeue_Bold                         @"BebasNeueBold"
#define FONT_BebasNeue_Thin                         @"BebasNeue-Thin"
#define FONT_BebasNeue_Regular                      @"BebasNeueRegular"


#define HIDE_NETWORK_ACTIVITY_INDICATOR                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#define SHOW_NETWORK_ACTIVITY_INDICATOR                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

#define SCREEN_FRAME_RECT                               [[UIScreen mainScreen] bounds]

#define NAVIGATION_BAR_HEIGHT 44

#define PRIVACY                     @"Privacy"
#define TandC                       @"Terms and conditions"
#define ABOUT                       @"About"
#define FACEBOOK_APP_ID             @"813566818665901"

#define currentLanguageBundle [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[NSLocale preferredLanguages] objectAtIndex:0] ofType:@"lproj"]]

#endif
