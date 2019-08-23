//
//  HomeTableViewCell.h
//  BarberApp
//
//  Created by Pankaj Asudani on 08/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *labelCount;

@property (strong, nonatomic) IBOutlet UILabel *labelCustomerName;

@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UIImageView *fingerImageView;

@property (strong, nonatomic) IBOutlet UIImageView *barberImage1;
@property (strong, nonatomic) IBOutlet UIImageView *barberImage2;
@property (strong, nonatomic) IBOutlet UIImageView *barberImage3;
@property (strong, nonatomic) IBOutlet UIImageView *barberImage4;
@property (strong, nonatomic) IBOutlet UIImageView *barberImage5;


@end
