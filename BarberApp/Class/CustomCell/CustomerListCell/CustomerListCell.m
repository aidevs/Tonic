//
//  CustomerListCell.m
//  BarberApp
//
//  Created by Manan on 8/23/17.
//  Copyright © 2017 Deepesh. All rights reserved.
//

#import "CustomerListCell.h"

@implementation CustomerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.barberImage1.layer.cornerRadius = self.barberImage1.frame.size.height/2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
