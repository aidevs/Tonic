//
//  ForgotPasswordVC.h
//  BarberApp
//
//  Created by Pankaj Asudani on 09/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordVC : UIViewController<UIGestureRecognizerDelegate>

/**
 * HTTPService to call webservices
 **/
@property(nonatomic, strong) HTTPService  *httpServiceObject;

@end
