//
//  PopUpView.m
//  BarberPopupDemo
//
//  Created by Rajneesh on 10/03/16.
//  Copyright © 2016 Konstant. All rights reserved.
//

#import "PopUpView.h"
#import "HomeVC.h"
@implementation PopUpView
{
    
}
-(id)initWithFrame:(CGRect)frame withCheckIn:(BOOL)check{
    self = [super initWithFrame:frame];
    
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PopUpView" owner:self options:nil]objectAtIndex:0];
        self.frame = frame;
    }
    
    
    self.multipleTouchEnabled = YES;
    [APPDELEGATE.walkInTimer invalidate];
    APPDELEGATE.walkInTimer = nil;
    APPDELEGATE.walkInTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:APPDELEGATE selector:@selector(timeOutAction1) userInfo:nil repeats:NO];
    _isCheckIn = check;
    self.popupBgView.backgroundColor = [UIColor clearColor];
    self.bg_White.layer.cornerRadius = 8.0;
    self.bg_White.layer.masksToBounds = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.allowsMultipleSelection = YES;
    
    [self setTitleShadow:self.btn_Submit];
    [self setTitleShadow:self.btnNextAvailable];
    
    [self setCornerRadious:self.btn_Submit];
    [self setCornerRadious:self.btnNextAvailable];
    
    [_txtUserName setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginButton"]]];
    
    [_txtUserName becomeFirstResponder];
    NSLog(@"Selected Customer:%@",_customerDict);

    if(!_isCheckIn)
    {
        _topConstraint.constant = 10;
        _collectionBottomConstraint.constant=-35;
        [_btn_Submit setHidden:YES];
        [_btnNextAvailable setHidden:YES];
        
    }
    else
    {
         _topConstraint.constant = 75;
        _collectionBottomConstraint.constant=-93;
        [_btn_Submit setHidden:NO];
        [_btnNextAvailable setHidden:NO];
        [_txtUserName setHidden:NO];
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"nameString"];
        
        _txtUserName.text = savedValue;
    }
    
    _httpServiceObject = [[HTTPService alloc] init];
    NSString *baseURLString = BASE_URL;
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLSessionConfiguration *urlSession = [NSURLSessionConfiguration defaultSessionConfiguration];
    _httpServiceObject = [[HTTPService alloc] initWithBaseURL:baseURL andSessionConfig:urlSession];

    if ([CommonFunctions connectedToNetwork]) {
        [CommonFunctions showActivityIndicatorWithText:@"Loading.." detailedText:@"Keep Patience!"];
        [self callApi:!_isCheckIn?@"customers":@"barbers" withParams:nil];
    }
    else
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    
    return self;
}


-(void)singleTap{
    
    APPDELEGATE.currentVC = @"";
    [APPDELEGATE.walkInTimer invalidate];
     APPDELEGATE.walkInTimer = nil;
    [self removeFromSuperview];
       
    if(_unHideView)
        _unHideView();
    
    //Notify Home to refresh Walkins
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_WALKINS object:nil];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _listAry.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = (Cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
   
    cell.img_User.layer.cornerRadius = cell.img_User.frame.size.width/2;
    [cell.img_User.layer setMasksToBounds:YES];
    cell.img_User.clipsToBounds = YES;
 
    
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2,3);
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shadowRadius = 2.0;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.img_User.bounds cornerRadius:100.0].CGPath;
    cell.img_Selected.image = [UIImage imageNamed:@"round_icon_ipad"];
    NSLog(@"%@",selectedIndexAry);
    
    
    if ([selectedIndexAry containsObject:indexPath]) {
        cell.img_Selected.hidden = NO;
        cell.lbl_SelectedUserCount.hidden = NO;
        buttonSubmit.enabled = YES;
        buttonSubmit.userInteractionEnabled = YES;
    }
    else {
        cell.img_Selected.hidden = YES;
        cell.lbl_SelectedUserCount.hidden = YES;
        buttonSubmit.enabled = NO;
        buttonSubmit.userInteractionEnabled = NO;
    }
    NSLog(@"Row = %d",(int)indexPath.row);
    NSLog(@"List.count = %ld",_listAry.count);
    if (indexPath.row == (_listAry.count )) {
        
        
        if (isNextAvailableSelected) {
           
            if (_isEditingMode == YES) {
                for (int i = 0; i < _listAry.count; i++) {
                    
                    Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                    cell.img_User.layer.borderColor = [UIColor clearColor].CGColor;
                    
                    [selectedIndexAry removeAllObjects];
                    cell.img_Selected.hidden = YES;
                    cell.lbl_SelectedUserCount.hidden = YES;
                    cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)_listAry.count+1];
                    
                }
            }
            
            cell.img_Selected.hidden = NO;
            cell.lbl_SelectedUserCount.hidden = YES;
            buttonSubmit.enabled = YES;
            buttonSubmit.userInteractionEnabled = YES;
        } else {
            cell.img_Selected.hidden = YES;
            cell.lbl_SelectedUserCount.hidden = YES;
            buttonSubmit.enabled = NO;
            buttonSubmit.userInteractionEnabled = NO;
        }
        cell.img_Selected.image = [UIImage imageNamed:@"ring"];
        [cell.img_User setImage:[UIImage imageNamed:@"noImage"]];
        [cell.lbl_UserName setText:@"Next Available"];
        
    } else {
        if (_isEditingMode) {
            
            for (NSDictionary *barberDict in _barbersAry) {
                
                if ([[barberDict objectForKey:@"id"] intValue] == [[[[_listAry objectAtIndex:indexPath.row] objectForKey:@"User"]objectForKey:@"id"] intValue]) {
                    
                    if (!selectedIndexAry) {
                        selectedIndexAry = [[NSMutableArray alloc]init];
                    }
                    
                    [selectedIndexAry addObject:indexPath];
                    cell.img_Selected.hidden = NO;
                    
                    buttonSubmit.enabled = YES;
                    buttonSubmit.userInteractionEnabled = YES;
                    
                    cell.lbl_SelectedUserCount.hidden = NO;
                    cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)selectedIndexAry.count];
                    
                    if(!_isCheckIn)
                        if(_selectedProfile)
                            _selectedProfile([_listAry objectAtIndex:indexPath.row]);
                    
                    [self setNextAvailableBtnState];
                    
                    break;
                }
            }
        }
        
        
        
        [cell.img_User setImageWithURL:[NSURL URLWithString:[[[_listAry objectAtIndex:indexPath.row] objectForKey:@"User"] objectForKey:@"image"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [cell.lbl_UserName setText:[[[_listAry objectAtIndex:indexPath.row] objectForKey:@"User"] objectForKey:@"name"]];
    }
    
    if (selectedIndexAry.count > 0) {
        buttonSubmit.enabled = YES;
        buttonSubmit.userInteractionEnabled = YES;
    }
        
    

   
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!selectedIndexAry) {
        selectedIndexAry = [[NSMutableArray alloc]init];
    }
    
    if (indexPath.row == _listAry.count) {
        for (int i = 0; i < _listAry.count; i++) {
            
            Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.img_User.layer.borderColor = [UIColor clearColor].CGColor;
            
               [selectedIndexAry removeAllObjects];
                cell.img_Selected.hidden = YES;
                cell.lbl_SelectedUserCount.hidden = YES;
                cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)_listAry.count+1];
            
        }
        
        if (isNextAvailableSelected == NO) {
            buttonSubmit.enabled = YES;
            buttonSubmit.userInteractionEnabled = YES;
            isNextAvailableSelected = YES;
            Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.img_Selected.hidden = NO;
            cell.lbl_SelectedUserCount.hidden = YES;
            cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)_listAry.count+1];
            [collectionView reloadData];
            
            //        [self nxtAvailableBtnAction:nil];
        } else {
            buttonSubmit.enabled = NO;
            buttonSubmit.userInteractionEnabled = NO;
            isNextAvailableSelected = NO;
            Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.img_Selected.hidden = NO;
            cell.lbl_SelectedUserCount.hidden = YES;
            cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)_listAry.count+1];
            [collectionView reloadData];
//            [collectionView performBatchUpdates:^{
//                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
//            } completion:nil];
            //        [self nxtAvailableBtnAction:nil];
        }
       
        
    } else {
        // if(_isCheckIn)
        {
            
            isNextAvailableSelected = NO;
            Cell *cellNextAvailable = (Cell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_listAry.count inSection:0]];
            cellNextAvailable.img_Selected.hidden = YES;
            cellNextAvailable.lbl_SelectedUserCount.hidden = YES;
            cellNextAvailable.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)_listAry.count+1];
            
            Cell *cell = (Cell *) [collectionView cellForItemAtIndexPath:indexPath];
            
            
            
            int maxLimit = _isCheckIn ? 5 : 1;
            
            if (selectedIndexAry.count< maxLimit)
            {
                if ([selectedIndexAry containsObject:indexPath]) {
                    
                    cell.img_User.layer.borderColor = [UIColor clearColor].CGColor;
                    
                    if ([selectedIndexAry containsObject:indexPath]) {
                        [selectedIndexAry removeObject:indexPath];
                        cell.img_Selected.hidden = YES;
                        [self refresh];
                        
                        cell.lbl_SelectedUserCount.hidden = YES;
                        cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)selectedIndexAry.count];
                    }
                }
                else
                {
                    if (indexPath.row == _listAry.count) {
                        
                    }
                    [selectedIndexAry addObject:indexPath];
                    cell.img_Selected.hidden = NO;
                    
                    cell.lbl_SelectedUserCount.hidden = NO;
                    cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)selectedIndexAry.count];
                    
                    if(!_isCheckIn)
                        if(_selectedProfile)
                            _selectedProfile([_listAry objectAtIndex:indexPath.row]);
                }
                
            } else
            {
                if(_isCheckIn){
                    
                    if ([selectedIndexAry containsObject:indexPath] && _isEditingMode) {
                        
                        cell.img_User.layer.borderColor = [UIColor clearColor].CGColor;
                        
                        if ([selectedIndexAry containsObject:indexPath]) {
                            [selectedIndexAry removeObject:indexPath];
                            cell.img_Selected.hidden = YES;
                            [self refresh];
                            
                            cell.lbl_SelectedUserCount.hidden = YES;
                            cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)selectedIndexAry.count];
                        }
                    }
                    else
                    {
                        [CommonFunctions alertTitle:@"Tonic" withMessage:@"You can select upto 5."];
                    }
                }
                else
                    [CommonFunctions alertTitle:@"Tonic" withMessage:@"You can select upto 1."];
                
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
                return;
            }
            
            [self setNextAvailableBtnState];
            
        }
    }
    if (selectedIndexAry.count >0) {
        buttonSubmit.enabled = YES;
        buttonSubmit.userInteractionEnabled = YES;
    } else {
        buttonSubmit.enabled = NO;
        buttonSubmit.userInteractionEnabled = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // if(_isCheckIn)
    
    if (indexPath.row == _listAry.count) {
        for (int i = 0; i < _listAry.count; i++) {
            
            Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.img_User.layer.borderColor = [UIColor clearColor].CGColor;
            
            [selectedIndexAry removeAllObjects];
            cell.img_Selected.hidden = YES;
            cell.lbl_SelectedUserCount.hidden = YES;
            cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)selectedIndexAry.count];
            //[collectionView reloadData];
        }
        isNextAvailableSelected = NO;
        Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.img_Selected.hidden = YES;
        cell.lbl_SelectedUserCount.hidden = YES;
        cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)_listAry.count+1];
       // [collectionView reloadData];
        [collectionView performBatchUpdates:^{
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
        
        
    }  else {
        
        isNextAvailableSelected = NO;
        Cell *cellNextAvailable = (Cell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_listAry.count inSection:0]];
        cellNextAvailable.img_Selected.hidden = YES;
        cellNextAvailable.lbl_SelectedUserCount.hidden = YES;
        cellNextAvailable.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)_listAry.count+1];
        
            Cell *cell = (Cell *) [collectionView cellForItemAtIndexPath:indexPath];
            
            cell.img_User.layer.borderColor = [UIColor clearColor].CGColor;
            
            if ([selectedIndexAry containsObject:indexPath]) {
                [selectedIndexAry removeObject:indexPath];
                cell.img_Selected.hidden = YES;
                [self refresh];
                
                cell.lbl_SelectedUserCount.hidden = YES;
                cell.lbl_SelectedUserCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)selectedIndexAry.count];
            }
        if (selectedIndexAry.count >0) {
            buttonSubmit.enabled = YES;
            buttonSubmit.userInteractionEnabled = YES;
        } else {
            buttonSubmit.enabled = NO;
            buttonSubmit.userInteractionEnabled = NO;
        }
            [self setNextAvailableBtnState];
        }
        
    
        
    
    
   // [_collectionView reloadData];
}
-(void)refresh
{
       for(int i = 0 ; i < selectedIndexAry.count ; i++)
    {
         Cell *cell = (Cell *) [_collectionView cellForItemAtIndexPath:[selectedIndexAry objectAtIndex:i]];
        
        NSLog(@"count Btn is %@",[NSString stringWithFormat:@"%d",i+1]);
        cell.lbl_SelectedUserCount.text =  [NSString stringWithFormat:@"%d",i+1];
        [cell.lbl_SelectedUserCount setHidden:NO];
    }
     NSLog(@"count selectedIndexAry is %@",selectedIndexAry);
    
//NSLog(@"_valueSelectionArr %@",_valueSelectionArr);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(87, 105);
}
#pragma mark Collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    return UIEdgeInsetsMake(0, 40, 0, 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 15.0;
}
-(void)setNextAvailableBtnState {
    if (selectedIndexAry.count>0)
        self.btnNextAvailable.enabled = NO;
    else
        self.btnNextAvailable.enabled = YES;
}
-(void)setTitleShadow :(UIButton *)aView {
    [aView setTitleShadowColor:[UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3] forState:UIControlStateNormal];
    aView.titleLabel.shadowOffset = CGSizeMake(1,2);
}
-(void)setCornerRadious :(UIButton *)aView {
    aView.layer.cornerRadius = 6.0;
    [aView.layer setMasksToBounds:YES];
    aView.clipsToBounds = YES;
}

- (IBAction)closePopUpView:(id)sender
{

   
//    if(_isCheckIn)
//    {
        CGPoint centerOffScreen = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, -[[UIScreen mainScreen]bounds].size.width);
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                self.center = centerOffScreen;
            }];
        } completion:^(BOOL finished) {
            [APPDELEGATE.walkInTimer invalidate];
            APPDELEGATE.walkInTimer = nil;
            [self.delegate popUpCloseDelegate];
            
        }];
    //}
//    else
//        [_chkiUserNameTxT resignFirstResponder];
   
}

- (IBAction)submitBtnAction:(id)sender {
    
    
    if (isNextAvailableSelected) {
        [self nxtAvailableBtnAction:nil];
    } else {
        
    [self endEditing:TRUE];
    
    if (selectedIndexAry.count > 0) {
        
        if ([CommonFunctions connectedToNetwork]) {
            
            [CommonFunctions showActivityIndicatorWithText:@"Check-In.." detailedText:@"Please Wait!"];
            [self callCheckInApi];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    }
    else
        
        if ([_txtUserName.text length] > 0) {
            
            if ([CommonFunctions connectedToNetwork]) {
                [CommonFunctions showActivityIndicatorWithText:@"Submitting.." detailedText:@"Please Wait!"];
                
                NSMutableDictionary *checkinDic=[[NSMutableDictionary alloc]init];
                [checkinDic setObject:_txtUserName.text forKey:@"name"];
                [checkinDic setObject:@"1" forKey:@"next_available"];
                
                NSString *strApiName = @"check_in";
                
                if (_isEditingMode) {
                    
                    NSString *strCustID = [NSString stringWithFormat:@"%d",[[[_customerDict objectForKey:@"Customer"] objectForKey:@"id"] intValue]];
                    
                    NSString *lastTimeStamp = [NSString stringWithFormat:@"%.0f",[[[_customerDict objectForKey:@"Customer"] objectForKey:@"updated"] doubleValue]];
                    
                    [checkinDic setObject:strCustID forKey:@"id"];
                    [checkinDic setObject:lastTimeStamp forKey:@"checkin_date"];
                    strApiName = @"check_in_edit";
                }
                
                [self callApi:strApiName withParams:checkinDic];
            }
            else
                [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:@"Please enter name."];
    
    
    }     //[CommonFunctions alertTitle:@"Tonic" withMessage:@"Please select user."];
    
}

-(void) callCheckInApi{

   
        NSMutableString *large_CSV_String = [[NSMutableString alloc] init];
        
        int i = 0;
        
        for(NSIndexPath *indexpath in selectedIndexAry)
        {
            if (i == selectedIndexAry.count-1)
                [large_CSV_String appendFormat:@"%@",[[[_listAry objectAtIndex:indexpath.row] objectForKey:@"User"]objectForKey:@"id"]];
            else
                [large_CSV_String appendFormat:@"%@,",[[[_listAry objectAtIndex:indexpath.row] objectForKey:@"User"]objectForKey:@"id"]];
            i+=1;
        }
        
        if ([CommonFunctions connectedToNetwork]) {
            
            [CommonFunctions showActivityIndicatorWithText:@"Submitting.." detailedText:@"Please Wait!"];
            NSArray *barber = [large_CSV_String componentsSeparatedByString:@","];
            NSMutableDictionary *checkinDic=[[NSMutableDictionary alloc]init];
            [checkinDic setObject:barber forKey:@"barbers"];
            [checkinDic setObject:_txtUserName.text forKey:@"name"];
            [checkinDic setObject:@"0" forKey:@"next_available"];
            
            NSString *strApiName = @"check_in";
            
            if (_isEditingMode) {
                
                NSString *strCustID = [NSString stringWithFormat:@"%d",[[[_customerDict objectForKey:@"Customer"] objectForKey:@"id"] intValue]];
                double lastTimeStamp = [[[_customerDict objectForKey:@"Customer"] objectForKey:@"updated"] doubleValue];
                
                NSString *timeStampStr = [NSString stringWithFormat:@"%.0f",lastTimeStamp];
                
                NSLog(@"lastTimeStamp:%@",timeStampStr);
                
                [checkinDic setObject:strCustID forKey:@"id"];
                [checkinDic setObject:timeStampStr forKey:@"checkin_date"];
                strApiName = @"check_in_edit";
            }
            
            [self callApi:strApiName withParams:checkinDic];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    
   
}

- (IBAction)nxtAvailableBtnAction:(id)sender {
    
    [self endEditing:TRUE];
    
    if ([_txtUserName.text length] > 0) {
        
        if ([CommonFunctions connectedToNetwork]) {
            [CommonFunctions showActivityIndicatorWithText:@"Submitting.." detailedText:@"Please Wait!"];
            
            NSMutableDictionary *checkinDic=[[NSMutableDictionary alloc]init];
            [checkinDic setObject:_txtUserName.text forKey:@"name"];
            [checkinDic setObject:@"1" forKey:@"next_available"];
            
            NSString *strApiName = @"check_in";
            
            if (_isEditingMode) {
                
                NSString *strCustID = [NSString stringWithFormat:@"%d",[[[_customerDict objectForKey:@"Customer"] objectForKey:@"id"] intValue]];
                
                NSString *lastTimeStamp = [NSString stringWithFormat:@"%.0f",[[[_customerDict objectForKey:@"Customer"] objectForKey:@"updated"] doubleValue]];
                
                [checkinDic setObject:strCustID forKey:@"id"];
                [checkinDic setObject:lastTimeStamp forKey:@"checkin_date"];
                strApiName = @"check_in_edit";
            }
            
            [self callApi:strApiName withParams:checkinDic];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    }
    else
        [CommonFunctions alertTitle:@"Tonic" withMessage:@"Please enter name."];
    
}

#pragma mark - Webservice Method

-(void) callApi:(NSString *) _apiName withParams:(NSMutableDictionary*)params{
    
    /**
     *Pass token in Header
     *{"token":"7647fb1c906e09434ba7a09476d49f52"}
     */
    
    NSDictionary *userInfoDictionary = (NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    
    [headers setObject:[[userInfoDictionary objectForKey:@"data"] objectForKey:@"token"] forKey:@"token"];
    
    NSLog(@"Walkin Request:%@",params);
    
    [_httpServiceObject startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:_apiName withParameters:params withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"response - %@",responseObject);
        
        NSError* error;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                           options:kNilOptions
                                                                             error:&error];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        
        NSLog(@"Home response - %@",responseDictionary);
        [CommonFunctions removeActivityIndicator];
        
        if (statusCode == 200)
        {
            if([_apiName isEqualToString:@"customers"])
            {
                _listAry = [NSMutableArray arrayWithArray:[[responseDictionary objectForKey:@"data"] objectForKey:@"customers"]];
                
                [_collectionView reloadData];
            }
             else  if([_apiName isEqualToString:@"barbers"])
             {
                 _listAry = [NSMutableArray arrayWithArray:[[responseDictionary objectForKey:@"data"] objectForKey:@"barbers"]];
                 NSLog(@"Customer Dictionary sel:%@",_customerDict);
                 _barbersAry = [_customerDict objectForKey:@"Barber"];
                 
                 [_collectionView reloadData];
             }
            else if ([_apiName isEqualToString:@"check_in"] || [_apiName isEqualToString:@"check_in_edit"])
            {
                NSLog(@"check_in ...%@",[[responseDictionary objectForKey:@"data"] objectForKey:@"barbers"]);
                {
                    
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
                    singleTap.numberOfTapsRequired = 1;
                    
                    [self.confimPopView addGestureRecognizer:singleTap];
                    
                    [_txtUserName setHidden:YES];
                    [_btnNextAvailable setHidden:YES];
                    [_btn_Submit setHidden:YES];
                    [_popupBgView setHidden:YES];
                    [_collectionView setHidden:YES];
                    [_confimPopView setHidden:NO];
                    
                    [self performSelector:@selector(singleTap) withObject:nil afterDelay:2.0];
                   
                    [_confimPopView setFrame:CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    
                    [_confimPopView setBackgroundColor:[UIColor colorWithRed:72.0f/255.0f green:72.0f/255.0f blue:72.0f/255.0f alpha:0.80]];
                    [UIView animateWithDuration:0.2
                                          delay:0.2
                                        options: UIViewAnimationOptionCurveEaseIn
                                     animations:^{
                                         // bottomConstraintPopUpVw.constant = 0;
                                         _confimPopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                     }
                                     completion:^(BOOL finished){
                                         
                                     }];
                    
                }
            }
            else{
                //Success walkins
                
                // [self removeView:_popUpBgVw];
            }
            
        }
        else
        {
            int tag = 8;
            if([_apiName isEqualToString:@"customers"])
                tag = 11;
                
            [CommonFunctions alertTitle:@"Tonic" withMessage:[NSString stringWithFormat:@"%@",[[responseDictionary objectForKey:@"data"] objectForKey:@"msg"]] withDelegate:self withTag:tag];
        }
        
    } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error - %@",[error localizedDescription]);
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    APPDELEGATE.walkInTimer.invalidate;
    APPDELEGATE.walkInTimer = nil;
      APPDELEGATE.walkInTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:APPDELEGATE selector:@selector(timeOutAction1) userInfo:nil repeats:NO];
    
    return true;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    APPDELEGATE.walkInTimer.invalidate;
    APPDELEGATE.walkInTimer = nil;
      APPDELEGATE.walkInTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:APPDELEGATE selector:@selector(timeOutAction1) userInfo:nil repeats:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    APPDELEGATE.walkInTimer.invalidate;
    APPDELEGATE.walkInTimer = nil;
    APPDELEGATE.walkInTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:APPDELEGATE selector:@selector(timeOutAction1) userInfo:nil repeats:NO];
    return true;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    APPDELEGATE.walkInTimer.invalidate;
    APPDELEGATE.walkInTimer = nil;
     APPDELEGATE.walkInTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:APPDELEGATE selector:@selector(timeOutAction1) userInfo:nil repeats:NO];
    [textField resignFirstResponder];
    
    return YES;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11)
    {
         APPDELEGATE.currentVC = @"";
        [APPDELEGATE.walkInTimer invalidate];
        APPDELEGATE.walkInTimer = nil;
        [self removeFromSuperview];
        
        if(_unHideView)
            _unHideView();
    }
}


@end
