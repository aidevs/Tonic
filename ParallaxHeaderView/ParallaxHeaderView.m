//
//  ParallaxHeaderView.m
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import <QuartzCore/QuartzCore.h>

#import "ParallaxHeaderView.h"
#import "UIImage+ImageEffects.h"


@interface ParallaxHeaderView ()
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *bluredImageView;
@end

//#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define kDefaultHeaderFrame CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.5f;
static CGFloat kMaxTitleAlphaOffset = 100.0f;
static CGFloat kLabelPaddingDist = 8.0f;

@implementation ParallaxHeaderView

//- (id) init {
//    self = [super init];
//    if (self != nil)
//    {
//        NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"ParallaxHeaderView" owner:self options:nil];
//        UIView *nv = [theView objectAtIndex:0];
//        
////        .. rest of code.
//        
//        [self addSubview:nv];
//    }
//    return self;
//}

+ (id)parallaxHeaderViewWithImage:(UIImage *)image forSize:(CGSize)headerSize;
{
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    headerView.headerImage = image;
    [headerView initialSetup];
    return headerView;
}

+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize;
{
//    NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"ParallaxHeaderView" owner:self options:nil];
//    UIView *nv = [theView objectAtIndex:0];
//    
//    
//    return nv;

    NSLog(@"frame:%@",NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
    NSLog(@"widnth:%f",[UIScreen mainScreen].applicationFrame.size.width);
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width;
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, headerSize.height)];
    NSLog(@"frame:%@",NSStringFromCGRect(headerView.frame));

    [headerView initialSetup];
    return headerView;
}

- (void)awakeFromNib
{
    [self initialSetup];
    [self refreshBlurViewForNewImage];
}


- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    CGRect frame = self.imageScrollView.frame;
    
//    if (offset.y > 0)
//    {
        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        self.imageScrollView.frame = frame;
//        self.viewFadeEffect.alpha =   1 / kDefaultHeaderFrame.size.height * offset.y * 2;
        self.clipsToBounds = YES;
//    }
//    else
//    {
//        CGFloat delta = 0.0f;
//        CGRect rect = kDefaultHeaderFrame;
//        delta = fabs(MIN(0.0f, offset.y));
//        rect.origin.y -= delta;
//        rect.size.height += delta;
////        self.imageScrollView.frame = rect;
//        self.clipsToBounds = NO;
////        self.headerTitleLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
//    }
}

#pragma mark -
#pragma mark Private

- (void)initialSetup
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, SCREEN_HEIGHT-300)];
    self.imageScrollView = scrollView;

    
    NSArray *theView =  [[NSBundle mainBundle] loadNibNamed:@"ParallaxHeaderView" owner:self options:nil];
    UIView *nv = [theView objectAtIndex:0];
    nv.frame = self.imageScrollView.frame;
    [self.imageScrollView addSubview:nv];

    CGRect labelRect = self.imageScrollView.frame;
    labelRect.origin.x = labelRect.origin.y = kLabelPaddingDist;
    labelRect.size.width = labelRect.size.width - 2 * kLabelPaddingDist;
    labelRect.size.height = labelRect.size.height - 2 * kLabelPaddingDist;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelRect];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.numberOfLines = 0;
    headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    headerLabel.autoresizingMask = _imageView.autoresizingMask;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:23];
    self.headerTitleLabel = headerLabel;
//    [self.imageScrollView addSubview:self.headerTitleLabel];
    
    self.bluredImageView = [[UIImageView alloc] initWithFrame:self.imageView.frame];
    self.bluredImageView.autoresizingMask = self.imageView.autoresizingMask;
    self.bluredImageView.alpha = 0.0f;
    
   // self.imgVBG.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self.imageScrollView addSubview:self.bluredImageView];
    
    [self addSubview:self.imageScrollView];
    
    [self refreshBlurViewForNewImage];
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    self.imageView.image = headerImage;
    [self refreshBlurViewForNewImage];
}

- (UIImage *)screenShotOfView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(kDefaultHeaderFrame.size, YES, 0.0);
    [self drawViewHierarchyInRect:kDefaultHeaderFrame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)refreshBlurViewForNewImage
{
    UIImage *screenShot = [self screenShotOfView:self];
    screenShot = [screenShot applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1.0 maskImage:nil];
    self.bluredImageView.image = screenShot;
}
@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
