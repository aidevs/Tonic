//
//  CustomerListCell.h
//  BarberApp
//
//  Created by Manan on 8/23/17.
//  Copyright © 2017 Deepesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCustomerName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIImageView *barberImage1;
@end
