//
//  HomeVC.h
//  BarberApp
//
//  Created by Pankaj Asudani on 04/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpView.h"

@interface HomeVC : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,PopUpViewDelegate>{

    NSMutableArray *listAry;
    NSString       *appId;
    NSString       *userId;
    BOOL            isRfreshing;
}

@property (nonatomic, assign) CGPoint lastContentOffset;

/**
 * HTTPService to call webservices
 **/
@property(nonatomic, strong) HTTPService  *httpServiceObject;
@property(nonatomic, strong) IBOutlet UIScrollView *scrolView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *confirmationView;
@property (weak, nonatomic) IBOutlet UIView *pinView;

@property (weak, nonatomic) IBOutlet UILabel  *barberNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *claimReservationButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end
