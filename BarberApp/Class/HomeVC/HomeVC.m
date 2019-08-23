 //
//  HomeVC.m
//  BarberApp
//
//  Created by Pankaj Asudani on 04/03/16.
//  Copyright © 2016 Deepesh. All rights reserved.
//

#import "HomeVC.h"
#import "ParallaxHeaderView.h"
#import "HomeTableViewCell.h"
#import "AlertFormView.h"
#import "CustomerListVC.h"


@interface HomeVC ()<NSURLSessionDelegate>{

    NSMutableArray      *arrayMwalkins;
    NSMutableArray      *arrayMreservations;
    NSMutableSet        * _collapsedSections;
    NSDateFormatter     *dateformat;
    CGFloat             _headerImageYOffset;
    UIRefreshControl    *refreshControl;
    //Value on tableview tap
    NSDictionary        *selectedUserDictionary;
    PopUpView           *pView;
    AlertFormView *form;
    UITapGestureRecognizer *selfView;
    /*  isWalkin:
     *  0 - Walk-ins
     *  1 - Reservations
     */
    int isWalkin;
    IBOutlet    NSLayoutConstraint  *bottomConstraintPopUpVw;
}

@property (nonatomic, strong) ParallaxHeaderView *headerView;
//Middle transparent view
@property (nonatomic, weak) IBOutlet UIView         *midVw;

@property (nonatomic, strong)  IBOutlet UITableView           *tblView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *confrimCustmView;

//Popup transparent view
@property (nonatomic, weak) IBOutlet UIView         *popUpBgVw;
//Seat&Dismiss transparent view
@property (nonatomic, weak) IBOutlet UIView         *seatDismissVw;

//Pin transparent view
@property (nonatomic, weak) IBOutlet UIView         *pinVw;


//PIN Field
@property (weak, nonatomic) IBOutlet UITextField *pinTextField;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUpView)
                                                 name:@"FromCustomerList"
                                               object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWalkinsReservations) name:REFRESH_WALKINS object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeOutActionWalkIn) name:@"timeOutActionWalkIn" object:nil];
    
    [self setUpView];
}

-(void)timeOutActionWalkIn {
    
    
    [APPDELEGATE.walkInTimer invalidate];
    APPDELEGATE.walkInTimer = nil;
    APPDELEGATE.currentVC = @"";
    [self popUpCloseDelegate];
    
}

-(void)receiveNotification: (NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"FromCustomerList"]) {
        
        [self setUpView];
    }
}
-(void) setUpView{
    
    _midVw.layer.cornerRadius = 10.0f;
    _collapsedSections = [NSMutableSet new];
    
    [_pinView setHidden:YES];
    [_pinVw setHidden:YES];
    [_confirmationView setHidden:YES];
    
    [_popUpBgVw setHidden:YES];
    
    isRfreshing = NO;
    
    dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"hh:mm a"];
    
    bottomConstraintPopUpVw.constant = SCREEN_HEIGHT;
    
    //SetUp HTTP initially
    _httpServiceObject = [[HTTPService alloc] init];
    NSString *baseURLString = BASE_URL;
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURLSessionConfiguration *urlSession = [NSURLSessionConfiguration defaultSessionConfiguration];
    _httpServiceObject = [[HTTPService alloc] initWithBaseURL:baseURL andSessionConfig:urlSession];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapped)];
    tapView.numberOfTapsRequired = 1;
    [_popUpBgVw addGestureRecognizer:tapView];
    
//    UITapGestureRecognizer *selfView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTapped)];
//    tapView.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:selfView];
    
    
    [self addTableView];
    
    [_mainView bringSubviewToFront:_logoutButton];
    [_mainView bringSubviewToFront:_refreshButton];
    
    //Call Walkins API
    
    if ([CommonFunctions connectedToNetwork]) {
        
        [CommonFunctions showActivityIndicatorWithText:@"Loading.." detailedText:@"Keep Patience!"];
        [self callApi:@"reservation_walkins" withParams:nil];
    }
    else
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWalkinsReservations) name:REFRESH_WALKINS object:nil];
}

-(void)selfViewTapped {
    
    [form removeFromSuperview];
     [self.view removeGestureRecognizer:selfView];
    self.bgView.hidden = NO;
}
-(void) viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    [_scrolView setContentSize:CGSizeMake(SCREEN_WIDTH, 1506.0f)];
    
    CGRect frame = self.view.frame;
    frame.origin.y -= 50.0f;
    pView.frame = frame;
    form.frame = _bgView.frame;
}

-(void) bgViewTapped{
    
    [self removeView:_popUpBgVw];
     [self.view removeGestureRecognizer:selfView];
    [form removeFromSuperview];
}

-(void) addTableView{
  
    [_tblView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"HomeTableViewCell"];
    UINib *nibFile = [UINib nibWithNibName:@"HomeTableViewCell" bundle:[NSBundle mainBundle]];
    [_tblView registerNib:nibFile forCellReuseIdentifier:@"HomeTableViewCell"];
    
    [_tblView setHidden:YES];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [_tblView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    
    //Call Walkins API
    if ([CommonFunctions connectedToNetwork]) {
        [CommonFunctions showActivityIndicatorWithText:@"Refreshing.." detailedText:@"Please wait!"];
        [self callApi:@"reservation_walkins" withParams:nil];
    }
    else
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
}

#pragma mark- IBAction Methods

- (IBAction)reservationBtnAction:(id)sender
{
   
    
    
   /////////////////////////////////////////
    
    if ([sender tag] == 1) {
        APPDELEGATE.currentVC = @"WalkIn";
         self.bgView.hidden = YES;
        [self addPopup:sender];
       /* UIAlertController *alrtVw = [UIAlertController alertControllerWithTitle:@"Tonic" message:@"Are you first time user?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *noAlert = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alrtVw dismissViewControllerAnimated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nameString"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self addPopup:sender];
        }];
        
        UIAlertAction *yesAlert = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alrtVw dismissViewControllerAnimated:YES completion:nil];
            [self addFormPopup];
            
        }];
        
        [alrtVw addAction:noAlert];
        [alrtVw addAction:yesAlert];
        
        [self presentViewController:alrtVw animated:YES completion:nil];
        */
        
    } else {
        
        //[self addPopup:sender];
    APPDELEGATE.currentVC = @"Reservations";
        CustomerListVC *listVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerListVC"];
        //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:listVC];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    
    ////////////////////////////////////////
}
-(void)addFormPopup {
    
        selfView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTapped)];
        selfView.numberOfTapsRequired = 1;
        [self.view addGestureRecognizer:selfView];
    
    self.bgView.hidden = YES;
    [pView removeFromSuperview];
    form = [[AlertFormView alloc]initWithFrame:_bgView.frame];
    
    [self.view addSubview:form];
    [self.view layoutSubviews];
        [form.submitButton addTarget:self action:@selector(formSubmitAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)formSubmitAction {
    
    NSString *nameString = form.nameLabel.text;
    NSString *mobileString = form.mobileLabel.text;
    NSString *emailString = form.emailLabel.text;
    
    NSLog(@"%@", [NSString stringWithFormat:@"Name is = %@ \nMobile is = %@ \nEmail is =%@",nameString,mobileString,emailString]);
    if (![CommonFunctions isValueNotEmpty1:nameString]) {
        [CommonFunctions alertTitle:@"Tonic" withMessage:@"Please enter your name" withDelegate:self];
        return;
    }
    if (![CommonFunctions isValueNotEmpty1:mobileString]) {
        [CommonFunctions alertTitle:@"Tonic" withMessage:@"Please enter your mobile number" withDelegate:self];
        return;

    }
    if (![CommonFunctions isValueNotEmpty1:emailString]) {
        [CommonFunctions alertTitle:@"Tonic" withMessage:@"Please enter your email id" withDelegate:self];
        return;

    }
    if (![CommonFunctions isValidMobileNumber:mobileString]) {
        
        [CommonFunctions alertTitle:@"Tonic" withMessage:@"Mobile number is not valid" withDelegate:self];
        return;

    }
    if (![CommonFunctions isValidEmailId:emailString]) {
        
        [CommonFunctions alertTitle:@"Tonic" withMessage:@"Email ID is not valid" withDelegate:self];
        return;

    }
    [self.view removeGestureRecognizer:selfView];
    [form removeFromSuperview];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nameString forKey:@"nameString"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   [self addPopup:form];
}
-(void)addPopup :(id)sender {
    
    pView.hidden = YES;
    
    NSLog(@"%d",(int)[sender tag]);
    
    CGRect frame = self.view.frame;
    frame.origin.y -= 50.0f;
    pView = [[PopUpView alloc] initWithFrame:frame withCheckIn:[sender tag] == 1 ? YES : NO];
    pView.delegate = self;
    pView.isEditingMode = NO;
    UIColor *color = [UIColor whiteColor];
    
    
    pView.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"ENTER YOUR NAME" attributes:@{NSForegroundColorAttributeName: color}];

    if(!pView.isCheckIn)
    {
        [pView setSelectedProfile:^(NSDictionary * dict)
         {
             appId  = [dict[@"User"] objectForKey:@"appointment_id"];
             userId = [dict[@"User"] objectForKey:@"id"];
             
             [pView removeFromSuperview];
             
             [_barberNameLbl setText:[[dict valueForKey:@"User"]objectForKey:@"name"]];
             [_confirmationView setHidden:NO];
             [_mainView bringSubviewToFront:_confirmationView];
             [_mainView bringSubviewToFront:_logoutButton];
             [_mainView bringSubviewToFront:_refreshButton];
             [_confirmationView setFrame:CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
             
             [UIView animateWithDuration:0.2
                                   delay:0.2
                                 options: UIViewAnimationOptionCurveEaseIn
                              animations:^{
                                  // bottomConstraintPopUpVw.constant = 0;
                                  _confirmationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                              }
                              completion:^(BOOL finished){
                                  
                              }];
             
         }];
        
    }
    
    [pView setUnHideView:^
     {
         self.bgView.hidden = NO;
     }];
    
    
    if (![pView isDescendantOfView:self.view]) {
        
        pView.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:pView];
    }
    
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:7.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        pView.center = self.view.center;
    } completion:^(BOOL finished) {
    }];
}
- (void)popUpCloseDelegate {
    
    self.bgView.hidden = NO;
    [pView removeFromSuperview];
    [pView.txtUserName resignFirstResponder];
}

-(IBAction)refreshBtnPressed:(id)sender{
    
    [self refreshWalkinsReservations];
}

-(IBAction)logoutBtnPressed:(id)sender{

    UIAlertController *alrtVw = [UIAlertController alertControllerWithTitle:@"Tonic" message:@"Are you really want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAlert = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alrtVw dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *yesAlert = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([CommonFunctions connectedToNetwork]) {
            [CommonFunctions showActivityIndicatorWithText:@"Logging out.." detailedText:@"Please wait!"];
            [self callApi:@"logout" withParams:nil];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
        
        [alrtVw dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alrtVw addAction:noAlert];
    [alrtVw addAction:yesAlert];
    
    [self presentViewController:alrtVw animated:YES completion:nil];
}

-(IBAction)selectConfirmation:(UIButton *)sender
{
    int tag = (int)[sender tag];
    
    if(tag == 1)
    {
        [_confirmationView setHidden:YES];
          self.bgView.hidden = NO;
    }
    else
    {
        if ([CommonFunctions connectedToNetwork]) {
            
            [CommonFunctions showActivityIndicatorWithText:@"Claiming.." detailedText:@"Please wait!"];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:appId,@"appointment_id", userId, @"user_id" ,nil];
            [self callApi:@"claim_reservation" withParams:dict];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return [_collapsedSections containsObject:@(section)] ? 0 : [arrayMwalkins count];
    else
        return [_collapsedSections containsObject:@(section)] ? 0 : [arrayMreservations count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 65.0f)];
    
    /* UIView top rounded corners */
    
    CGRect bounds = view.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
    
    /* Add a Tap Gesture to UIView */
    
    UITapGestureRecognizer *singleTapView = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(sectionTouchUpInside:)];
    singleTapView.delegate = self;
    [view addGestureRecognizer:singleTapView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 30.0f, 30.0f)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"walkins"];
    
    if (section == 1)
        imgView.image = [UIImage imageNamed:@"calendar"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 62.0f, tableView.frame.size.width, 3.0f)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.hidden = false;
    if (section == 1) {
        lineView.hidden = true;
    }
    
    view.tag = section;
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55.0f, 0.0f, tableView.frame.size.width, 65.0f)];
    [label setFont:[UIFont fontWithName:FONT_BebasNeue_Bold size:21.0f]];
    [label setTextColor:[UIColor whiteColor]];
    NSString *labelTextString =@"Barber Use Only";
    
    if (section == 1)
        labelTextString = @"Barber Use Only";
    
    [label setText:labelTextString];
    [label setBackgroundColor:[UIColor clearColor]];
    
    [view addSubview:imgView];
    [view addSubview:lineView];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:0.70f]];
    
    return view;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"HomeTableViewCell";
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    [cell setBackgroundColor:[UIColor colorWithRed:72.0f/255.0f green:72.0f/255.0f blue:72.0f/255.0f alpha:0.70f]];
    cell.labelCustomerName.textColor = [UIColor whiteColor];
    cell.labelTime.textColor = [UIColor whiteColor];
    cell.fingerImageView.hidden = TRUE;
    
    if (indexPath.section == 0) {
        
        if (arrayMwalkins.count > 0) {
            
            NSDictionary *walkinsDictionary = (NSDictionary *) [arrayMwalkins objectAtIndex:indexPath.row];
            
            if ([self isNotNull:walkinsDictionary]) {
                
                if ([self isNotNull:[walkinsDictionary objectForKey:@"Customer"]]) {
                    
                    if ([self isNotNull:[[walkinsDictionary objectForKey:@"Customer"] objectForKey:@"name"]])
                        cell.labelCustomerName.text = [[walkinsDictionary objectForKey:@"Customer"] objectForKey:@"name"];
                    else
                        cell.labelCustomerName.text = @"";
  //                 -------------- Original--------
                    
                    if ([self isNotNull:[[walkinsDictionary objectForKey:@"Customer"] objectForKey:@"updated"]]){
                        
                        double timestamp = [[[walkinsDictionary objectForKey:@"Customer"] objectForKey:@"updated"] doubleValue];
                        
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                        cell.labelTime.text = [NSString stringWithFormat:@"@ %@",[dateformat stringFromDate:date]];
                    }

//                    if ([self isNotNull:[[walkinsDictionary objectForKey:@"Customer"] objectForKey:@"created"]]){
//                        
//                        double timestamp = [[[walkinsDictionary objectForKey:@"Customer"] objectForKey:@"created"] doubleValue];
//                        
//                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
//                        cell.labelTime.text = [NSString stringWithFormat:@"@ %@",[dateformat stringFromDate:date]];
//                    }
                    else
                        cell.labelTime.text = @"";
                    
                    cell.labelCount.text = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
                    
                    if ([self isNotNull:[walkinsDictionary objectForKey:@"Barber"]]) {
                        
                        NSArray *barberImagesArray = (NSArray*)[walkinsDictionary objectForKey:@"Barber"];
                        
                        cell.barberImage1.hidden = TRUE;
                        cell.barberImage2.hidden = TRUE;
                        cell.barberImage3.hidden = TRUE;
                        cell.barberImage4.hidden = TRUE;
                        cell.barberImage5.hidden = TRUE;
                        
                        int i=1;
                        for (NSDictionary *barberDictionary in barberImagesArray) {
                            
                            NSString *imageUrlString = @"";
                            
                            if ([self isNotNull:[barberDictionary objectForKey:@"image"]])
                                imageUrlString = [barberDictionary objectForKey:@"image"];
                            
                            switch (i) {
                                    
                                case 1:
                                    cell.barberImage1.layer.cornerRadius = 35.0f;
                                    cell.barberImage1.clipsToBounds = YES;
                                    cell.barberImage1.hidden = FALSE;
                                    [cell.barberImage1 setImageWithURL:[NSURL URLWithString:imageUrlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                                    break;
                                    
                                case 2:
                                    cell.barberImage2.layer.cornerRadius = 35.0f;
                                    cell.barberImage2.clipsToBounds = YES;
                                    cell.barberImage2.hidden = FALSE;
                                    [cell.barberImage2 setImageWithURL:[NSURL URLWithString:imageUrlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                                    break;
                                    
                                case 3:
                                    cell.barberImage3.layer.cornerRadius = 35.0f;
                                    cell.barberImage3.clipsToBounds = YES;
                                    cell.barberImage3.hidden = FALSE;
                                    [cell.barberImage3 setImageWithURL:[NSURL URLWithString:imageUrlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                                    break;
                                    
                                case 4:
                                    cell.barberImage4.layer.cornerRadius = 35.0f;
                                    cell.barberImage4.clipsToBounds = YES;
                                    cell.barberImage4.hidden = FALSE;
                                    [cell.barberImage4 setImageWithURL:[NSURL URLWithString:imageUrlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                                    break;
                                    
                                case 5:
                                    cell.barberImage5.layer.cornerRadius = 35.0f;
                                    cell.barberImage5.clipsToBounds = YES;
                                    cell.barberImage5.hidden = FALSE;
                                    [cell.barberImage5 setImageWithURL:[NSURL URLWithString:imageUrlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                                    break;
                                    
                                default:
                                    NSAssert(NO, @"Unhandled value in cellForRowAtIndexPath barber images");
                                    break;
                            }
                            
                            i+=1;
                        }
                        
                        if (barberImagesArray.count == 0) {
                            
                            cell.barberImage1.layer.cornerRadius = 35.0f;
                            cell.barberImage1.clipsToBounds = YES;
                            cell.barberImage1.hidden = FALSE;
                            [cell.barberImage1 setImage:[UIImage imageNamed:@"noImage"]];
                        }
                    }
                }
                
            }
        }
    }
    else if (indexPath.section == 1){
    
        if (arrayMreservations.count > 0) {
            
            NSDictionary *reservationsDictionary = (NSDictionary *) [arrayMreservations objectAtIndex:indexPath.row];
            
            if ([self isNotNull:reservationsDictionary]) {
                
                if ([self isNotNull:[[reservationsDictionary objectForKey:@"User"] objectForKey:@"name"]])
                    cell.labelCustomerName.text = [[reservationsDictionary objectForKey:@"User"] objectForKey:@"name"];
                else
                    cell.labelCustomerName.text = @"";
                
                if ([self isNotNull:[[reservationsDictionary objectForKey:@"Slot"] objectForKey:@"time"]]){

                    cell.labelTime.text = [NSString stringWithFormat:@"@ %@",[[reservationsDictionary objectForKey:@"Slot"] objectForKey:@"time"]];
                }
                else
                    cell.labelTime.text = @"";
                
                cell.labelCount.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
                
                if ([self isNotNull:[[reservationsDictionary objectForKey:@"Barber"] objectForKey:@"image"]]) {
                    
                    NSString *imageUrlString = [[reservationsDictionary objectForKey:@"Barber"] objectForKey:@"image"];
                    
                    cell.barberImage2.hidden = TRUE;
                    cell.barberImage3.hidden = TRUE;
                    cell.barberImage4.hidden = TRUE;
                    cell.barberImage5.hidden = TRUE;
                    
                    cell.barberImage1.layer.cornerRadius = 35.0f;
                    cell.barberImage1.clipsToBounds = YES;
                    [cell.barberImage1 setImageWithURL:[NSURL URLWithString:imageUrlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                    
                }
                
            }
        }
    }
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 65.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 95.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleNone) {
        
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"  Edit  " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         if (indexPath.section == 0) {
                                          
                                             NSLog(@"Array Obj :%@",[arrayMwalkins objectAtIndex:indexPath.row]);
                                             
                                             NSDictionary *dictObj = [arrayMwalkins objectAtIndex:indexPath.row];
                                             [self showWalkinEdit:dictObj];
                                         }
                                     }];
    button.backgroundColor = [UIColor colorWithRed:63.0f/255.0f green:201.0f/255.0f blue:97.0f/255.0f alpha:1.0f];
    
    return @[button];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    return @"  Edit  ";
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell != nil) {
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.labelCustomerName.textColor = [UIColor blackColor];
        cell.labelTime.textColor = [UIColor blackColor];
        cell.fingerImageView.hidden = FALSE;
    }
    
    [self animateViewFromTopToBottom:_popUpBgVw hideView:_pinVw showView:_seatDismissVw];
    
    if (indexPath.section == 0){
        isWalkin = 0;
        selectedUserDictionary = (NSDictionary*) [arrayMwalkins objectAtIndex:indexPath.row];
    }
    else{
        isWalkin = 1;
        selectedUserDictionary = (NSDictionary*) [arrayMreservations objectAtIndex:indexPath.row];
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell != nil) {
        
        cell.backgroundColor = [UIColor clearColor];
        cell.labelCustomerName.textColor = [UIColor whiteColor];
        cell.labelTime.textColor = [UIColor whiteColor];
        cell.fingerImageView.hidden = TRUE;
    }
}

#pragma mark- PopUp IBAction Methods

-(IBAction)seatAndDismissButtonPressed:(id)sender{

    UIButton *btn = (UIButton*)sender;
    
    if (btn.tag == 16) {
        APPDELEGATE.isSeatTapped = @"1";
    } else {
        APPDELEGATE.isSeatTapped = @"0";
    }
    [self animateViewFromTopToBottom:_popUpBgVw hideView:_seatDismissVw showView:_pinVw];
    [_pinTextField becomeFirstResponder];
}

#pragma mark - Webservice Method

-(void) callApi:(NSString *) _apiName withParams:(NSMutableDictionary*)params{
    
    /**
     *Pass token in Header
     *{"token":"7647fb1c906e09434ba7a09476d49f52"}
     */
    
    ////////////////////////////////////////////////////////////////////////
    
    NSDictionary *userInfoDictionary = (NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    
    [headers setObject:[[userInfoDictionary objectForKey:@"data"] objectForKey:@"token"] forKey:@"token"];
    
    [_httpServiceObject startRequestWithHttpMethod:kHttpMethodTypePost withHttpHeaders:headers withServiceName:_apiName withParameters:params withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError* error;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = [response statusCode];
        
        NSLog(@"Home response - %@",responseDictionary);
        _pinTextField.text = @"";
        
        [_tblView setHidden:NO];
        
        [CommonFunctions removeActivityIndicator];
        
        if(statusCode == 200)
        {
            isRfreshing = NO;
            
            if ([_apiName isEqualToString:@"reservation_walkins"]) {
                
                if ([[responseDictionary objectForKey:@"data"] objectForKey:@"walkins"]){
                  
                    NSArray *temp = [[responseDictionary objectForKey:@"data"] objectForKey:@"walkins"];
                    
            //        -------------- Original--------
                    NSArray *sortedArray = [temp  sortedArrayUsingComparator:
                                            ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2){
                                                return [[[obj1 objectForKey:@"Customer"] objectForKey:@"updated"] compare:[[obj2 objectForKey:@"Customer"] objectForKey:@"updated"]];
                                            }];

//                    NSArray *sortedArray = [temp  sortedArrayUsingComparator:
//                                            ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2){
//                                                return [[[obj1 objectForKey:@"Customer"] objectForKey:@"created"] compare:[[obj2 objectForKey:@"Customer"] objectForKey:@"created"]];
//                                            }];
                    arrayMwalkins = [NSMutableArray arrayWithArray:sortedArray];
                }
                
                if ([[responseDictionary objectForKey:@"data"] objectForKey:@"reservations"]){
                    
                    NSArray *temp1 = [[responseDictionary objectForKey:@"data"] objectForKey:@"reservations"];
                    NSArray *sortedReservationArray = [temp1  sortedArrayUsingComparator:
                                            ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2){
                                                return [[[obj1 objectForKey:@"Slot"] objectForKey:@"slot_unixtime"] compare:[[obj2 objectForKey:@"Slot"] objectForKey:@"slot_unixtime"]];
                                            }];
                    arrayMreservations = [NSMutableArray arrayWithArray:sortedReservationArray];
                }
                
                [self tableViewReload];
                
                [self tableViewTopMange];
            }
            else if([_apiName isEqualToString:@"customers"])
            {
                listAry = [NSMutableArray arrayWithArray:[[responseDictionary objectForKey:@"data"] objectForKey:@"customers"]];
            }
            else if([_apiName isEqualToString:@"logout"])
            {
//                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_EMAIL];
//                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_PASSWORD];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if([_apiName isEqualToString:@"claim_reservation"])
            {
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
                singleTap.numberOfTapsRequired = 1;
                
                [_confrimCustmView addGestureRecognizer:singleTap];
                
                [_mainView bringSubviewToFront:_confrimCustmView];
                [_confirmationView setHidden:YES];
                [_confrimCustmView setHidden:NO];
                
                [self performSelector:@selector(singleTap) withObject:nil afterDelay:2.0];
                [self.view sendSubviewToBack:_scrolView];
                [self.view bringSubviewToFront:_confrimCustmView];
                [_mainView bringSubviewToFront:_logoutButton];
                [_mainView bringSubviewToFront:_refreshButton];
                [_confrimCustmView setFrame:CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [_confrimCustmView setBackgroundColor:[UIColor colorWithRed:72.0f/255.0f green:72.0f/255.0f blue:72.0f/255.0f alpha:0.80]];
                [UIView animateWithDuration:0.2
                                      delay:0.2
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     _confrimCustmView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                 }
                                 completion:^(BOOL finished){
                                     
                                 }];
            }
            else if([_apiName isEqualToString:@"update_wakin_status"]){
                //Success update_wakin_status
                
                [self removeView:_popUpBgVw];
                
                //Call Walkins API
                if ([CommonFunctions connectedToNetwork]) {
                    isRfreshing = YES;
                    [_scrolView setContentOffset:CGPointMake(0.0f, 0.0f)];
                    [_mainView bringSubviewToFront:_bgView];
                    [_mainView bringSubviewToFront:_logoutButton];
                    [_mainView bringSubviewToFront:_refreshButton];
                    
                    [CommonFunctions showActivityIndicatorWithText:@"Loading.." detailedText:@"Keep Patience!"];
                    [self callApi:@"reservation_walkins" withParams:nil];
                }
                else
                    [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
            }//
            else if([_apiName isEqualToString:@"update_reservation_status"]){
                
                [self removeView:_popUpBgVw];
                if ([CommonFunctions connectedToNetwork]) {
                    isRfreshing = YES;
                    [_scrolView setContentOffset:CGPointMake(0.0f, 0.0f)];
                    [_mainView bringSubviewToFront:_bgView];
                    [_mainView bringSubviewToFront:_logoutButton];
                    [_mainView bringSubviewToFront:_refreshButton];
                    
                    [CommonFunctions showActivityIndicatorWithText:@"Loading.." detailedText:@"Keep Patience!"];
                    [self callApi:@"reservation_walkins" withParams:nil];
                }
                else
                    [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
            }
        }
        else
        {
            if ([[[responseDictionary objectForKey:@"data"] objectForKey:@"msg"] isEqualToString:@"No Data Found."]) {
                [arrayMwalkins removeAllObjects];
                [arrayMreservations removeAllObjects];
                [_tblView reloadData];
            }
            
            if (!isRfreshing) {
                [CommonFunctions alertTitle:@"Tonic" withMessage:[NSString stringWithFormat:@"%@",[[responseDictionary objectForKey:@"data"] objectForKey:@"msg"]]];
            }
            else
                [_scrolView setContentOffset:CGPointMake(0.0f, 0.0f)];
        }
        
    } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error - %@",[error localizedDescription]);
        [CommonFunctions removeActivityIndicator];
    }];
}

-(void) hideView{

    [_confrimCustmView setHidden:YES];
}

-(void)tableViewTopMange
{
    if(arrayMreservations.count<3 || arrayMwalkins.count<3)
        _tableBottomConstraint.constant=-309.0f;
    else if (arrayMreservations.count>5 || arrayMwalkins.count>5)
        _tableBottomConstraint.constant=-200.0f;
}

-(void)singleTap{
    
    [self.view endEditing:YES];
    [pView removeFromSuperview];
    [_confrimCustmView setHidden:YES];
    [_confirmationView setHidden:YES];
    [self.bgView setHidden:NO];
    [_mainView bringSubviewToFront:_logoutButton];
    [_mainView bringSubviewToFront:_refreshButton];
    [_tblView reloadData];
}

-(void) tableViewReload{

    [_tblView reloadData];
    
    /*
     * Initially Make Section Collapsed
     */
    [_tblView beginUpdates];
    long numOfRows = [_tblView numberOfRowsInSection:0];
    NSArray* indexPaths = [self indexPathsForSection:0 withNumberOfRows:numOfRows];
    [_tblView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [_collapsedSections addObject:@(0)];
    
    long numOfRows1 = [_tblView numberOfRowsInSection:1];
    NSArray* indexPaths1 = [self indexPathsForSection:1 withNumberOfRows:numOfRows1];
    [_tblView deleteRowsAtIndexPaths:indexPaths1 withRowAnimation:UITableViewRowAnimationFade];
    [_collapsedSections addObject:@(1)];
    [_tblView endUpdates];
    
}

#pragma mark- Collapse row Action

-(void)sectionTouchUpInside:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    NSUInteger numOfRows = 0;
    
    if (view.tag == 0){
        if (arrayMwalkins.count > 0)
            numOfRows = [arrayMwalkins count];
    }
    else if (view.tag == 1){
        if (arrayMreservations.count > 0)
            numOfRows=[arrayMreservations count];
    }
    
    if (numOfRows > 0) {
     
        [_tblView beginUpdates];
        
        _tblView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        
        long section = view.tag;
        
        bool shouldCollapse = ![_collapsedSections containsObject:@(section)];
        if (shouldCollapse)
        {
            long numOfRows = [_tblView numberOfRowsInSection:section];
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            
            if (indexPaths.count > 0)
            {
                [_tblView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

                [_collapsedSections addObject:@(section)];
            }
        }
        else {
            
            NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:numOfRows];
            
            if (indexPaths.count > 0)
            {
                [_tblView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [_collapsedSections removeObject:@(section)];
                
                [_scrolView setContentOffset:CGPointMake(0, 480) animated:YES];
                [_mainView bringSubviewToFront:_scrolView];
            }
        }
    
        [_tblView endUpdates];
    }
}

-(NSArray*) indexPathsForSection:(long)section withNumberOfRows:(long)numberOfRows {
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

#pragma mark- Open Custom PopUp

-(void) animateViewFromTopToBottom:(UIView*)_view hideView:(UIView*) hiddenView showView:(UIView*) showView{

    hiddenView.hidden = YES;
    showView.hidden = NO;
    _view.hidden = NO;
    [_mainView bringSubviewToFront:_view];
//    [_mainView bringSubviewToFront:_logoutButton];
//    [_mainView bringSubviewToFront:_refreshButton];
    _view.frame = CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self performSelector:@selector(show:) withObject:_view afterDelay:0.1];
    
}


-(void)show:(UIView*)_view
{
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void) removeView:(UIView*)_view{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _view.frame = CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                         bottomConstraintPopUpVw.constant = SCREEN_HEIGHT;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                         {
                             _scrolView.contentOffset = CGPointMake(0 , 0);
                             [_mainView bringSubviewToFront:_logoutButton];
                             [_mainView bringSubviewToFront:_refreshButton];
                             [_view setHidden:YES];
                              _view.frame = CGRectMake(0, 0-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                             [_tblView reloadData];
                         }
                     }];
    
}


#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [pView removeFromSuperview];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    else{
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 2;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if ([textField.text length] > 0 && [textField.text length] < 3) {
        
        //Call Api
        
        if ([CommonFunctions connectedToNetwork]) {
            
            [CommonFunctions showActivityIndicatorWithText:@"Submitting.." detailedText:@"Please wait!"];
            
            NSLog(@"selectedUserDictionary:%@",selectedUserDictionary.description);
            
            NSMutableDictionary *paramDictionary = nil;
            NSString *apiNameString = @"";
            
            if (isWalkin == 0)
            {
                NSArray *barbersArr = (NSArray*) [selectedUserDictionary objectForKey:@"Barber"];
                NSMutableArray *barbersIDs = [NSMutableArray array];
                
                for (NSDictionary *barberObj in barbersArr) {
                    
                    if ([self isNotNull:[barberObj objectForKey:@"id"]])
                        [barbersIDs addObject:[barberObj objectForKey:@"id"]];
                }
                NSString *isSeat = APPDELEGATE.isSeatTapped;
                
                NSString *stringWalkinID = [[selectedUserDictionary objectForKey:@"Customer"] objectForKey:@"id"];
                paramDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stringWalkinID,@"wakin_id",textField.text,@"pin",isSeat,@"status",barbersIDs,@"barbers", nil];
                apiNameString = @"update_wakin_status";
            }
            else{
                
                NSString *stringAppointmentID = [[selectedUserDictionary objectForKey:@"Appointment"] objectForKey:@"id"];
                
                paramDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:stringAppointmentID,@"appointment_id",textField.text,@"pin",@"1",@"status", nil];
                apiNameString = @"update_reservation_status";
            }
            
            [self callApi:apiNameString withParams:paramDictionary];
        }
        else
            [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
    }
    else if ([textField.text length] != 0)
    {
        [CommonFunctions alertTitle:@"Tonic" withMessage:@"Please enter correct pin."];
    }
    
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView != _tblView)
    {
        _lastContentOffset.x = scrollView.contentOffset.x;
        _lastContentOffset.y = scrollView.contentOffset.y;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView != _tblView)
    {
        if (_lastContentOffset.y < (int)scrollView.contentOffset.y){
            [_mainView bringSubviewToFront:_scrolView];
        }
        else if (_lastContentOffset.y > (int)scrollView.contentOffset.y+150)
            [_mainView bringSubviewToFront:_bgView];
        
        [_mainView bringSubviewToFront:_logoutButton];
        [_mainView bringSubviewToFront:_refreshButton];
    }
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(scrollView != _tblView)
    {
        if (_lastContentOffset.y < (int)scrollView.contentOffset.y)
        {
            [_mainView bringSubviewToFront:_scrolView];
            [self.view bringSubviewToFront:self.tblView];
        }
        else if (_lastContentOffset.y > (int)scrollView.contentOffset.y+150)
            [_mainView bringSubviewToFront:_bgView];
        
        [_mainView bringSubviewToFront:_logoutButton];
        [_mainView bringSubviewToFront:_refreshButton];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView != _tblView)
    {
        if (_lastContentOffset.y < (int)scrollView.contentOffset.y){
            
            [_mainView bringSubviewToFront:_scrolView];
        }
        
        [_mainView bringSubviewToFront:_logoutButton];
        [_mainView bringSubviewToFront:_refreshButton];
    }
}

-(void) refreshWalkinsReservations{

    _scrolView.contentOffset = CGPointMake(0, 0);
    [_mainView bringSubviewToFront:_bgView];
    [pView removeFromSuperview];
    
    [_mainView bringSubviewToFront:_logoutButton];
    [_mainView bringSubviewToFront:_refreshButton];
    if ([CommonFunctions connectedToNetwork]) {
        
        [CommonFunctions showActivityIndicatorWithText:@"Loading.." detailedText:@"Keep Patience!"];
        [self callApi:@"reservation_walkins" withParams:nil];
    }
    else
        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
}
//-(void) refreshWalkinsReservations1{
//    
//   
//    if ([CommonFunctions connectedToNetwork]) {
//        
//        [CommonFunctions showActivityIndicatorWithText:@"Loading.." detailedText:@"Keep Patience!"];
//        [self callApi:@"reservation_walkins" withParams:nil];
//    }
//    else
//        [CommonFunctions alertTitle:@"Tonic" withMessage:NSLocalizedString(@"NETWORK_LOST", nil)];
//}

-(void) showWalkinEdit:(NSDictionary*)custDict{

    self.bgView.hidden = YES;
    
    CGRect frame = self.view.frame;
    frame.origin.y -= 50.0f;
    
    NSString *strName = [[custDict objectForKey:@"Customer"] objectForKey:@"name"];
    
    pView = [[PopUpView alloc] initWithFrame:frame withCheckIn:1 == 1 ? YES : NO];
    pView.delegate = self;
    pView.txtUserName.text = strName;
    pView.customerDict = custDict;
    pView.isEditingMode = YES;
    
    [pView setUnHideView:^
     {
         self.bgView.hidden = NO;
     }];
    
    if (![pView isDescendantOfView:self.view]) {
        
        pView.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:pView];
    }
    
    [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:7.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        pView.center = self.view.center;
    } completion:^(BOOL finished) {
    }];
}


@end
