//
//  PopUpView.h
//  BarberPopupDemo
//
//  Created by Rajneesh on 10/03/16.
//  Copyright © 2016 Konstant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"

@protocol PopUpViewDelegate <NSObject>

@optional
- (void)popUpCloseDelegate;
@end

@interface PopUpView : UIView <UIAlertViewDelegate>
{
    NSMutableArray *selectedIndexAry;
    BOOL isNextAvailableSelected;
    __weak IBOutlet UIButton *buttonSubmit;
    BOOL enableSubmitButton;
    
    
}
@property (weak, nonatomic) IBOutlet UIView *confimPopView;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;

@property(nonatomic, strong) HTTPService  *httpServiceObject;
@property (nonatomic, strong) NSMutableArray *listAry;
@property (nonatomic) NSArray *barbersAry;

@property (weak, nonatomic) IBOutlet UIButton *btnNextAvailable;
@property (weak, nonatomic) IBOutlet UIImageView *bg_White;
@property (nonatomic) BOOL isCheckIn;
@property (nonatomic) BOOL isEditingMode;
@property (nonatomic) NSDictionary *customerDict;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *popupBgView;
@property (weak, nonatomic) IBOutlet UIButton *btn_Submit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionBottomConstraint;

@property id <PopUpViewDelegate> delegate;

@property(nonatomic,copy) void  (^selectedProfile)(NSDictionary *select);
@property(nonatomic,copy) void  (^unHideView)();
-(id)initWithFrame:(CGRect)frame withCheckIn:(BOOL)check;

@end
