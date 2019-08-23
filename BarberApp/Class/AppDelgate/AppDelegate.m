//
//  AppDelegate.m
//  BarberApp
//
//  Created by Deepesh on 3/2/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import "AppDelegate.h"
//#import "Crittercism.h"

@interface AppDelegate () <UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tap;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector (gestureRecognizer:shouldReceiveTouch:)];
    tap.delegate = self;
    [self.window addGestureRecognizer:tap];
//    self.window.exclusiveTouch = YES;
    self.window.userInteractionEnabled = YES;
   // [Crittercism enableWithAppID:@"59cc82a8dfcf46f5a3c139eecfe41d8500555300"];
    
   
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@",APPDELEGATE.currentVC);
    
    if ([APPDELEGATE.currentVC isEqualToString:@"WalkIn"]) {
         [APPDELEGATE.walkInTimer invalidate];
        APPDELEGATE.walkInTimer = nil;
        
         APPDELEGATE.walkInTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(timeOutAction1) userInfo:nil repeats:YES];
        
    } else if ([APPDELEGATE.currentVC isEqualToString:@"Reservations"]) {
         [APPDELEGATE.reservationTimer invalidate];
        APPDELEGATE.reservationTimer = nil;
        
         APPDELEGATE.reservationTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(timeOutAction2) userInfo:nil repeats:YES];
    }
   
   
   
    
   
    
//    APPDELEGATE.walkInTimer = nil;
//    APPDELEGATE.reservationTimer = nil;
    NSLog(@"touch at %@, %@", touch.view ,NSStringFromCGPoint([touch locationInView:touch.view]));
    
    return NO;
}

-(void)timeOutAction1 {
    
//    [APPDELEGATE.walkInTimer invalidate];
//    APPDELEGATE.walkInTimer = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeOutActionWalkIn" object:self];
   
}

-(void)timeOutAction2 {
    
//    [APPDELEGATE.reservationTimer invalidate];
//    APPDELEGATE.reservationTimer  = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeOutActionReservation" object:self];
}
//-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//    // Prepare the Device Token for Registration (remove spaces and < >)
//    NSString *devToken = [[[[deviceToken description]
//                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                           stringByReplacingOccurrencesOfString:@">" withString:@""]
//                          stringByReplacingOccurrencesOfString: @" " withString: @""];
//    NSLog(@"My token is: %@", devToken);
//}
//-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
//
//{
//    NSLog(@"Failed to get token, error: %@", error);  
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
