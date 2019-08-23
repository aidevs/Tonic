//
//  ParallaxHeaderView.h
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <UIKit/UIKit.h>

@interface ParallaxHeaderView : UIView
@property (nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (nonatomic) UIImage *headerImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgVprofilePic;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

+ (id)parallaxHeaderViewWithImage:(UIImage *)image forSize:(CGSize)headerSize;
+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;
@property (strong, nonatomic) IBOutlet UIButton *btnEditProfile;

@property (strong, nonatomic) IBOutlet UIImageView *imgVProfileBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgVProfile;
@property (weak, nonatomic) IBOutlet UIScrollView *headrScrollView;
@property (weak, nonatomic) IBOutlet UILabel *userLbl;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLbl;

@property (weak, nonatomic) IBOutlet UIImageView *userBgImage;

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
