//
//  Cell.h
//  BarberPopupDemo
//
//  Created by Rajneesh on 10/03/16.
//  Copyright © 2016 Konstant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_User;
@property (weak, nonatomic) IBOutlet UIImageView *img_Selected;
@property (weak, nonatomic) IBOutlet UILabel *lbl_UserName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SelectedUserCount;

@end
