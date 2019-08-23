//
//  HomeTableViewCell.m
//  BarberApp
//
//  Created by Pankaj Asudani on 08/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

@synthesize labelCount,labelCustomerName,labelTime,fingerImageView;
@synthesize barberImage1,barberImage2,barberImage3,barberImage4,barberImage5;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
