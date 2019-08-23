//
//  LoginVC.h
//  BarberApp
//
//  Created by Pankaj Asudani on 03/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController

/**
 * HTTPService to call webservices
 **/
@property(nonatomic, strong) HTTPService  *httpServiceObject;

@end
