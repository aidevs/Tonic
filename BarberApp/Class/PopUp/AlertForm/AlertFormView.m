//
//  AlertFormView.m
//  BarberApp
//
//  Created by Manan on 8/22/17.
//  Copyright © 2017 Deepesh. All rights reserved.
//

#import "AlertFormView.h"

@implementation AlertFormView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"AlertFormView" owner:self options:nil]objectAtIndex:0];
        self.frame = frame;
    }
    [self.nameLabel setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [self.mobileLabel setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailLabel setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
     return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
