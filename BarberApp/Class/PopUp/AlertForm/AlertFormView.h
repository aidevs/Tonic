//
//  AlertFormView.h
//  BarberApp
//
//  Created by Manan on 8/22/17.
//  Copyright © 2017 Deepesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertFormView : UIView

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@end
