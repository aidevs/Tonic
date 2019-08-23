 //
//  UITextField+AdditionsPedding.m
//  SocialNightApp
//
//  Created by Chandan Kumar on 05/11/14.
//  Copyright (c) 2014 Deepesh. All rights reserved.
//

#import "UITextField+AdditionsPedding.h"

@implementation UITextField (AdditionsPedding)

-(void) setLeftPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
