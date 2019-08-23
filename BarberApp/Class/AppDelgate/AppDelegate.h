//
//  AppDelegate.h
//  BarberApp
//
//  Created by Deepesh on 3/2/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString * VCName;

@property (strong, nonatomic) NSTimer *walkInTimer;
@property (strong, nonatomic) NSTimer *reservationTimer;
@property (strong, nonatomic) NSString * currentVC;
@property (strong, nonatomic) NSString *isSeatTapped;
-(void)timeOutAction1;
-(void)timeOutAction2;
@end

